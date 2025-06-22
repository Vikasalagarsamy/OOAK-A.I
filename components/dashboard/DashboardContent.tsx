'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import RoleGuard, { usePermissions } from '@/components/auth/RoleGuard';
import { Permission } from '@/types/auth';

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
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-purple-600"></div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-gray-900">OOAK.AI</h1>
              <Badge className="ml-3 bg-purple-100 text-purple-800">
                Employee Portal
              </Badge>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-600">
                Welcome, {user.first_name} {user.last_name}
              </span>
              <Badge variant="outline">
                {user.designation.name}
              </Badge>
              <Button 
                onClick={handleLogout}
                variant="outline"
                size="sm"
              >
                Logout
              </Button>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Sidebar Navigation */}
          <div className="lg:col-span-1">
            <Card className="p-6">
              <h2 className="text-lg font-semibold mb-4">Navigation</h2>
              <nav className="space-y-2">
                <Button 
                  variant="ghost" 
                  className="w-full justify-start"
                  onClick={() => router.push('/dashboard')}
                >
                  Dashboard
                </Button>

                {/* Sales Navigation */}
                <RoleGuard 
                  requiredPermission={Permission.SALES_VIEW_LEADS}
                  user={user}
                >
                  <div className="space-y-1">
                    <p className="text-xs font-medium text-gray-500 uppercase tracking-wide px-3 py-2">
                      Sales
                    </p>
                    <Button 
                      variant="ghost" 
                      className="w-full justify-start pl-6"
                      onClick={() => alert('Leads page - Coming soon!')}
                    >
                      Leads
                    </Button>
                    <RoleGuard 
                      requiredPermission={Permission.SALES_VIEW_QUOTATIONS}
                      user={user}
                    >
                      <Button 
                        variant="ghost" 
                        className="w-full justify-start pl-6"
                        onClick={() => alert('Quotations page - Coming soon!')}
                      >
                        Quotations
                      </Button>
                    </RoleGuard>
                    <RoleGuard 
                      requiredPermission={Permission.SALES_VIEW_REPORTS}
                      user={user}
                    >
                      <Button 
                        variant="ghost" 
                        className="w-full justify-start pl-6"
                        onClick={() => alert('Sales Reports - Coming soon!')}
                      >
                        Reports
                      </Button>
                    </RoleGuard>
                  </div>
                </RoleGuard>

                {/* Accounting Navigation */}
                <RoleGuard 
                  requiredPermission={Permission.ACCOUNTING_VIEW_INVOICES}
                  user={user}
                >
                  <div className="space-y-1">
                    <p className="text-xs font-medium text-gray-500 uppercase tracking-wide px-3 py-2">
                      Accounting
                    </p>
                    <Button 
                      variant="ghost" 
                      className="w-full justify-start pl-6"
                      onClick={() => alert('Invoices page - Coming soon!')}
                    >
                      Invoices
                    </Button>
                    <RoleGuard 
                      requiredPermission={Permission.ACCOUNTING_VIEW_PAYMENTS}
                      user={user}
                    >
                      <Button 
                        variant="ghost" 
                        className="w-full justify-start pl-6"
                        onClick={() => alert('Payments page - Coming soon!')}
                      >
                        Payments
                      </Button>
                    </RoleGuard>
                  </div>
                </RoleGuard>

                {/* Admin Navigation */}
                {isAdmin && (
                  <div className="space-y-1">
                    <p className="text-xs font-medium text-gray-500 uppercase tracking-wide px-3 py-2">
                      Admin
                    </p>
                    <Button 
                      variant="ghost" 
                      className="w-full justify-start pl-6"
                      onClick={() => alert('Employee Management - Coming soon!')}
                    >
                      Employees
                    </Button>
                    <Button 
                      variant="ghost" 
                      className="w-full justify-start pl-6"
                      onClick={() => alert('System Settings - Coming soon!')}
                    >
                      Settings
                    </Button>
                  </div>
                )}
              </nav>
            </Card>
          </div>

          {/* Main Content */}
          <div className="lg:col-span-3">
            <div className="space-y-6">
              {/* Welcome Card */}
              <Card className="p-6">
                <h2 className="text-xl font-semibold mb-2">
                  Welcome back, {user.first_name}!
                </h2>
                <p className="text-gray-600 mb-4">
                  You're logged in as <strong>{user.designation.name}</strong>
                </p>
                <div className="flex flex-wrap gap-2">
                  {user.permissions.map((permission) => (
                    <Badge key={permission} variant="secondary" className="text-xs">
                      {permission.split(':')[1]?.replace('_', ' ')}
                    </Badge>
                  ))}
                </div>
              </Card>

              {/* Role-Based Content */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Sales Dashboard */}
                <RoleGuard 
                  requiredPermission={Permission.SALES_VIEW_LEADS}
                  user={user}
                >
                  <Card className="p-6">
                    <h3 className="text-lg font-semibold mb-4">Sales Overview</h3>
                    <div className="space-y-3">
                      <div className="flex justify-between">
                        <span className="text-gray-600">Active Leads</span>
                        <span className="font-semibold">24</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-600">Quotations Sent</span>
                        <span className="font-semibold">12</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-600">Conversion Rate</span>
                        <span className="font-semibold text-green-600">73.2%</span>
                      </div>
                    </div>
                  </Card>
                </RoleGuard>

                {/* Accounting Dashboard */}
                <RoleGuard 
                  requiredPermission={Permission.ACCOUNTING_VIEW_INVOICES}
                  user={user}
                >
                  <Card className="p-6">
                    <h3 className="text-lg font-semibold mb-4">Accounting Overview</h3>
                    <div className="space-y-3">
                      <div className="flex justify-between">
                        <span className="text-gray-600">Pending Invoices</span>
                        <span className="font-semibold">8</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-600">Payments Due</span>
                        <span className="font-semibold text-orange-600">₹2,45,000</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-gray-600">Collected This Month</span>
                        <span className="font-semibold text-green-600">₹8,75,000</span>
                      </div>
                    </div>
                  </Card>
                </RoleGuard>

                {/* Admin Dashboard */}
                {isAdmin && (
                  <>
                    <Card className="p-6">
                      <h3 className="text-lg font-semibold mb-4">System Overview</h3>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-gray-600">Total Employees</span>
                          <span className="font-semibold">45</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-600">Active Branches</span>
                          <span className="font-semibold">6</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-600">System Health</span>
                          <Badge className="bg-green-100 text-green-800">Excellent</Badge>
                        </div>
                      </div>
                    </Card>

                    <Card className="p-6">
                      <h3 className="text-lg font-semibold mb-4">AI Performance</h3>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-gray-600">AI Efficiency</span>
                          <span className="font-semibold text-green-600">98.5%</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-600">Response Time</span>
                          <span className="font-semibold">2.3 min</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-600">Automation Rate</span>
                          <span className="font-semibold text-blue-600">94.2%</span>
                        </div>
                      </div>
                    </Card>
                  </>
                )}
              </div>

              {/* Employee Profile */}
              <Card className="p-6">
                <h3 className="text-lg font-semibold mb-4">Your Profile</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium text-gray-600">Employee ID</label>
                    <p className="font-semibold">{user.employee_id}</p>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-gray-600">Full Name</label>
                    <p className="font-semibold">{user.first_name} {user.last_name}</p>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-gray-600">Email</label>
                    <p className="font-semibold">{user.email || 'Not provided'}</p>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-gray-600">Designation</label>
                    <p className="font-semibold">{user.designation.name}</p>
                  </div>
                </div>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 