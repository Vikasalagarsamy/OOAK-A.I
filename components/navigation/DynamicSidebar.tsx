'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { 
  ChevronDown, 
  ChevronRight, 
  Home, 
  Users, 
  DollarSign, 
  BarChart,
  Settings,
  Menu,
  X
} from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { MenuItem, EmployeeMenuAccess } from '@/types/menu';

interface DynamicSidebarProps {
  employeeId: number;
  className?: string;
}

const iconMap: { [key: string]: React.ReactNode } = {
  'Home': <Home className="h-4 w-4" />,
  'Users': <Users className="h-4 w-4" />,
  'DollarSign': <DollarSign className="h-4 w-4" />,
  'BarChart': <BarChart className="h-4 w-4" />,
  'Settings': <Settings className="h-4 w-4" />,
  'LayoutGrid': <Menu className="h-4 w-4" />,
  'Cpu': <Settings className="h-4 w-4" />,
  'UserPlus': <Users className="h-4 w-4" />,
  'UserMinus': <Users className="h-4 w-4" />,
  'PhoneCall': <BarChart className="h-4 w-4" />,
  'FileText': <BarChart className="h-4 w-4" />,
};

const DynamicSidebar: React.FC<DynamicSidebarProps> = ({ employeeId, className = '' }) => {
  const [menuAccess, setMenuAccess] = useState<EmployeeMenuAccess | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [expandedItems, setExpandedItems] = useState<Set<number>>(new Set());
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  
  const pathname = usePathname();

  useEffect(() => {
    fetchMenuAccess();
  }, [employeeId]);

  const fetchMenuAccess = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch(`/api/menus/employee/${employeeId}`);
      const data = await response.json();
      
      if (response.ok) {
        setMenuAccess(data);
        
        // Auto-expand parent items that contain active child
        const activeParents = findActiveParents(data.menu_items, pathname);
        setExpandedItems(new Set(activeParents));
      } else {
        setError(data.error || 'Failed to load menu');
      }
    } catch (err) {
      console.error('Error fetching menu access:', err);
      setError('Error loading menu');
    } finally {
      setLoading(false);
    }
  };

  const findActiveParents = (items: MenuItem[], currentPath: string): number[] => {
    const parents: number[] = [];
    
    const findParent = (menuItems: MenuItem[]): boolean => {
      for (const item of menuItems) {
        if (item.path === currentPath) {
          return true;
        }
        
        if (item.children && item.children.length > 0) {
          if (findParent(item.children)) {
            parents.push(item.id);
            return true;
          }
        }
      }
      return false;
    };
    
    findParent(items);
    return parents;
  };

  const toggleExpanded = (itemId: number) => {
    setExpandedItems(prev => {
      const newSet = new Set(prev);
      if (newSet.has(itemId)) {
        newSet.delete(itemId);
      } else {
        newSet.add(itemId);
      }
      return newSet;
    });
  };

  const isActive = (path: string) => {
    return pathname === path || pathname.startsWith(path + '/');
  };

  const renderMenuItem = (item: MenuItem & { can_view: boolean; can_add: boolean; can_edit: boolean; can_delete: boolean }, level = 0) => {
    const hasChildren = item.children && item.children.length > 0;
    const isExpanded = expandedItems.has(item.id);
    const isItemActive = isActive(item.path);
    const icon = iconMap[item.icon] || <Menu className="h-4 w-4" />;

    return (
      <div key={item.id}>
        {/* Menu Item */}
        <div
          className={`
            flex items-center gap-3 px-4 py-3 mx-2 rounded-lg transition-all duration-200 cursor-pointer
            ${level > 0 ? 'ml-4 border-l-2 border-gray-200' : ''}
            ${isItemActive 
              ? 'bg-blue-100 text-blue-700 border-blue-200 shadow-sm' 
              : 'text-gray-700 hover:bg-gray-100'
            }
          `}
          onClick={() => hasChildren ? toggleExpanded(item.id) : null}
        >
          {/* Icon */}
          <div className={`flex-shrink-0 ${isItemActive ? 'text-blue-600' : 'text-gray-500'}`}>
            {icon}
          </div>

          {/* Menu Content */}
          <div className="flex-1 min-w-0">
            {hasChildren ? (
              <div className="flex items-center justify-between">
                <span className="font-medium truncate">{item.name}</span>
                {isExpanded ? 
                  <ChevronDown className="h-4 w-4 flex-shrink-0" /> : 
                  <ChevronRight className="h-4 w-4 flex-shrink-0" />
                }
              </div>
            ) : (
              <Link 
                href={item.path}
                className="block w-full"
                onClick={() => setIsMobileOpen(false)}
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium truncate">{item.name}</span>
                  {item.badge_text && (
                    <Badge variant={item.badge_variant as any} className="ml-2 flex-shrink-0">
                      {item.badge_text}
                    </Badge>
                  )}
                </div>
                {item.description && (
                  <p className="text-xs text-gray-500 mt-1 truncate">{item.description}</p>
                )}
              </Link>
            )}
          </div>
        </div>

        {/* Children */}
        {hasChildren && isExpanded && (
          <div className="mt-1">
            {item.children?.map(child => renderMenuItem(child as any, level + 1))}
          </div>
        )}
      </div>
    );
  };

  if (loading) {
    return (
      <div className={`bg-white border-r border-gray-200 ${className}`}>
        <div className="p-4">
          <div className="animate-pulse space-y-3">
            {[...Array(6)].map((_, i) => (
              <div key={i} className="h-10 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className={`bg-white border-r border-gray-200 ${className}`}>
        <div className="p-4">
          <div className="text-center text-red-600">
            <Menu className="h-8 w-8 mx-auto mb-2" />
            <p className="text-sm">{error}</p>
            <Button 
              onClick={fetchMenuAccess} 
              variant="outline" 
              size="sm" 
              className="mt-2"
            >
              Retry
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* Mobile Menu Button */}
      <Button
        variant="outline"
        size="sm"
        className="lg:hidden fixed top-4 left-4 z-50"
        onClick={() => setIsMobileOpen(!isMobileOpen)}
      >
        {isMobileOpen ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
      </Button>

      {/* Sidebar */}
      <div className={`
        bg-white border-r border-gray-200 transition-transform duration-300 ease-in-out
        ${className}
        ${isMobileOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
        lg:relative fixed inset-y-0 left-0 z-40
      `}>
        {/* Header */}
        <div className="p-4 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Users className="h-5 w-5 text-blue-600" />
            </div>
            <div className="min-w-0 flex-1">
              <h3 className="font-semibold text-gray-900 truncate">
                {menuAccess?.department_name}
              </h3>
              <p className="text-xs text-gray-600 truncate">
                {menuAccess?.role_name}
              </p>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="flex-1 overflow-y-auto py-4">
          {menuAccess?.menu_items.length === 0 ? (
            <div className="text-center p-4 text-gray-500">
              <Menu className="h-8 w-8 mx-auto mb-2" />
              <p className="text-sm">No menu access</p>
            </div>
          ) : (
            <div className="space-y-1">
              {menuAccess?.menu_items.map(item => renderMenuItem(item as any))}
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-4 border-t border-gray-200">
          <div className="text-xs text-gray-500 text-center">
            {menuAccess?.menu_items.length} menu items available
          </div>
        </div>
      </div>

      {/* Mobile Overlay */}
      {isMobileOpen && (
        <div 
          className="lg:hidden fixed inset-0 bg-black bg-opacity-50 z-30"
          onClick={() => setIsMobileOpen(false)}
        />
      )}
    </>
  );
};

export default DynamicSidebar; 