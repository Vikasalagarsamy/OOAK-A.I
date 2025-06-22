'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import * as Icons from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { useToast } from "@/components/ui/use-toast";
import { usePermissions } from '@/components/auth/RoleGuard';
import { Skeleton } from "@/components/ui/skeleton";

interface MenuItem {
  id: number;
  name: string;
  path: string;
  icon: string;
  parent_id: number | null;
  string_id: string;
  section_name: string | null;
  is_admin_only: boolean;
  sort_order: number;
  is_visible: boolean;
  can_view: boolean;
  children?: MenuItem[];
}

interface Designation {
  id: number;
  name: string;
  department_id: number;
  description: string | null;
}

export default function MenuPermissionsPage() {
  const [designations, setDesignations] = useState<Designation[]>([]);
  const [selectedDesignation, setSelectedDesignation] = useState<string>('');
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const { toast } = useToast();
  const { user } = usePermissions();
  const router = useRouter();

  // Fetch designations on mount
  useEffect(() => {
    const fetchDesignations = async () => {
      try {
        const response = await fetch('/api/designations');
        const data = await response.json();
        if (data.success) {
          setDesignations(data.designations);
        }
      } catch (error) {
        console.error('Error fetching designations:', error);
        toast({
          title: "Error",
          description: "Failed to load designations",
          variant: "destructive",
        });
      }
    };

    fetchDesignations();
  }, [toast]);

  // Fetch menu items when designation changes
  useEffect(() => {
    const fetchMenuItems = async () => {
      if (!selectedDesignation) {
        setMenuItems([]);
        setLoading(false);
        return;
      }
      
      setLoading(true);
      try {
        const response = await fetch(`/api/admin/menu-permissions?designationId=${parseInt(selectedDesignation, 10)}`);
        const data = await response.json();
        if (data.success) {
          setMenuItems(data.items);
        }
      } catch (error) {
        console.error('Error fetching menu items:', error);
        toast({
          title: "Error",
          description: "Failed to load menu items",
          variant: "destructive",
        });
      } finally {
        setLoading(false);
      }
    };

    fetchMenuItems();
  }, [selectedDesignation, toast]);

  const handlePermissionChange = async (menuItemId: number, checked: boolean): Promise<void> => {
    // Find the item and all its children
    const updateItemAndChildren = (items: MenuItem[]): MenuItem[] => {
      return items.map(item => {
        if (item.id === menuItemId) {
          return {
            ...item,
            can_view: checked,
            children: item.children?.map(child => ({
              ...child,
              can_view: checked
            }))
          };
        } else if (item.children) {
          return {
            ...item,
            children: updateItemAndChildren(item.children)
          };
        }
        return item;
      });
    };

    setMenuItems(prev => updateItemAndChildren(prev));
  };

  const handleSave = async () => {
    if (!selectedDesignation || !user?.employee_id) {
      toast({
        title: "Error",
        description: "Missing required data: " + 
          (!selectedDesignation ? "No designation selected. " : "") +
          (!user?.employee_id ? "Employee ID not found. " : ""),
        variant: "destructive",
      });
      return;
    }

    setSaving(true);
    try {
      // Flatten the menu items to include all items (parents and children)
      const getAllItems = (items: MenuItem[]): { menuItemId: number; canView: boolean }[] => {
        return items.reduce((acc, item) => {
          acc.push({ menuItemId: item.id, canView: item.can_view });
          if (item.children) {
            acc.push(...getAllItems(item.children));
          }
          return acc;
        }, [] as { menuItemId: number; canView: boolean }[]);
      };

      const permissions = getAllItems(menuItems);

      if (permissions.length === 0) {
        toast({
          title: "Error",
          description: "No permissions to save",
          variant: "destructive",
        });
        setSaving(false);
        return;
      }

      console.log('Saving permissions:', {
        designationId: parseInt(selectedDesignation, 10),
        employeeId: user.employee_id,
        permissionsCount: permissions.length
      });

      const response = await fetch('/api/admin/menu-permissions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          designationId: parseInt(selectedDesignation, 10),
          permissions,
          employeeId: user.employee_id
        })
      });

      const data = await response.json();
      if (data.success) {
        toast({
          title: "Success",
          description: "Menu permissions updated successfully",
        });
      } else {
        throw new Error(data.error || 'Failed to save menu permissions');
      }
    } catch (error) {
      console.error('Error saving permissions:', error);
      toast({
        title: "Error",
        description: error instanceof Error ? error.message : "Failed to save menu permissions",
        variant: "destructive",
      });
    } finally {
      setSaving(false);
    }
  };

  const renderMenuItem = (item: MenuItem, level: number = 0) => {
    const IconComponent = (Icons[item.icon as keyof typeof Icons] as React.ElementType) || Icons.Circle;
    const paddingLeft = `${level * 1.5 + 1}rem`;

    return (
      <div key={item.id}>
        <div
          className="flex items-center justify-between py-2 px-4 hover:bg-accent/5 rounded-lg transition-colors"
          style={{ paddingLeft }}
        >
          <div className="flex items-center gap-3 flex-1">
            <IconComponent className="h-4 w-4 text-muted-foreground" />
            <span className="font-medium">{item.name}</span>
            {item.is_admin_only && (
              <Badge variant="secondary" className="text-xs">Admin Only</Badge>
            )}
            {item.section_name && (
              <Badge variant="outline" className="text-xs">{item.section_name}</Badge>
            )}
          </div>
          <Switch
            checked={item.can_view}
            onCheckedChange={(checked) => handlePermissionChange(item.id, checked)}
            aria-label={`Toggle permission for ${item.name}`}
          />
        </div>
        {item.children && item.children.length > 0 && (
          <div className="ml-4">
            {item.children.map(child => renderMenuItem(child, level + 1))}
          </div>
        )}
      </div>
    );
  };

  const renderLoadingState = () => (
    <div className="space-y-4">
      {Array.from({ length: 8 }).map((_, i) => (
        <div key={i} className="flex items-center justify-between py-2 px-4">
          <div className="flex items-center gap-3 flex-1">
            <Skeleton className="h-4 w-4" />
            <Skeleton className="h-4 w-40" />
          </div>
          <Skeleton className="h-6 w-10" />
        </div>
      ))}
    </div>
  );

  // Early return for unauthenticated users
  if (!user?.employee_id) {
    return null;
  }

  return (
    <div className="container mx-auto py-6 max-w-5xl">
      <Card className="p-6">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-semibold">Menu Permissions</h1>
            <p className="text-muted-foreground">
              Manage menu access for each designation
            </p>
          </div>
          <Button
            onClick={handleSave}
            disabled={!selectedDesignation || saving || loading}
          >
            {saving ? 'Saving...' : 'Save Changes'}
          </Button>
        </div>

        <div className="mb-6">
          <Select
            value={selectedDesignation}
            onValueChange={setSelectedDesignation}
          >
            <SelectTrigger className="w-[300px]">
              <SelectValue placeholder="Select a designation..." />
            </SelectTrigger>
            <SelectContent className="max-h-[300px] overflow-y-auto">
              {designations.map((designation) => (
                <SelectItem
                  key={designation.id}
                  value={designation.id.toString()}
                >
                  {designation.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {loading ? (
          renderLoadingState()
        ) : selectedDesignation ? (
          <div className="space-y-1">
            {menuItems.map(item => renderMenuItem(item))}
          </div>
        ) : (
          <div className="text-center py-12 text-muted-foreground">
            Select a designation to manage its menu permissions
          </div>
        )}
      </Card>
    </div>
  );
} 