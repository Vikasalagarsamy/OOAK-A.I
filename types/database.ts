// OOAK.AI Database Type Definitions
// Generated from backup_20250621_072656.sql

export interface Employee {
  id: number;
  employee_id: string;
  name: string;
  email: string;
  phone?: string;
  role_id: number;
  department_id?: number;
  branch_id?: number;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface Lead {
  id: number;
  name: string;
  email?: string;
  phone: string;
  lead_source_id?: number;
  status: string;
  assigned_to?: number;
  created_at: Date;
  updated_at: Date;
  wedding_date?: Date;
  budget_range?: string;
  location?: string;
}

export interface Client {
  id: number;
  name: string;
  email: string;
  phone: string;
  address?: string;
  wedding_date?: Date;
  budget: number;
  status: string;
  created_at: Date;
  updated_at: Date;
}

export interface Quotation {
  id: number;
  client_id: number;
  quotation_number: string;
  total_amount: number;
  status: string;
  created_by: number;
  created_at: Date;
  updated_at: Date;
  valid_until?: Date;
}

export interface QuotationItem {
  id: number;
  quotation_id: number;
  service_id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  description?: string;
}

export interface Service {
  id: number;
  name: string;
  description?: string;
  base_price: number;
  category: string;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface Booking {
  id: number;
  client_id: number;
  quotation_id?: number;
  booking_date: Date;
  event_date: Date;
  status: string;
  total_amount: number;
  advance_paid: number;
  balance_amount: number;
  created_at: Date;
  updated_at: Date;
}

export interface Deliverable {
  id: number;
  booking_id: number;
  type: string;
  status: string;
  expected_delivery: Date;
  actual_delivery?: Date;
  file_path?: string;
  created_at: Date;
  updated_at: Date;
}

export interface Vendor {
  id: number;
  name: string;
  email?: string;
  phone: string;
  category: string;
  rating?: number;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface FollowUp {
  id: number;
  lead_id?: number;
  client_id?: number;
  type: string;
  status: string;
  scheduled_date: Date;
  completed_date?: Date;
  notes?: string;
  created_by: number;
  created_at: Date;
  updated_at: Date;
}

export interface Role {
  id: number;
  title: string;
  description?: string;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface Permission {
  id: number;
  name: string;
  description?: string;
  module: string;
  action: string;
}

export interface RolePermission {
  id: number;
  role_id: number;
  permission_id: number;
  granted: boolean;
}

export interface Department {
  id: number;
  name: string;
  description?: string;
  is_active: boolean;
}

export interface Branch {
  id: number;
  name: string;
  company_id: number;
  branch_code: string | null;
  address: string;
  phone: string | null;
  email: string | null;
  location: string | null;
}

export interface AIContact {
  id: string;
  phone?: string;
  country_code?: string;
  name?: string;
  source_id?: string;
  source_url?: string;
  internal_lead_source?: string;
  internal_closure_date?: Date;
  created_at: Date;
}

export interface AIDecisionLog {
  id: string;
  notification_id?: string;
  decision_type: string;
  decision_data: any; // JSON data
  model_version: string;
  confidence_score?: number;
  execution_time?: number;
  created_at: Date;
}

export interface AIConfiguration {
  id: number;
  config_key: string;
  config_type: string;
  config_value: string;
  version: number;
  is_active: boolean;
  created_by: string;
  created_at: Date;
  updated_at: Date;
  description?: string;
}

export interface Notification {
  id: number;
  title: string;
  message: string;
  type: string;
  user_id?: number;
  is_read: boolean;
  created_at: Date;
  updated_at: Date;
}

// Utility types for API responses
export interface ApiResponse<T> {
  data: T | null;
  success: boolean;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

// Form data types
export interface CreateLeadForm {
  name: string;
  email?: string;
  phone: string;
  lead_source_id?: number;
  wedding_date?: Date;
  budget_range?: string;
  location?: string;
  notes?: string;
}

export interface CreateClientForm {
  name: string;
  email: string;
  phone: string;
  address?: string;
  wedding_date?: Date;
  budget: number;
}

export interface CreateQuotationForm {
  client_id: number;
  services: {
    service_id: number;
    quantity: number;
    unit_price: number;
  }[];
  valid_until?: Date;
  notes?: string;
}

// Dashboard data types
export interface DashboardStats {
  total_employees: number;
  total_designations: number;
  total_menu_items: number;
  total_permissions: number;
}

export interface RecentActivity {
  id: number;
  type: string;
  description: string;
  timestamp: Date;
  user_name?: string;
}

export interface LeadSource {
  id: number;
  name: string;
  description: string | null;
  is_active: boolean;
}

export interface LeadFormValues {
  company_id: number;
  branch_id: number;
  client_name: string;
  bride_name?: string;
  groom_name?: string;
  email?: string;
  phone: string;
  whatsapp_number: string;
  country_code: string;
  whatsapp_country_code: string;
  is_whatsapp: boolean;
  priority: 'low' | 'medium' | 'high';
  tags: string[];
  source_id?: number;
  notes?: string;
  wedding_date?: string;
  venue_preference?: string;
  guest_count?: number;
  budget_range?: string;
  description?: string;
  location?: string;
}

export interface Company {
  id: number;
  name: string;
  company_code: string;
  address: string | null;
  phone: string | null;
  email: string | null;
} 