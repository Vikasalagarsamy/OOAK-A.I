import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';

export async function GET(request: NextRequest) {
  return NextResponse.json({
    message: 'Menu Setup API - Use POST method to execute setup',
    instructions: 'Send a POST request to this endpoint to add missing menu items to production'
  });
}

export async function POST(request: NextRequest) {
  try {
    console.log('🚀 Setting up missing menu items...');

    // Core menu items to add
    const coreMenus = [
      {
        name: 'Dashboard',
        string_id: 'dashboard',
        path: '/dashboard',
        icon: 'Home',
        sort_order: 1,
        description: 'Main dashboard with AI metrics'
      },
      {
        name: 'Leads Management',
        string_id: 'leads',
        path: '/leads',
        icon: 'Users',
        sort_order: 2,
        description: 'Manage leads and conversions'
      },
      {
        name: 'Admin',
        string_id: 'admin',
        path: '/admin',
        icon: 'Settings',
        sort_order: 10,
        description: 'Administration panel'
      },
      {
        name: 'Role Permissions',
        string_id: 'admin_permissions',
        path: '/admin/permissions',
        icon: 'Shield',
        sort_order: 11,
        description: 'Manage role-based permissions',
        parent_string_id: 'admin'
      }
    ];

    const results = {
      menus_added: 0,
      permissions_added: 0,
      errors: [] as string[]
    };

    // Check existing menu items
    const existingMenus = await query(`
      SELECT string_id FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);
    
    const existingStringIds = new Set(existingMenus.rows.map((row: any) => row.string_id));

    // Add missing menu items
    for (const menu of coreMenus) {
      if (!existingStringIds.has(menu.string_id)) {
        try {
          // Get next available ID
          const maxIdResult = await query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM menu_items');
          const nextId = maxIdResult.rows[0].next_id;

          // Handle parent_id for hierarchical items
          let parent_id = null;
          if (menu.parent_string_id) {
            const parentResult = await query('SELECT id FROM menu_items WHERE string_id = $1', [menu.parent_string_id]);
            if (parentResult.rows.length > 0) {
              parent_id = parentResult.rows[0].id;
            }
          }

          await query(`
            INSERT INTO menu_items (
              id, name, string_id, path, icon, sort_order, description,
              parent_id, is_visible, is_admin_only, badge_variant, 
              is_new, category, created_at, updated_at
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, true, $9, 'default', false, 'core', NOW(), NOW())
          `, [
            nextId,
            menu.name,
            menu.string_id,
            menu.path,
            menu.icon,
            menu.sort_order,
            menu.description,
            parent_id,
            menu.string_id.includes('admin')
          ]);
          
          results.menus_added++;
        } catch (error) {
          results.errors.push(`Failed to add menu ${menu.name}: ${error}`);
        }
      }
    }

    // Add role permissions for Management role (role_id = 1)
    const adminPermissions = [
      { menu_string_id: 'dashboard', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'leads', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'admin', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'admin_permissions', can_view: true, can_add: true, can_edit: true, can_delete: true },
    ];

    for (const perm of adminPermissions) {
      try {
        const existing = await query(
          'SELECT id FROM role_menu_permissions WHERE role_id = $1 AND menu_string_id = $2',
          [1, perm.menu_string_id]
        );

        if (existing.rows.length === 0) {
          const maxPermIdResult = await query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM role_menu_permissions');
          const nextPermId = maxPermIdResult.rows[0].next_id;

          await query(`
            INSERT INTO role_menu_permissions (
              id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete,
              created_at, updated_at
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
          `, [nextPermId, 1, perm.menu_string_id, perm.can_view, perm.can_add, perm.can_edit, perm.can_delete]);
          
          results.permissions_added++;
        }
      } catch (error) {
        results.errors.push(`Failed to add permission for ${perm.menu_string_id}: ${error}`);
      }
    }

    // Add basic permissions for Sales role (role_id = 2)
    const salesPermissions = [
      { menu_string_id: 'dashboard', can_view: true, can_add: false, can_edit: false, can_delete: false },
      { menu_string_id: 'leads', can_view: true, can_add: true, can_edit: true, can_delete: false },
    ];

    for (const perm of salesPermissions) {
      try {
        const existing = await query(
          'SELECT id FROM role_menu_permissions WHERE role_id = $1 AND menu_string_id = $2',
          [2, perm.menu_string_id]
        );

        if (existing.rows.length === 0) {
          const maxPermIdResult = await query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM role_menu_permissions');
          const nextPermId = maxPermIdResult.rows[0].next_id;

          await query(`
            INSERT INTO role_menu_permissions (
              id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete,
              created_at, updated_at
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
          `, [nextPermId, 2, perm.menu_string_id, perm.can_view, perm.can_add, perm.can_edit, perm.can_delete]);
          
          results.permissions_added++;
        }
      } catch (error) {
        results.errors.push(`Failed to add sales permission for ${perm.menu_string_id}: ${error}`);
      }
    }

    return NextResponse.json({
      success: true,
      message: 'Menu setup completed',
      results
    });

  } catch (error) {
    console.error('Error setting up menus:', error);
    return NextResponse.json(
      { error: 'Internal server error', details: error },
      { status: 500 }
    );
  }
} 