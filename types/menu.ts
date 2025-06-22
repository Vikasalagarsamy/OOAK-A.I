export interface MenuItem {
  id: number;
  parent_id?: number;
  name: string;
  description: string;
  icon: string;
  path: string;
  sort_order: number;
  is_visible: boolean;
  created_at: string;
  updated_at: string;
  string_id: string;
  section_name?: string;
  is_admin_only: boolean;
  badge_text?: string;
  badge_variant: string;
  is_new: boolean;
  category: string;
  children?: MenuItem[];
}

export interface RoleMenuPermission {
  id: number;
  role_id: number;
  can_view: boolean;
  can_add: boolean;
  can_edit: boolean;
  can_delete: boolean;
  created_at: string;
  updated_at: string;
  created_by?: string;
  updated_by?: string;
  description?: string;
  menu_string_id: string;
}

export interface UserRole {
  id: number;
  name: string;
  description?: string;
  permissions?: string;
  created_at: string;
  updated_at: string;
}

export interface Department {
  id: number;
  name: string;
  description?: string;
  created_at: string;
  updated_at: string;
}

export interface MenuPermissions {
  can_view: boolean;
  can_add: boolean;
  can_edit: boolean;
  can_delete: boolean;
}

export interface EmployeeMenuAccess {
  employee_id: number;
  department_name: string;
  role_id?: number;
  role_name?: string;
  menu_items: (MenuItem & MenuPermissions)[];
} 