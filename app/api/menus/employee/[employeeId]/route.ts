import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { MenuItem, RoleMenuPermission, EmployeeMenuAccess } from '@/types/menu';

export async function GET(
  request: NextRequest,
  { params }: { params: { employeeId: string } }
) {
  try {
    const employeeId = parseInt(params.employeeId);

    if (isNaN(employeeId)) {
      return NextResponse.json(
        { error: 'Invalid employee ID' },
        { status: 400 }
      );
    }

    // Get employee details with department
    const employeeResult = await query(`
      SELECT 
        e.id,
        e.first_name,
        e.last_name,
        e.employee_id,
        d.name as department_name,
        d.id as department_id
      FROM employees e
      LEFT JOIN departments d ON e.department_id = d.id
      WHERE e.id = $1
    `, [employeeId]);

    if (employeeResult.rows.length === 0) {
      return NextResponse.json(
        { error: 'Employee not found' },
        { status: 404 }
      );
    }

    const employee = employeeResult.rows[0];

    // Get role ID based on department (you can customize this logic)
    // For now, we'll map departments to role IDs
    const departmentRoleMapping: { [key: string]: number } = {
      'SALES': 2,
      'ACCOUNTS': 3,
      'MANAGEMENT': 1,
      'POST PRODUCTION': 4,
      'PHOTOGRAPHY': 5,
      'QUALITY CHECK': 6,
      'CANDID PHOTOGRAPHY': 5,
      'DATA MANAGEMENT': 7,
      'OFFICE ADMINISTRATION': 8,
      'EVENT COORDINATION': 9,
      'RETOUCH': 4,
      'SUPPORT SERVICE': 8,
      'VIDEOGRAPHY': 10,
      'CINEMATOGRAPHY': 10,
      'HUMAN RESOURCE': 11,
      'VIDEO EDITING': 4,
      'BUSINESS DEVELOPMENT': 2,
      'DESIGN': 12,
      'SOCIAL MEDIA': 13,
      'VENDOR': 14,
      'COLOUR CORRECTION': 4
    };

    const roleId = departmentRoleMapping[employee.department_name] || 15; // Default role

    // Get all menu items
    const menuItemsResult = await query(`
      SELECT 
        id,
        parent_id,
        name,
        description,
        icon,
        path,
        sort_order,
        is_visible,
        created_at,
        updated_at,
        string_id,
        section_name,
        is_admin_only,
        badge_text,
        badge_variant,
        is_new,
        category
      FROM menu_items
      WHERE is_visible = true
      ORDER BY sort_order ASC
    `);

    // Get role permissions for this employee's role
    const permissionsResult = await query(`
      SELECT 
        menu_string_id,
        can_view,
        can_add,
        can_edit,
        can_delete
      FROM role_menu_permissions
      WHERE role_id = $1
    `, [roleId]);

    // Create permissions map
    const permissionsMap = new Map();
    permissionsResult.rows.forEach((perm: any) => {
      permissionsMap.set(perm.menu_string_id, {
        can_view: perm.can_view,
        can_add: perm.can_add,
        can_edit: perm.can_edit,
        can_delete: perm.can_delete
      });
    });

    // Filter menu items based on permissions and build hierarchy
    const allowedMenuItems = menuItemsResult.rows
      .filter((item: MenuItem) => {
        const permission = permissionsMap.get(item.string_id);
        return permission && permission.can_view;
      })
      .map((item: MenuItem) => {
        const permission = permissionsMap.get(item.string_id) || {
          can_view: false,
          can_add: false,
          can_edit: false,
          can_delete: false
        };
        return {
          ...item,
          ...permission
        };
      });

    // Build menu hierarchy
    const menuHierarchy = buildMenuHierarchy(allowedMenuItems);

    const response: EmployeeMenuAccess = {
      employee_id: employee.id,
      department_name: employee.department_name,
      role_id: roleId,
      role_name: getDepartmentRoleName(employee.department_name),
      menu_items: menuHierarchy
    };

    return NextResponse.json(response);

  } catch (error) {
    console.error('Error fetching employee menu access:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

function buildMenuHierarchy(menuItems: any[]): any[] {
  const itemMap = new Map();
  const rootItems: any[] = [];

  // Create map of all items
  menuItems.forEach(item => {
    itemMap.set(item.id, { ...item, children: [] });
  });

  // Build hierarchy
  menuItems.forEach(item => {
    const menuItem = itemMap.get(item.id);
    if (item.parent_id && itemMap.has(item.parent_id)) {
      itemMap.get(item.parent_id).children.push(menuItem);
    } else {
      rootItems.push(menuItem);
    }
  });

  return rootItems.sort((a, b) => a.sort_order - b.sort_order);
}

function getDepartmentRoleName(departmentName: string): string {
  const roleNames: { [key: string]: string } = {
    'SALES': 'Sales Executive',
    'ACCOUNTS': 'Accountant',
    'MANAGEMENT': 'Manager',
    'POST PRODUCTION': 'Post Production Artist',
    'PHOTOGRAPHY': 'Photographer',
    'QUALITY CHECK': 'Quality Analyst',
    'CANDID PHOTOGRAPHY': 'Candid Photographer',
    'DATA MANAGEMENT': 'Data Manager',
    'OFFICE ADMINISTRATION': 'Admin Staff',
    'EVENT COORDINATION': 'Event Coordinator',
    'RETOUCH': 'Retoucher',
    'SUPPORT SERVICE': 'Support Staff',
    'VIDEOGRAPHY': 'Videographer',
    'CINEMATOGRAPHY': 'Cinematographer',
    'HUMAN RESOURCE': 'HR Executive',
    'VIDEO EDITING': 'Video Editor',
    'BUSINESS DEVELOPMENT': 'Business Developer',
    'DESIGN': 'Designer',
    'SOCIAL MEDIA': 'Social Media Manager',
    'VENDOR': 'Vendor Manager',
    'COLOUR CORRECTION': 'Color Correction Artist'
  };

  return roleNames[departmentName] || 'Employee';
} 