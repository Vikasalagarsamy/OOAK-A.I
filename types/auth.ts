import type { JWTPayload as JoseJWTPayload } from 'jose';
import 'next-auth';
import { DefaultSession } from 'next-auth';

export interface Employee {
  id: number;
  employee_id: string;
  first_name: string;
  last_name: string;
  email?: string;
  phone?: string;
  department_id?: number;
  designation_id?: number;
  job_title?: string;
  status?: string;
  hire_date?: Date;
}

export interface Designation {
  id: number;
  name: string;
  department_id?: number;
  description?: string;
}

export interface AuthUser {
  id: number;
  employee_id: string;
  first_name: string;
  last_name: string;
  email?: string;
  designation: {
    id: number;
    name: string;
  };
  department_id?: number;
  permissions: Permission[];
}

export interface LoginCredentials {
  employee_id: string;
  password: string;
}

export interface AuthResponse {
  success: boolean;
  user?: AuthUser;
  message?: string;
}

export interface JWTPayload extends JoseJWTPayload {
  userId: number;
  employee_id: string;
  designation_id: number;
  iat?: number;
  exp?: number;
}

export enum Permission {
  // Admin permissions
  ADMIN_FULL_ACCESS = 'admin:full_access',
  
  // Sales permissions
  SALES_VIEW_LEADS = 'sales:view_leads',
  SALES_MANAGE_LEADS = 'sales:manage_leads',
  SALES_VIEW_QUOTATIONS = 'sales:view_quotations',
  SALES_MANAGE_QUOTATIONS = 'sales:manage_quotations',
  SALES_VIEW_REPORTS = 'sales:view_reports',
  SALES_MANAGE_TEAM = 'sales:manage_team',
  
  // Accounting permissions
  ACCOUNTING_VIEW_INVOICES = 'accounting:view_invoices',
  ACCOUNTING_MANAGE_INVOICES = 'accounting:manage_invoices',
  ACCOUNTING_VIEW_PAYMENTS = 'accounting:view_payments',
  ACCOUNTING_MANAGE_PAYMENTS = 'accounting:manage_payments',
  ACCOUNTING_VIEW_REPORTS = 'accounting:view_reports',
  
  // General permissions
  VIEW_DASHBOARD = 'general:view_dashboard',
  VIEW_PROFILE = 'general:view_profile',
  EDIT_PROFILE = 'general:edit_profile',
}

export interface RolePermissions {
  [key: string]: Permission[];
}

// Role hierarchy based on your designations
export const ROLE_PERMISSIONS: RolePermissions = {
  // Admin roles
  'MANAGING DIRECTOR': [Permission.ADMIN_FULL_ACCESS],
  'CEO': [Permission.ADMIN_FULL_ACCESS],
  'ADMIN MANAGER': [Permission.ADMIN_FULL_ACCESS],
  'BRANCH MANAGER': [Permission.ADMIN_FULL_ACCESS],
  
  // Sales roles
  'SALES HEAD': [
    Permission.SALES_VIEW_LEADS,
    Permission.SALES_MANAGE_LEADS,
    Permission.SALES_VIEW_QUOTATIONS,
    Permission.SALES_MANAGE_QUOTATIONS,
    Permission.SALES_VIEW_REPORTS,
    Permission.SALES_MANAGE_TEAM,
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
    Permission.EDIT_PROFILE,
  ],
  'SALES MANAGER': [
    Permission.SALES_VIEW_LEADS,
    Permission.SALES_MANAGE_LEADS,
    Permission.SALES_VIEW_QUOTATIONS,
    Permission.SALES_MANAGE_QUOTATIONS,
    Permission.SALES_VIEW_REPORTS,
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
    Permission.EDIT_PROFILE,
  ],
  'SALES EXECUTIVE': [
    Permission.SALES_VIEW_LEADS,
    Permission.SALES_MANAGE_LEADS,
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
    Permission.EDIT_PROFILE,
  ],
  
  // Accounting roles
  'ACCOUNTANT': [
    Permission.ACCOUNTING_VIEW_INVOICES,
    Permission.ACCOUNTING_MANAGE_INVOICES,
    Permission.ACCOUNTING_VIEW_PAYMENTS,
    Permission.ACCOUNTING_MANAGE_PAYMENTS,
    Permission.ACCOUNTING_VIEW_REPORTS,
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
    Permission.EDIT_PROFILE,
  ],
  'JUNIOR ACCOUNTANT': [
    Permission.ACCOUNTING_VIEW_INVOICES,
    Permission.ACCOUNTING_VIEW_PAYMENTS,
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
  ],
  
  // Default permissions for other roles
  'DEFAULT': [
    Permission.VIEW_DASHBOARD,
    Permission.VIEW_PROFILE,
  ],
};

declare module 'next-auth' {
  interface User extends AuthUser {}

  interface Session extends DefaultSession {
    user: User & {
      id: string;
      employee_id: string;
      first_name: string;
      last_name: string;
      email?: string;
      designation: {
        id: number;
        name: string;
      };
      permissions: Permission[];
    };
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    id: string;
    employee_id: string;
    first_name: string;
    last_name: string;
    email?: string;
    designation: {
      id: number;
      name: string;
    };
    permissions: Permission[];
  }
} 