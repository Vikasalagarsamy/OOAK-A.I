export interface Company {
  id: number;
  name: string;
  registration_number?: string;
  tax_id?: string;
  address?: string;
  phone?: string;
  email?: string;
  website?: string;
  founded_date?: string;
  company_code?: string;
  created_at?: string;
  updated_at?: string;
}

export interface EmployeeCompany {
  id: number;
  employee_id: number;
  company_id: number;
  branch_id?: number;
  allocation_percentage: number;
  is_primary: boolean;
  start_date?: string;
  end_date?: string;
  project_id?: string;
  status: 'active' | 'inactive';
  created_at?: string;
  updated_at?: string;
}

export interface CompanyFormData {
  name: string;
  registration_number?: string;
  tax_id?: string;
  address?: string;
  phone?: string;
  email?: string;
  website?: string;
  founded_date?: string;
  company_code?: string;
}

export interface CompanyWithEmployees extends Company {
  employees: EmployeeCompany[];
}

export interface Branch {
  id: number;
  company_id: number;
  name: string;
  address: string;
  phone?: string;
  email?: string;
  manager_id?: number;
  is_remote: boolean;
  created_at?: string;
  updated_at?: string;
  branch_code?: string;
  location?: string;
  company_name?: string;
}

export interface BranchFormData {
  name: string;
  company_id: number;
  address: string;
  phone?: string;
  email?: string;
  manager_id?: number;
  is_remote: boolean;
  branch_code?: string;
  location?: string;
} 