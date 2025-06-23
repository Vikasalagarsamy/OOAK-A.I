import { AuthUser, Permission, ROLE_PERMISSIONS } from '@/types/auth';

export class AuthClientService {
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
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ employee_id, password }),
        credentials: 'include',
      });

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, message: 'Network error' };
    }
  }

  // Logout user
  static async logout(): Promise<boolean> {
    try {
      const response = await fetch('/api/auth/logout', {
        method: 'POST',
        credentials: 'include',
      });

      return response.ok;
    } catch (error) {
      console.error('Logout error:', error);
      return false;
    }
  }
} 