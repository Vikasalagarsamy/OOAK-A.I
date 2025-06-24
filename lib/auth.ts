import bcrypt from 'bcryptjs';
import { cookies } from 'next/headers';
import { query } from './db';
import { AuthUser, JWTPayload, Permission, ROLE_PERMISSIONS } from '@/types/auth';
import { jwtVerify, SignJWT } from 'jose';
import { NextAuthOptions } from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

const JWT_SECRET = new TextEncoder().encode(process.env.JWT_SECRET || 'your-secret-key');
const JWT_EXPIRES_IN = '7d';
const COOKIE_NAME = 'ooak_auth_token';

interface Credentials {
  username: string;
  password: string;
}

interface EmployeeAuthData {
  id: number;
  employee_id: string;
  first_name: string;
  last_name: string;
  email: string;
  designation_id: number;
}

export class AuthService {
  // Hash password using bcrypt
  static async hashPassword(password: string): Promise<string> {
    const saltRounds = 12;
    return bcrypt.hash(password, saltRounds);
  }

  // Verify password against hash
  static async verifyPassword(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }

  // Generate JWT token using jose
  static async generateToken(payload: JWTPayload): Promise<string> {
    const token = await new SignJWT(payload)
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime(JWT_EXPIRES_IN)
      .sign(JWT_SECRET);
    return token;
  }

  // Verify JWT token using jose
  static async verifyToken(token: string): Promise<JWTPayload | null> {
    try {
      const { payload } = await jwtVerify(token, JWT_SECRET);
      return payload as JWTPayload;
    } catch (error) {
      console.error('Token verification error:', error);
      return null;
    }
  }

  // Set authentication cookie
  static setAuthCookie(token: string): void {
    const cookieStore = cookies();
    cookieStore.set(COOKIE_NAME, token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60, // 7 days
      path: '/',
    });
  }

  // Get authentication cookie
  static getAuthCookie(): string | null {
    try {
      const cookieStore = cookies();
      const cookie = cookieStore.get(COOKIE_NAME);
      return cookie?.value || null;
    } catch (error) {
      return null;
    }
  }

  // Clear authentication cookie
  static clearAuthCookie(): void {
    const cookieStore = cookies();
    cookieStore.delete(COOKIE_NAME);
  }

  // Get user permissions based on designation
  static getUserPermissions(designationName: string): Permission[] {
    const normalizedDesignation = designationName.toUpperCase();
    return ROLE_PERMISSIONS[normalizedDesignation] || ROLE_PERMISSIONS['DEFAULT'];
  }

  // Check if user has specific permission
  static hasPermission(userPermissions: Permission[], requiredPermission: Permission): boolean {
    return userPermissions.includes(Permission.ADMIN_FULL_ACCESS) || 
           userPermissions.includes(requiredPermission);
  }

  // Authenticate user by employee_id and password
  static async authenticateUser(employee_id: string, password: string): Promise<AuthUser | null> {
    try {
      // Get employee with designation
      const result = await query(`
        SELECT 
          e.id,
          e.employee_id,
          e.first_name,
          e.last_name,
          e.email,
          e.department_id,
          e.designation_id,
          e.password_hash,
          d.name as designation_name
        FROM employees e
        LEFT JOIN designations d ON e.designation_id = d.id
        WHERE e.employee_id = $1 AND e.status = 'active'
      `, [employee_id]);

      if (!result.success || !result.data || result.data.length === 0) {
        return null;
      }

      const employee = result.data[0];

      // Check if password hash exists
      if (!employee.password_hash) {
        return null;
      }

      // Verify password
      const isValidPassword = await this.verifyPassword(password, employee.password_hash);
      if (!isValidPassword) {
        return null;
      }

      // Get user permissions
      const permissions = this.getUserPermissions(employee.designation_name || '');

      // Return authenticated user
      return {
        id: employee.id,
        employee_id: employee.employee_id,
        first_name: employee.first_name,
        last_name: employee.last_name,
        email: employee.email,
        designation: {
          id: employee.designation_id,
          name: employee.designation_name || 'Unknown',
        },
        department_id: employee.department_id,
        permissions,
      };
    } catch (error) {
      console.error('Authentication error:', error);
      return null;
    }
  }

  // Get current user from token
  static async getCurrentUser(token?: string): Promise<AuthUser | null> {
    try {
      const authToken = token || this.getAuthCookie();
      if (!authToken) {
        return null;
      }

      const payload = await this.verifyToken(authToken);
      if (!payload) {
        return null;
      }

      // Get fresh user data
      const result = await query(`
        SELECT 
          e.id,
          e.employee_id,
          e.first_name,
          e.last_name,
          e.email,
          e.department_id,
          e.designation_id,
          d.name as designation_name,
          ARRAY_AGG(DISTINCT dmp.menu_item_id) as permissions
        FROM employees e
        LEFT JOIN designations d ON e.designation_id = d.id
        LEFT JOIN designation_menu_permissions dmp ON d.id = dmp.designation_id AND dmp.can_view = true
        WHERE e.id = $1 AND e.is_active = true
        GROUP BY e.id, e.first_name, e.last_name, e.email, e.department_id, e.designation_id, d.name
      `, [payload.userId]);

      if (!result.success || !result.data || result.data.length === 0) {
        return null;
      }

      const employee = result.data[0];
      const permissions = this.getUserPermissions(employee.designation_name || '');

      return {
        id: employee.id,
        employee_id: employee.employee_id,
        first_name: employee.first_name,
        last_name: employee.last_name,
        email: employee.email,
        designation: {
          id: employee.designation_id,
          name: employee.designation_name || 'Unknown',
        },
        department_id: employee.department_id,
        permissions,
      };
    } catch (error) {
      console.error('Get current user error:', error);
      return null;
    }
  }

  // Create default password for testing (remove in production)
  static async createDefaultPassword(employee_id: string, password: string = 'password123'): Promise<boolean> {
    try {
      const hashedPassword = await this.hashPassword(password);
      await query(`
        UPDATE employees 
        SET password_hash = $1 
        WHERE employee_id = $2
      `, [hashedPassword, employee_id]);
      return true;
    } catch (error) {
      console.error('Create default password error:', error);
      return false;
    }
  }
}

