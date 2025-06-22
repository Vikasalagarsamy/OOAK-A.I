'use client';

import * as React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import * as Icons from 'lucide-react';
import type { LucideIcon } from 'lucide-react';
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";

interface MenuItem {
  id: number;
  name: string;
  path: string;
  icon: keyof typeof Icons;
  parent_id: number | null;
  string_id: string;
  section_name: string | null;
  is_admin_only: boolean;
  sort_order: number;
  is_visible: boolean;
  can_view: boolean;
  children?: MenuItem[];
}

export function Sidebar() {
  const pathname = usePathname();
  const [expandedItems, setExpandedItems] = React.useState<number[]>([]);
  const [menuItems, setMenuItems] = React.useState<MenuItem[]>([]);
  const [loading, setLoading] = React.useState(true);

  // Fetch menu items with permissions
  React.useEffect(() => {
    const fetchMenuItems = async () => {
      try {
        const response = await fetch('/api/auth/menu-permissions');
        const data = await response.json();
        if (data.success) {
          setMenuItems(data.items);
        }
      } catch (error) {
        console.error('Error fetching menu items:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchMenuItems();
  }, []);

  const toggleItem = (id: number) => {
    setExpandedItems(prev => 
      prev.includes(id)
        ? prev.filter(item => item !== id)
        : [...prev, id]
    );
  };

  const isActive = (path: string) => {
    return pathname === path;
  };

  const renderMenuItem = (item: MenuItem) => {
    // Skip items that are not visible or not permitted
    if (!item.is_visible || !item.can_view) {
      return null;
    }

    const IconComponent = (Icons[item.icon] as LucideIcon) || Icons.Circle;
    const hasChildren = item.children && item.children.length > 0;
    const isExpanded = expandedItems.includes(item.id);
    
    // For items with children
    if (hasChildren && item.children) {
      // Only show parent if at least one child is visible and permitted
      const hasVisibleChildren = item.children.some(child => child.is_visible && child.can_view);
      if (!hasVisibleChildren) {
        return null;
      }

      return (
        <Collapsible
          key={item.id}
          open={isExpanded}
          onOpenChange={() => toggleItem(item.id)}
          className="space-y-2"
        >
          <CollapsibleTrigger className="flex items-center justify-between w-full hover:bg-gray-100 rounded-lg px-3 py-2">
            <div className="flex items-center gap-3">
              <IconComponent className="h-5 w-5" />
              <span>{item.name}</span>
            </div>
            <Icons.ChevronRight className={cn(
              "h-4 w-4 transition-transform duration-200",
              isExpanded ? "transform rotate-90" : ""
            )} />
          </CollapsibleTrigger>
          <CollapsibleContent className="pl-4 space-y-1">
            {item.children.map(child => renderMenuItem(child))}
          </CollapsibleContent>
        </Collapsible>
      );
    }

    // For leaf items
    return (
      <Link
        key={item.id}
        href={item.path}
        className={cn(
          "flex items-center gap-3 hover:bg-gray-100 rounded-lg px-3 py-2",
          isActive(item.path) && "bg-gray-100 text-blue-600"
        )}
      >
        <IconComponent className="h-5 w-5" />
        <span>{item.name}</span>
      </Link>
    );
  };

  if (loading) {
    return (
      <nav className="w-64 bg-white border-r h-screen p-4 space-y-2">
        {[...Array(5)].map((_, i) => (
          <div key={i} className="animate-pulse">
            <div className="h-10 bg-gray-200 rounded-lg mb-2"></div>
          </div>
        ))}
      </nav>
    );
  }

  return (
    <nav className="w-64 bg-white border-r h-screen p-4 space-y-2">
      {menuItems.map(item => renderMenuItem(item))}
    </nav>
  );
} 