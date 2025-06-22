'use client';

import * as React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import * as Icons from 'lucide-react';
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
  description?: string;
  children?: MenuItem[];
}

const navigation: MenuItem[] = [
  {
    id: 1,
    name: "Core Business",
    path: "/core-business",
    icon: "LayoutGrid",
    children: [
      {
        id: 2,
        name: "Dashboard",
        path: "/dashboard",
        icon: "LayoutDashboard",
        description: "Business overview and metrics"
      },
      {
        id: 3,
        name: "AI Business Control",
        path: "/ai-business-control",
        icon: "Cpu",
        description: "AI-powered business management"
      },
      {
        id: 4,
        name: "Business Activities",
        path: "/business-activities",
        icon: "Activity",
        description: "Recent business activities"
      }
    ]
  },
  {
    id: 5,
    name: "Sales & Revenue",
    path: "/sales",
    icon: "TrendingUp",
    children: [
      {
        id: 6,
        name: "Sales Dashboard",
        path: "/sales/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 7,
        name: "Active Leads",
        path: "/sales/active-leads",
        icon: "Users"
      },
      {
        id: 8,
        name: "Create Lead",
        path: "/sales/create-lead",
        icon: "UserPlus"
      },
      {
        id: 9,
        name: "My Leads",
        path: "/sales/my-leads",
        icon: "List"
      },
      {
        id: 10,
        name: "Unassigned Leads",
        path: "/sales/unassigned-leads",
        icon: "UserMinus"
      },
      {
        id: 11,
        name: "Follow Up",
        path: "/sales/follow-up",
        icon: "Bell"
      },
      {
        id: 12,
        name: "Quotations",
        path: "/sales/quotations",
        icon: "FileText"
      },
      {
        id: 13,
        name: "Approval Queue",
        path: "/sales/approval-queue",
        icon: "Clock"
      },
      {
        id: 14,
        name: "Rejected Quotes",
        path: "/sales/rejected-quotes",
        icon: "XCircle"
      },
      {
        id: 15,
        name: "Order Confirmation",
        path: "/sales/order-confirmation",
        icon: "CheckCircle"
      },
      {
        id: 16,
        name: "Rejected Leads",
        path: "/sales/rejected-leads",
        icon: "XOctagon"
      },
      {
        id: 17,
        name: "Lead Sources",
        path: "/sales/lead-sources",
        icon: "Globe"
      },
      {
        id: 18,
        name: "WhatsApp Messages",
        path: "/sales/whatsapp",
        icon: "MessageCircle"
      },
      {
        id: 19,
        name: "Call Transcriptions",
        path: "/sales/calls",
        icon: "Phone"
      },
      {
        id: 20,
        name: "AI Business Insights",
        path: "/sales/ai-insights",
        icon: "Brain"
      },
      {
        id: 21,
        name: "AI Call Analytics",
        path: "/sales/call-analytics",
        icon: "BarChart2"
      }
    ]
  },
  {
    id: 22,
    name: "Organization",
    path: "/organization",
    icon: "Building2",
    children: [
      {
        id: 23,
        name: "Companies",
        path: "/organization/companies",
        icon: "Building"
      },
      {
        id: 24,
        name: "Active Branches",
        path: "/organization/branches",
        icon: "GitBranch"
      },
      {
        id: 25,
        name: "Branch Distribution",
        path: "/organization/distribution",
        icon: "Network"
      },
      {
        id: 26,
        name: "Team Members",
        path: "/organization/team",
        icon: "Users"
      },
      {
        id: 27,
        name: "Clients",
        path: "/organization/clients",
        icon: "User"
      },
      {
        id: 28,
        name: "Suppliers",
        path: "/organization/suppliers",
        icon: "Truck"
      },
      {
        id: 29,
        name: "Vendors",
        path: "/organization/vendors",
        icon: "Store"
      },
      {
        id: 30,
        name: "Roles & Permissions",
        path: "/organization/roles",
        icon: "Shield"
      },
      {
        id: 31,
        name: "User Accounts",
        path: "/organization/users",
        icon: "UserCog"
      }
    ]
  },
  {
    id: 32,
    name: "People & HR",
    path: "/people",
    icon: "Users",
    children: [
      {
        id: 33,
        name: "People Dashboard",
        path: "/people/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 34,
        name: "Employees",
        path: "/people/employees",
        icon: "User"
      },
      {
        id: 35,
        name: "Departments",
        path: "/people/departments",
        icon: "Network"
      },
      {
        id: 36,
        name: "Designations",
        path: "/people/designations",
        icon: "Award"
      }
    ]
  },
  {
    id: 37,
    name: "Task Management",
    path: "/tasks",
    icon: "CheckSquare",
    children: [
      {
        id: 38,
        name: "My Tasks",
        path: "/tasks/my-tasks",
        icon: "ListTodo"
      },
      {
        id: 39,
        name: "Task Control Center",
        path: "/tasks/control-center",
        icon: "Command"
      },
      {
        id: 40,
        name: "AI Task Generator",
        path: "/tasks/ai-generator",
        icon: "Cpu"
      },
      {
        id: 41,
        name: "Task Analytics",
        path: "/tasks/analytics",
        icon: "BarChart"
      },
      {
        id: 42,
        name: "Task Calendar",
        path: "/tasks/calendar",
        icon: "Calendar"
      },
      {
        id: 43,
        name: "Migration Panel",
        path: "/tasks/migration",
        icon: "MoveRight"
      },
      {
        id: 44,
        name: "Task Reports",
        path: "/tasks/reports",
        icon: "FileText"
      },
      {
        id: 45,
        name: "Task Sequence Management",
        path: "/tasks/sequence",
        icon: "ListOrdered"
      },
      {
        id: 46,
        name: "Integration Status",
        path: "/tasks/integration",
        icon: "Link"
      }
    ]
  },
  {
    id: 47,
    name: "Accounting & Finance",
    path: "/accounting",
    icon: "Calculator",
    children: [
      {
        id: 48,
        name: "Financial Dashboard",
        path: "/accounting/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 49,
        name: "Invoices",
        path: "/accounting/invoices",
        icon: "FileText"
      },
      {
        id: 50,
        name: "Payments",
        path: "/accounting/payments",
        icon: "CreditCard"
      },
      {
        id: 51,
        name: "Expenses",
        path: "/accounting/expenses",
        icon: "Receipt"
      }
    ]
  },
  {
    id: 52,
    name: "Event Coordination",
    path: "/events",
    icon: "Calendar",
    children: [
      {
        id: 53,
        name: "Events Dashboard",
        path: "/events/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 54,
        name: "Event Calendar",
        path: "/events/calendar",
        icon: "Calendar"
      },
      {
        id: 55,
        name: "Events",
        path: "/events/list",
        icon: "CalendarDays"
      },
      {
        id: 56,
        name: "Event Types",
        path: "/events/types",
        icon: "Tags"
      },
      {
        id: 57,
        name: "Services",
        path: "/events/services",
        icon: "Package"
      },
      {
        id: 58,
        name: "Venues",
        path: "/events/venues",
        icon: "MapPin"
      },
      {
        id: 59,
        name: "Staff Assignment",
        path: "/events/staff",
        icon: "Users"
      }
    ]
  },
  {
    id: 60,
    name: "Post Production",
    path: "/production",
    icon: "Settings",
    children: [
      {
        id: 61,
        name: "Production Dashboard",
        path: "/production/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 62,
        name: "Deliverables",
        path: "/production/deliverables",
        icon: "Package"
      },
      {
        id: 63,
        name: "Deliverables Workflow",
        path: "/production/workflow",
        icon: "GitBranch"
      },
      {
        id: 64,
        name: "Projects",
        path: "/production/projects",
        icon: "Folder"
      },
      {
        id: 65,
        name: "Workflow",
        path: "/production/workflow-management",
        icon: "GitBranch"
      },
      {
        id: 66,
        name: "Quality Control",
        path: "/production/quality",
        icon: "CheckCircle"
      },
      {
        id: 67,
        name: "Client Review",
        path: "/production/review",
        icon: "MessageSquare"
      },
      {
        id: 68,
        name: "Final Delivery",
        path: "/production/delivery",
        icon: "Send"
      }
    ]
  },
  {
    id: 69,
    name: "Post-Sales",
    path: "/post-sales",
    icon: "HeartHandshake",
    children: [
      {
        id: 70,
        name: "Post-Sales Dashboard",
        path: "/post-sales/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 71,
        name: "Delivery Management",
        path: "/post-sales/delivery",
        icon: "Package"
      },
      {
        id: 72,
        name: "Customer Support",
        path: "/post-sales/support",
        icon: "Headphones"
      },
      {
        id: 73,
        name: "Customer Feedback",
        path: "/post-sales/feedback",
        icon: "MessageCircle"
      }
    ]
  },
  {
    id: 74,
    name: "Reports & Analytics",
    path: "/reports",
    icon: "LineChart",
    children: [
      {
        id: 75,
        name: "Lead Source Analysis",
        path: "/reports/lead-sources",
        icon: "PieChart"
      },
      {
        id: 76,
        name: "Conversion Funnel",
        path: "/reports/funnel",
        icon: "Filter"
      },
      {
        id: 77,
        name: "Team Performance",
        path: "/reports/performance",
        icon: "TrendingUp"
      },
      {
        id: 78,
        name: "Business Trends",
        path: "/reports/trends",
        icon: "LineChart"
      },
      {
        id: 79,
        name: "Custom Reports",
        path: "/reports/custom",
        icon: "FileText"
      }
    ]
  },
  {
    id: 80,
    name: "System Administration",
    path: "/admin",
    icon: "Shield",
    children: [
      {
        id: 81,
        name: "Admin Dashboard",
        path: "/admin/dashboard",
        icon: "LayoutDashboard"
      },
      {
        id: 82,
        name: "Database Monitor",
        path: "/admin/database",
        icon: "Database"
      },
      {
        id: 83,
        name: "Menu & Role Permissions",
        path: "/admin/permissions",
        icon: "Lock"
      },
      {
        id: 84,
        name: "System Settings",
        path: "/admin/settings",
        icon: "Settings"
      },
      {
        id: 85,
        name: "Menu Repair",
        path: "/admin/menu-repair",
        icon: "Wrench"
      },
      {
        id: 86,
        name: "Menu Debug",
        path: "/admin/menu-debug",
        icon: "Bug"
      },
      {
        id: 87,
        name: "Test Permissions",
        path: "/admin/test-permissions",
        icon: "CheckCircle"
      },
      {
        id: 88,
        name: "Test Feature",
        path: "/admin/test-feature",
        icon: "Zap"
      }
    ]
  }
];