// Middleware helper for API routes
export async function requireAuth(request: Request): Promise<AuthUser | null> {
  const token = request.headers.get('Authorization')?.replace('Bearer ', '') ||
                request.headers.get('Cookie')?.split('ooak_auth_token=')[1]?.split(';')[0];
  
  if (!token) {
    return null;
  }

  return AuthService.getCurrentUser(token);
}

// Permission check helper for API routes
export function requirePermission(user: AuthUser | null, permission: Permission): boolean {
  if (!user) {
    return false;
  }

  return AuthService.hasPermission(user.permissions, permission);
}

export async function verifyAuth(token: string): Promise<JWTPayload | null> {
  try {
    const { payload } = await jwtVerify(token, JWT_SECRET);
    return {
      userId: payload.userId as number,
      employee_id: payload.employee_id as string,
      designation_id: payload.designation_id as number
    };
  } catch (error) {
    console.error('Token verification error:', error);
    return null;
  }
}

export async function signToken(payload: JWTPayload): Promise<string> {
  try {
    const token = await new SignJWT({
      userId: payload.userId,
      employee_id: payload.employee_id,
      designation_id: payload.designation_id
    })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime(JWT_EXPIRES_IN)
      .sign(JWT_SECRET);
    return token;
  } catch (error) {
    console.error('Token signing error:', error);
    throw error;
  }
}

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials, req) {
        console.log('Starting authorization for:', credentials?.username);

        if (!credentials?.username || !credentials?.password) {
          console.log('Missing credentials');
          return null;
        }

        try {
          console.log('Querying database for user:', credentials.username);
          
          // First, get the user without joins to verify they exist
          const userResult = await query(`
            SELECT 
              id,
              employee_id,
              first_name,
              last_name,
              email,
              password_hash,
              designation_id,
              is_active
            FROM employees 
            WHERE employee_id = $1
          `, [credentials.username]);

          console.log('Initial user query result:', {
            success: userResult.success,
            hasData: userResult.data && userResult.data.length > 0
          });

          if (!userResult.success || !userResult.data || userResult.data.length === 0) {
            console.log('User not found:', credentials.username);
            return null;
          }

          const user = userResult.data[0];

          if (!user.is_active) {
            console.log('User is not active:', credentials.username);
            return null;
          }

          // Verify password using bcrypt
          console.log('Verifying password for user:', credentials.username);
          const isValidPassword = await bcrypt.compare(credentials.password, user.password_hash);
          
          if (!isValidPassword) {
            console.log('Invalid password for user:', credentials.username);
            return null;
          }

          // Now get additional user data
          const detailsResult = await query(`
            SELECT 
              d.name as designation_name,
              ARRAY_AGG(DISTINCT dmp.menu_item_id) as permissions
            FROM designations d
            LEFT JOIN designation_menu_permissions dmp ON d.id = dmp.designation_id AND dmp.can_view = true
            WHERE d.id = $1
            GROUP BY d.name
          `, [user.designation_id]);

          console.log('User details query result:', {
            success: detailsResult.success,
            hasData: detailsResult.data && detailsResult.data.length > 0
          });

          const details = detailsResult.data?.[0] || { designation_name: null, permissions: [] };

          console.log('Authentication successful for:', credentials.username);

          return {
            id: user.id.toString(),
            employee_id: user.employee_id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email || undefined,
            designation: {
              id: user.designation_id,
              name: details.designation_name || ''
            },
            permissions: details.permissions || []
          };
        } catch (error) {
          console.error('Auth error:', error);
          return null;
        }
      }
    })
  ],
  pages: {
    signIn: '/login',
    error: '/login',
  },
  callbacks: {
    async jwt({ token, user }) {
      console.log('JWT Callback:', {
        hasUser: !!user,
        tokenId: token?.id
      });

      if (user) {
        token.id = user.id;
        token.employee_id = user.employee_id;
        token.first_name = user.first_name;
        token.last_name = user.last_name;
        token.email = user.email || undefined;
        token.designation = user.designation;
        token.permissions = user.permissions;
      }
      return token;
    },
    async session({ session, token }) {
      console.log('Session Callback:', {
        hasToken: !!token,
        sessionUserId: session?.user?.id
      });

      if (token) {
        session.user.id = token.id;
        session.user.employee_id = token.employee_id;
        session.user.first_name = token.first_name;
        session.user.last_name = token.last_name;
        session.user.email = token.email || undefined;
        session.user.designation = token.designation;
        session.user.permissions = token.permissions;
      }
      return session;
    }
  },
  session: {
    strategy: 'jwt',
    maxAge: 24 * 60 * 60, // 24 hours
  },
  debug: true, // Enable debug mode
}; 