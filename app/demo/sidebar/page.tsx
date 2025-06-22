'use client';

import React, { useState } from 'react';
import DynamicSidebar from '@/components/navigation/DynamicSidebar';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Users, Settings, Shield, Eye } from 'lucide-react';

const SidebarDemo: React.FC = () => {
  const [selectedEmployee, setSelectedEmployee] = useState(1);

  const employees = [
    { id: 1, name: 'Vikas Alagarsamy', department: 'MANAGEMENT', role: 'Manager' },
    { id: 2, name: 'Pradeep Ravi', department: 'MANAGEMENT', role: 'Manager' },
    { id: 3, name: 'Dhinakaran Bose', department: 'OFFICE ADMINISTRATION', role: 'Admin Staff' },
    { id: 4, name: 'Sample Sales', department: 'SALES', role: 'Sales Executive' },
    { id: 5, name: 'Sample Photographer', department: 'PHOTOGRAPHY', role: 'Photographer' },
  ];

  const selectedEmp = employees.find(e => e.id === selectedEmployee) || employees[0];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="flex">
        {/* Dynamic Sidebar */}
        <div className="w-80 flex-shrink-0">
          <DynamicSidebar 
            employeeId={selectedEmployee} 
            className="h-screen"
          />
        </div>

        {/* Main Content */}
        <div className="flex-1 p-8">
          <div className="max-w-4xl mx-auto">
            {/* Header */}
            <div className="mb-8">
              <h1 className="text-4xl font-bold text-gray-900 mb-2 flex items-center gap-3">
                <Shield className="h-10 w-10 text-blue-600" />
                Dynamic Sidebar Demo
              </h1>
              <p className="text-lg text-gray-600">
                Test role-based menu system with different employee permissions
              </p>
              <Badge variant="secondary" className="mt-2">
                🔐 Role-Based Access Control System
              </Badge>
            </div>

            {/* Employee Selection */}
            <Card className="mb-8">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="h-5 w-5" />
                  Switch Employee Role
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {employees.map((emp) => (
                    <button
                      key={emp.id}
                      onClick={() => setSelectedEmployee(emp.id)}
                      className={`
                        p-4 rounded-lg border-2 text-left transition-all duration-200
                        ${selectedEmployee === emp.id 
                          ? 'border-blue-500 bg-blue-50 shadow-md' 
                          : 'border-gray-200 bg-white hover:border-gray-300'
                        }
                      `}
                    >
                      <div className="font-semibold text-gray-900">{emp.name}</div>
                      <div className="text-sm text-gray-600">{emp.department}</div>
                      <Badge variant="outline" className="mt-2">
                        {emp.role}
                      </Badge>
                    </button>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Current Selection Info */}
            <Card className="mb-8 border-l-4 border-l-blue-500">
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-xl font-semibold text-gray-900">
                      Current User: {selectedEmp.name}
                    </h3>
                    <p className="text-gray-600">
                      Department: {selectedEmp.department} | Role: {selectedEmp.role}
                    </p>
                  </div>
                  <Badge variant="secondary">Employee ID: {selectedEmployee}</Badge>
                </div>
              </CardContent>
            </Card>

            {/* Features Overview */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Eye className="h-5 w-5" />
                  Dynamic Sidebar Features
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="p-4 bg-green-50 border border-green-200 rounded-lg">
                    <h4 className="font-semibold text-green-800 mb-2">✅ Role-Based Menu Access</h4>
                    <p className="text-green-700 text-sm">
                      Different employees see different menu items based on their department and role permissions.
                    </p>
                  </div>

                  <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                    <h4 className="font-semibold text-blue-800 mb-2">🔐 Permission-Based Actions</h4>
                    <p className="text-blue-700 text-sm">
                      Each menu item has granular permissions: View, Add, Edit, Delete based on role.
                    </p>
                  </div>

                  <div className="p-4 bg-purple-50 border border-purple-200 rounded-lg">
                    <h4 className="font-semibold text-purple-800 mb-2">📱 Mobile Responsive</h4>
                    <p className="text-purple-700 text-sm">
                      Sidebar automatically adapts to mobile with collapsible overlay navigation.
                    </p>
                  </div>

                  <div className="p-4 bg-orange-50 border border-orange-200 rounded-lg">
                    <h4 className="font-semibold text-orange-800 mb-2">⚡ Real-time Loading</h4>
                    <p className="text-orange-700 text-sm">
                      Menu items are loaded dynamically from the database with proper error handling.
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Admin Tools */}
            <div className="mt-8 flex gap-4">
              <Button 
                onClick={() => window.open('/admin/permissions', '_blank')}
                className="flex items-center gap-2"
              >
                <Settings className="h-4 w-4" />
                Open Admin Panel
              </Button>
              
              <Button 
                variant="outline"
                onClick={() => window.location.reload()}
              >
                Refresh Demo
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SidebarDemo; 