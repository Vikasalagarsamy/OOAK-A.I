'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { AuthUser } from '@/types/auth';

interface ProtectedRouteProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export default function ProtectedRoute({ children, fallback }: ProtectedRouteProps) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    let mounted = true;

    const checkAuth = async () => {
      try {
        const response = await fetch('/api/auth/me', {
          credentials: 'include',
          headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache'
          }
        });

        if (!mounted) return;

        if (response.ok) {
          const data = await response.json();
          if (data.success && data.user) {
            setUser(data.user);
          } else {
            // Clear any stale state
            setUser(null);
            // Use router for client-side navigation
            router.replace('/login');
          }
        } else {
          // Clear any stale state
          setUser(null);
          // Use router for client-side navigation
          router.replace('/login');
        }
      } catch (error) {
        console.error('Auth check failed:', error);
        if (mounted) {
          setUser(null);
          router.replace('/login');
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    };

    // Initial auth check
    checkAuth();

    // Set up periodic auth check every 5 minutes
    const interval = setInterval(checkAuth, 5 * 60 * 1000);

    // Cleanup function
    return () => {
      mounted = false;
      clearInterval(interval);
    };
  }, [router]);

  // Show loading state
  if (loading) {
    return (
      fallback || (
        <div className="min-h-screen flex items-center justify-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-purple-600"></div>
        </div>
      )
    );
  }

  // If no user, the useEffect will handle redirect
  if (!user) {
    return null;
  }

  // Render children with user context
  return <>{children}</>;
} 