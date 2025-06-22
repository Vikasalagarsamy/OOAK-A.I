'use client';

import { useRouter } from 'next/navigation';
import ProtectedRoute from '@/components/auth/ProtectedRoute';
import { Sidebar } from '@/components/ui/sidebar';
import { Button } from '@/components/ui/button';
import { usePermissions } from '@/components/auth/RoleGuard';
import { LogOut } from 'lucide-react';

export default function AuthenticatedLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const router = useRouter();
  const { user } = usePermissions();

  const handleLogout = async () => {
    try {
      await fetch('/api/auth/logout', {
        method: 'POST',
        credentials: 'include',
      });
      window.location.href = '/login';
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  return (
    <ProtectedRoute>
      <div className="flex min-h-screen bg-gray-50">
        {/* Fixed sidebar */}
        <aside className="fixed left-0 top-0 z-30 h-screen w-64 border-r bg-white">
          <Sidebar />
        </aside>
        
        {/* Main content area with padding for sidebar */}
        <main className="flex-1 ml-64">
          {/* Header area */}
          <header className="sticky top-0 z-20 border-b bg-white shadow-sm">
            <div className="flex h-16 items-center justify-between px-6">
              <h1 className="text-2xl font-semibold text-gray-800">OOAK AI</h1>
              
              <div className="flex items-center gap-6">
                <div className="text-right">
                  <div className="text-sm font-medium text-gray-900">{user?.first_name} {user?.last_name}</div>
                  <div className="text-xs text-gray-500">{user?.designation?.name}</div>
                </div>
                <Button 
                  variant="outline" 
                  size="sm"
                  onClick={handleLogout}
                  className="text-gray-600 hover:text-gray-900"
                >
                  <LogOut className="h-4 w-4 mr-2" />
                  Logout
                </Button>
              </div>
            </div>
          </header>

          {/* Scrollable content area */}
          <div className="relative">
            <div className="p-8">
              {children}
            </div>
          </div>
        </main>
      </div>
    </ProtectedRoute>
  );
} 