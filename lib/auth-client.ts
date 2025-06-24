import { AuthUser, Permission, ROLE_PERMISSIONS } from '@/types/auth';
import { signIn, signOut } from 'next-auth/react';

export class AuthClientService {
  // Get user permissions based on designation
  static getUserPermissions(designationName: string): Permission[] {
    const normalizedDesignation = designationName.toUpperCase();
    return ROLE_PERMISSIONS[normalizedDesignation] || ROLE_PERMISSIONS['DEFAULT'];
  }

  // Check if user has specific permission based on designation name
  static hasPermission(designationId: number, requiredPermission: Permission, designationName?: string): boolean {
    if (!designationName) return false;
    const normalizedDesignation = designationName.toUpperCase();
    const permissions = ROLE_PERMISSIONS[normalizedDesignation] || ROLE_PERMISSIONS['DEFAULT'];
    return permissions.includes(Permission.ADMIN_FULL_ACCESS) || 
           permissions.includes(requiredPermission);
  }

  // Get current user from API
  static async getCurrentUser(): Promise<AuthUser | null> {
    try {
      const response = await fetch('/api/auth/me', {
        credentials: 'include',
      });

      if (response.ok) {
        const data = await response.json();
        if (data.success) {
          return data.user;
        }
      }
      return null;
    } catch (error) {
      console.error('Get current user error:', error);
      return null;
    }
  }

  // Login user
  static async login(employee_id: string, password: string): Promise<{ success: boolean; user?: AuthUser; message?: string }> {
    try {
      const result = await signIn('credentials', {
        username: employee_id,
        password: password,
        redirect: false,
      });

      if (result?.error) {
        return { success: false, message: 'Invalid credentials' };
      }

      const user = await this.getCurrentUser();
      return { success: true, user: user || undefined };
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, message: 'Network error' };
    }
  }

  // Logout user
  static async logout(): Promise<boolean> {
    try {
      await signOut({ redirect: false });
      return true;
    } catch (error) {
      console.error('Logout error:', error);
      return false;
    }
  }
} 