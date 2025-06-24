'use client';

import { useEffect, useState } from 'react';
import { AuthUser, Permission } from '@/types/auth';
import { AuthClientService } from '@/lib/auth-client';

interface RoleGuardProps {
  children: React.ReactNode;
  requiredPermission: Permission;
  fallback?: React.ReactNode;
  user?: AuthUser | null;
}

export default function RoleGuard({ 
  children, 
  requiredPermission, 
  fallback,
  user: providedUser 
}: RoleGuardProps) {
  const [user, setUser] = useState<AuthUser | null>(providedUser || null);
  const [loading, setLoading] = useState(!providedUser);

  useEffect(() => {
    if (!providedUser) {
      const fetchUser = async () => {
        try {
          const userData = await AuthClientService.getCurrentUser();
          if (userData) {
            setUser(userData);
          }
        } catch (error) {
          console.error('Failed to fetch user:', error);
        } finally {
          setLoading(false);
        }
      };

      fetchUser();
    }
  }, [providedUser]);

  if (loading) {
    return (
      <div className="animate-pulse">
        <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
        <div className="h-4 bg-gray-200 rounded w-1/2"></div>
      </div>
    );
  }

  if (!user) {
    return fallback || null;
  }

  const userHasPermission = AuthClientService.hasPermission(user.designation_id, requiredPermission);

  if (!userHasPermission) {
    return fallback || (
      <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
        <p className="text-red-800 text-sm">
          You don't have permission to access this feature.
        </p>
      </div>
    );
  }

  return <>{children}</>;
}

// Hook for checking permissions in components
export function usePermissions() {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        const userData = await AuthClientService.getCurrentUser();
        if (userData) {
          setUser(userData);
        }
      } catch (error) {
        console.error('Failed to fetch user:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, []);

  const checkPermission = (permission: Permission) => {
    if (!user) return false;
    return AuthClientService.hasPermission(user.designation_id, permission);
  };

  return {
    user,
    loading,
    hasPermission: checkPermission,
    isAdmin: user ? AuthClientService.hasPermission(user.designation_id, Permission.ADMIN_FULL_ACCESS) : false,
  };
} 