export function Sidebar() {
  const pathname = usePathname();
  const [openItems, setOpenItems] = React.useState<number[]>([]);
  const [isCompact, setIsCompact] = React.useState(false);

  const toggleItem = (id: number) => {
    setOpenItems(prev => 
      prev.includes(id) 
        ? prev.filter(item => item !== id)
        : [...prev, id]
    );
  };

  const isActive = (path: string) => {
    return pathname === path;
  };

  const renderMenuItem = (item: MenuItem) => {
    const IconComponent = Icons[item.icon] as React.ComponentType<{ className?: string }>;
    const isOpen = openItems.includes(item.id);
    const active = isActive(item.path);

    if (item.children) {
      return (
        <Collapsible
          key={item.id}
          open={isOpen}
          onOpenChange={() => toggleItem(item.id)}
          className="w-full"
        >
          <CollapsibleTrigger className={cn(
            "flex items-center w-full gap-2 px-3 py-2 text-sm font-medium rounded-lg hover:bg-accent hover:text-accent-foreground transition-all duration-200",
            active && "bg-accent text-accent-foreground shadow-sm",
            isOpen && "bg-accent/50"
          )}>
            <IconComponent className="h-4 w-4" />
            <span className={cn(
              "flex-1 text-left transition-opacity",
              isCompact && "opacity-0 w-0"
            )}>{item.name}</span>
            <Icons.ChevronRight className={cn(
              "h-4 w-4 transition-transform duration-200",
              isOpen && "transform rotate-90",
              isCompact && "opacity-0 w-0"
            )} />
          </CollapsibleTrigger>
          <CollapsibleContent className={cn(
            "pl-4 mt-1 space-y-1",
            isCompact && "hidden"
          )}>
            {item.children.map((child) => (
              <Link
                key={child.id}
                href={child.path}
                className={cn(
                  "flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-lg hover:bg-accent hover:text-accent-foreground transition-all duration-200",
                  isActive(child.path) && "bg-accent text-accent-foreground shadow-sm"
                )}
              >
                <IconComponent className="h-4 w-4" />
                <span>{child.name}</span>
              </Link>
            ))}
          </CollapsibleContent>
        </Collapsible>
      );
    }

    return (
      <Link
        key={item.id}
        href={item.path}
        className={cn(
          "flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-lg hover:bg-accent hover:text-accent-foreground transition-all duration-200",
          active && "bg-accent text-accent-foreground shadow-sm"
        )}
      >
        <IconComponent className="h-4 w-4" />
        <span className={cn(
          "transition-opacity",
          isCompact && "opacity-0 w-0"
        )}>{item.name}</span>
      </Link>
    );
  };

  return (
    <div className="h-full flex flex-col">
      <div className="flex-none p-4 border-b flex items-center justify-between">
        <div className={cn(
          "flex items-center gap-2",
          isCompact && "opacity-0"
        )}>
          <Icons.Building className="h-6 w-6 text-primary" />
          <div>
            <h1 className="text-base font-semibold">OOAK AI</h1>
            <p className="text-xs text-muted-foreground">Business CRM</p>
          </div>
        </div>
        <button
          onClick={() => setIsCompact(!isCompact)}
          className="p-2 rounded-md hover:bg-accent hover:text-accent-foreground transition-colors"
          aria-label={isCompact ? "Expand sidebar" : "Collapse sidebar"}
        >
          {isCompact ? (
            <Icons.PanelRightOpen className="h-4 w-4" />
          ) : (
            <Icons.PanelLeftClose className="h-4 w-4" />
          )}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto">
        <nav className="p-2 space-y-1">
          {navigation.map(renderMenuItem)}
        </nav>
      </div>
    </div>
  );
} 