'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import RoleGuard, { usePermissions } from '@/components/auth/RoleGuard';
import { Permission } from '@/types/auth';
import { TrendingUp, Users, CreditCard, BarChart2, Activity, Clock } from 'lucide-react';
import { DashboardStats } from '@/types/database';

export default function DashboardContent() {
  const { user, loading, hasPermission, isAdmin } = usePermissions();
  const router = useRouter();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await fetch('/api/dashboard');
        const data = await response.json();
        
        if (data.success) {
          setStats(data.data);
        } else {
          setError(data.error || 'Failed to fetch dashboard data');
        }
      } catch (error) {
        setError('Error fetching dashboard data');
        console.error('Dashboard fetch error:', error);
      }
    };

    fetchStats();
  }, []);

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

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="space-y-8">
      {/* Welcome Section */}
      <div>
        <h1 className="text-2xl font-semibold text-gray-900">Welcome back, {user.first_name}!</h1>
        <p className="mt-1 text-gray-600">Here's what's happening in your organization today.</p>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded relative" role="alert">
          <strong className="font-bold">Error: </strong>
          <span className="block sm:inline">{error}</span>
        </div>
      )}

      {/* Overview Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Organization Stats */}
        <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Organization Overview</h3>
            <Users className="h-6 w-6 text-blue-500" />
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <p className="text-sm text-gray-600">Total Employees</p>
                <p className="text-2xl font-bold text-gray-900">{stats?.total_employees || 0}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600">Total Designations</p>
                <p className="text-2xl font-bold text-gray-900">{stats?.total_designations || 0}</p>
              </div>
            </div>
          </div>
        </Card>

        {/* Menu Stats */}
        <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Menu Overview</h3>
            <BarChart2 className="h-6 w-6 text-emerald-500" />
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <p className="text-sm text-gray-600">Total Menu Items</p>
                <p className="text-2xl font-bold text-gray-900">{stats?.total_menu_items || 0}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600">Total Permissions</p>
                <p className="text-2xl font-bold text-gray-900">{stats?.total_permissions || 0}</p>
              </div>
            </div>
          </div>
        </Card>

        {/* System Overview */}
        {isAdmin && (
          <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">System Health</h3>
              <Activity className="h-6 w-6 text-purple-500" />
            </div>
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">System Efficiency</p>
                  <p className="text-2xl font-bold text-gray-900">98.5%</p>
                </div>
                <Badge className="bg-purple-50 text-purple-700">Excellent</Badge>
              </div>
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">Response Time</p>
                  <div className="flex items-center">
                    <p className="text-2xl font-bold text-gray-900">2.3</p>
                    <span className="ml-1 text-gray-600">min</span>
                  </div>
                </div>
                <Badge className="bg-blue-50 text-blue-700">94.2% ↑</Badge>
              </div>
            </div>
          </Card>
        )}
      </div>

      {/* User Profile Section */}
      <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-lg font-semibold text-gray-900">Your Profile</h3>
          <Clock className="h-6 w-6 text-gray-400" />
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          <div>
            <p className="text-sm text-gray-600">Employee ID</p>
            <p className="mt-1 font-medium text-gray-900">{user.employee_id || 'N/A'}</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Full Name</p>
            <p className="mt-1 font-medium text-gray-900">{`${user.first_name} ${user.last_name}`}</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Email</p>
            <p className="mt-1 font-medium text-gray-900">{user.email}</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Role</p>
            <Badge className="mt-2" variant="outline">{user.designation?.name || 'N/A'}</Badge>
          </div>
        </div>
      </Card>
    </div>
  );
} 