'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import RoleGuard, { usePermissions } from '@/components/auth/RoleGuard';
import { Permission } from '@/types/auth';
import { TrendingUp, Users, CreditCard, BarChart2, Activity, Clock } from 'lucide-react';

export default function DashboardContent() {
  const { user, loading, hasPermission, isAdmin } = usePermissions();
  const router = useRouter();

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

      {/* Overview Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Sales Overview */}
        <RoleGuard 
          requiredPermission={Permission.SALES_VIEW_LEADS}
          user={user}
        >
          <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Sales Overview</h3>
              <TrendingUp className="h-6 w-6 text-blue-500" />
            </div>
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">Active Leads</p>
                  <p className="text-2xl font-bold text-gray-900">24</p>
                </div>
                <Badge className="bg-blue-50 text-blue-700">+12% ↑</Badge>
              </div>
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">Quotations</p>
                  <p className="text-2xl font-bold text-gray-900">12</p>
                </div>
                <Badge className="bg-green-50 text-green-700">73.2% ↑</Badge>
              </div>
            </div>
          </Card>
        </RoleGuard>

        {/* Accounting Overview */}
        <RoleGuard 
          requiredPermission={Permission.ACCOUNTING_VIEW_INVOICES}
          user={user}
        >
          <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Financial Overview</h3>
              <CreditCard className="h-6 w-6 text-emerald-500" />
            </div>
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">Pending Invoices</p>
                  <p className="text-2xl font-bold text-gray-900">8</p>
                </div>
                <p className="text-lg font-semibold text-orange-600">₹2,45,000</p>
              </div>
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-gray-600">Monthly Collection</p>
                  <p className="text-2xl font-bold text-emerald-600">₹8,75,000</p>
                </div>
                <Badge className="bg-emerald-50 text-emerald-700">On Track</Badge>
              </div>
            </div>
          </Card>
        </RoleGuard>

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

      {/* Organization Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold text-gray-900">Organization Overview</h3>
            <Users className="h-6 w-6 text-indigo-500" />
          </div>
          <div className="grid grid-cols-2 gap-6">
            <div>
              <p className="text-sm text-gray-600">Total Employees</p>
              <p className="text-2xl font-bold text-gray-900">45</p>
            </div>
            <div>
              <p className="text-sm text-gray-600">Active Branches</p>
              <p className="text-2xl font-bold text-gray-900">6</p>
            </div>
          </div>
        </Card>

        <Card className="p-6 hover:shadow-lg transition-shadow duration-200">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold text-gray-900">Performance Metrics</h3>
            <BarChart2 className="h-6 w-6 text-teal-500" />
          </div>
          <div className="grid grid-cols-2 gap-6">
            <div>
              <p className="text-sm text-gray-600">Processing Rate</p>
              <div className="flex items-baseline">
                <p className="text-2xl font-bold text-gray-900">94.2</p>
                <span className="ml-1 text-sm text-gray-600">%</span>
              </div>
            </div>
            <div>
              <p className="text-sm text-gray-600">System Health</p>
              <Badge className="mt-2 bg-emerald-50 text-emerald-700">Excellent</Badge>
            </div>
          </div>
        </Card>
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
            <p className="mt-1 font-medium text-gray-900">EMP-25-0001</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Full Name</p>
            <p className="mt-1 font-medium text-gray-900">Vikas Alagarsamy</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Email</p>
            <p className="mt-1 font-medium text-gray-900">vikas@ooak.photography</p>
          </div>
          <div>
            <p className="text-sm text-gray-600">Role</p>
            <Badge className="mt-2" variant="outline">MANAGING DIRECTOR</Badge>
          </div>
        </div>
      </Card>
    </div>
  );
} 