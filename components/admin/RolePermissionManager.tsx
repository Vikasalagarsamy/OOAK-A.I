'use client';

import React, { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  Users, 
  Menu, 
  Eye, 
  Plus, 
  Edit, 
  Trash2, 
  Save, 
  Shield,
  CheckCircle,
  XCircle,
  Settings
} from 'lucide-react';

interface RolePermission {
  id: number;
  role_id: number;
  menu_string_id: string;
  can_view: boolean;
  can_add: boolean;
  can_edit: boolean;
  can_delete: boolean;
  menu_name: string;
  menu_description: string;
  icon: string;
  path: string;
  full_menu_path: string;
}

interface Department {
  name: string;
  role_id: number;
  role_name: string;
  employee_count: number;
}

const RolePermissionManager: React.FC = () => {
  const [permissions, setPermissions] = useState<RolePermission[]>([]);
  const [departments] = useState<Department[]>([
    { name: 'SALES', role_id: 2, role_name: 'Sales Executive', employee_count: 7 },
    { name: 'ACCOUNTS', role_id: 3, role_name: 'Accountant', employee_count: 2 },
    { name: 'MANAGEMENT', role_id: 1, role_name: 'Manager', employee_count: 2 },
    { name: 'POST PRODUCTION', role_id: 4, role_name: 'Post Production Artist', employee_count: 12 },
    { name: 'PHOTOGRAPHY', role_id: 5, role_name: 'Photographer', employee_count: 7 },
    { name: 'QUALITY CHECK', role_id: 6, role_name: 'Quality Analyst', employee_count: 3 },
  ]);
  
  const [selectedRole, setSelectedRole] = useState<number>(2); // Default to Sales
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  useEffect(() => {
    fetchPermissions();
  }, [selectedRole]);

  const fetchPermissions = async () => {
    setLoading(true);
    try {
      const response = await fetch(`/api/admin/role-permissions?roleId=${selectedRole}`);
      const data = await response.json();
      
      if (data.success) {
        setPermissions(data.data);
      } else {
        setMessage({ type: 'error', text: 'Failed to fetch permissions' });
      }
    } catch (error) {
      console.error('Error fetching permissions:', error);
      setMessage({ type: 'error', text: 'Error fetching permissions' });
    } finally {
      setLoading(false);
    }
  };

  const updatePermission = async (permissionId: number, field: string, value: boolean) => {
    setSaving(true);
    try {
      const permission = permissions.find(p => p.id === permissionId);
      if (!permission) return;

      const updatedPermission = { ...permission, [field]: value };

      const response = await fetch('/api/admin/role-permissions', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedPermission)
      });

      const data = await response.json();

      if (data.success) {
        setPermissions(prev => 
          prev.map(p => p.id === permissionId ? { ...p, [field]: value } : p)
        );
        setMessage({ type: 'success', text: 'Permission updated successfully' });
      } else {
        setMessage({ type: 'error', text: data.error || 'Failed to update permission' });
      }
    } catch (error) {
      console.error('Error updating permission:', error);
      setMessage({ type: 'error', text: 'Error updating permission' });
    } finally {
      setSaving(false);
    }
  };

  const PermissionToggle: React.FC<{
    enabled: boolean;
    onChange: (value: boolean) => void;
    icon: React.ReactNode;
    label: string;
    disabled?: boolean;
  }> = ({ enabled, onChange, icon, label, disabled }) => (
    <button
      onClick={() => !disabled && onChange(!enabled)}
      disabled={disabled}
      className={`
        flex items-center gap-2 px-3 py-2 rounded-lg border transition-all duration-200
        ${enabled 
          ? 'bg-green-50 border-green-200 text-green-700 hover:bg-green-100' 
          : 'bg-gray-50 border-gray-200 text-gray-500 hover:bg-gray-100'
        }
        ${disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
      `}
      title={label}
    >
      {enabled ? <CheckCircle className="h-4 w-4" /> : <XCircle className="h-4 w-4" />}
      {icon}
      <span className="text-xs font-medium">{label}</span>
    </button>
  );

  const selectedDepartment = departments.find(d => d.role_id === selectedRole);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2 flex items-center gap-3">
            <Shield className="h-10 w-10 text-blue-600" />
            Role & Menu Permission Manager
          </h1>
          <p className="text-lg text-gray-600">
            Configure menu access permissions for different employee roles
          </p>
          <Badge variant="secondary" className="mt-2">
            🔐 Admin Only - Role-Based Access Control
          </Badge>
        </div>

        {/* Message */}
        {message && (
          <div className={`
            mb-6 p-4 rounded-lg border-l-4 
            ${message.type === 'success' 
              ? 'bg-green-50 border-green-400 text-green-700' 
              : 'bg-red-50 border-red-400 text-red-700'
            }
          `}>
            {message.text}
          </div>
        )}

        {/* Department/Role Selection */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Users className="h-5 w-5" />
              Select Department/Role
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {departments.map((dept) => (
                <button
                  key={dept.role_id}
                  onClick={() => setSelectedRole(dept.role_id)}
                  className={`
                    p-4 rounded-lg border-2 text-left transition-all duration-200
                    ${selectedRole === dept.role_id 
                      ? 'border-blue-500 bg-blue-50 shadow-md' 
                      : 'border-gray-200 bg-white hover:border-gray-300'
                    }
                  `}
                >
                  <div className="font-semibold text-gray-900">{dept.name}</div>
                  <div className="text-sm text-gray-600">{dept.role_name}</div>
                  <Badge variant="outline" className="mt-2">
                    {dept.employee_count} employees
                  </Badge>
                </button>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Current Role Info */}
        {selectedDepartment && (
          <Card className="mb-8 border-l-4 border-l-blue-500">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-900">
                    {selectedDepartment.name} Department
                  </h3>
                  <p className="text-gray-600">
                    Role: {selectedDepartment.role_name} | {selectedDepartment.employee_count} employees
                  </p>
                </div>
                <Badge variant="secondary">Role ID: {selectedRole}</Badge>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Permissions Table */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Menu className="h-5 w-5" />
              Menu Permissions
              {loading && <span className="text-sm text-gray-500">Loading...</span>}
            </CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-2 text-gray-600">Loading permissions...</p>
              </div>
            ) : permissions.length === 0 ? (
              <div className="text-center py-8">
                <Menu className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">No permissions found for this role</p>
              </div>
            ) : (
              <div className="space-y-4">
                {permissions.map((permission) => (
                  <div
                    key={permission.id}
                    className="p-4 border rounded-lg bg-white shadow-sm hover:shadow-md transition-shadow"
                  >
                    <div className="flex items-center justify-between mb-4">
                      <div className="flex items-center gap-3">
                        <div className="p-2 bg-blue-100 rounded-lg">
                          <Menu className="h-4 w-4 text-blue-600" />
                        </div>
                        <div>
                          <h4 className="font-semibold text-gray-900">
                            {permission.full_menu_path}
                          </h4>
                          <p className="text-sm text-gray-600">
                            {permission.menu_description}
                          </p>
                          <Badge variant="outline" className="mt-1">
                            {permission.path}
                          </Badge>
                        </div>
                      </div>
                    </div>

                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                      <PermissionToggle
                        enabled={permission.can_view}
                        onChange={(value) => updatePermission(permission.id, 'can_view', value)}
                        icon={<Eye className="h-4 w-4" />}
                        label="View"
                        disabled={saving}
                      />
                      <PermissionToggle
                        enabled={permission.can_add}
                        onChange={(value) => updatePermission(permission.id, 'can_add', value)}
                        icon={<Plus className="h-4 w-4" />}
                        label="Add"
                        disabled={saving}
                      />
                      <PermissionToggle
                        enabled={permission.can_edit}
                        onChange={(value) => updatePermission(permission.id, 'can_edit', value)}
                        icon={<Edit className="h-4 w-4" />}
                        label="Edit"
                        disabled={saving}
                      />
                      <PermissionToggle
                        enabled={permission.can_delete}
                        onChange={(value) => updatePermission(permission.id, 'can_delete', value)}
                        icon={<Trash2 className="h-4 w-4" />}
                        label="Delete"
                        disabled={saving}
                      />
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Action Buttons */}
        <div className="mt-8 flex justify-between">
          <Button
            onClick={fetchPermissions}
            variant="outline"
            disabled={loading}
          >
            <Settings className="h-4 w-4 mr-2" />
            Refresh Permissions
          </Button>
          
          <div className="text-sm text-gray-600">
            {permissions.length} menu items configured for this role
          </div>
        </div>
      </div>
    </div>
  );
};

export default RolePermissionManager; 