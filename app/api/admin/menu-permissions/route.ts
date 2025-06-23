import { NextResponse } from 'next/server';
import { getDbPool } from '@/lib/db';
import { AuthService } from '@/lib/auth';
import { QueryResult } from 'pg';

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

// Get all menu permissions for a designation
export async function GET(request: Request) {
  try {
    // Get current user
    const user = await AuthService.getCurrentUser();
    
    if (!user) {
      return NextResponse.json(
        { error: 'Not authenticated' },
        { status: 401 }
      );
    }

    // Get designation ID from query string
    const url = new URL(request.url);
    const designationId = url.searchParams.get('designationId');

    if (!designationId) {
      return NextResponse.json(
        { error: 'Designation ID is required' },
        { status: 400 }
      );
    }

    const pool = getDbPool();
    
    // Get menu permissions for the specified designation
    const result = await pool.query<MenuItem>(`
      WITH RECURSIVE menu_tree AS (
        -- Get parent menu items with permissions
        SELECT 
          mi.id,
          mi.name,
          mi.path,
          mi.icon,
          mi.parent_id,
          mi.string_id,
          mi.section_name,
          mi.is_admin_only,
          mi.sort_order,
          mi.is_visible,
          COALESCE(dmp.can_view, false) as can_view,
          1 as level
        FROM menu_items mi
        LEFT JOIN designation_menu_permissions dmp 
          ON mi.id = dmp.menu_item_id 
          AND dmp.designation_id = $1
        WHERE mi.parent_id IS NULL
        
        UNION ALL
        
        -- Get child menu items
        SELECT 
          mi.id,
          mi.name,
          mi.path,
          mi.icon,
          mi.parent_id,
          mi.string_id,
          mi.section_name,
          mi.is_admin_only,
          mi.sort_order,
          mi.is_visible,
          COALESCE(dmp.can_view, false) as can_view,
          mt.level + 1
        FROM menu_items mi
        LEFT JOIN designation_menu_permissions dmp 
          ON mi.id = dmp.menu_item_id 
          AND dmp.designation_id = $1
        INNER JOIN menu_tree mt ON mi.parent_id = mt.id
      )
      SELECT *
      FROM menu_tree
      ORDER BY level, sort_order, name;
    `, [designationId]);

    if (!result.rows) {
      return NextResponse.json(
        { error: 'Failed to fetch menu permissions' },
        { status: 500 }
      );
    }

    // Convert flat structure to tree
    const menuMap = new Map<number, MenuItem>();
    const rootItems: MenuItem[] = [];

    // First pass: Create all menu items
    result.rows.forEach((item: MenuItem) => {
      menuMap.set(item.id, {
        ...item,
        children: []
      });
    });

    // Second pass: Build the tree structure
    result.rows.forEach((item: MenuItem) => {
      const menuItem = menuMap.get(item.id);
      if (item.parent_id === null) {
        rootItems.push(menuItem!);
      } else {
        const parent = menuMap.get(item.parent_id);
        if (parent) {
          parent.children = parent.children || [];
          parent.children.push(menuItem!);
        }
      }
    });

    return NextResponse.json({
      success: true,
      items: rootItems
    });
  } catch (error) {
    console.error('Error fetching menu permissions:', error);
    return NextResponse.json(
      { error: 'Failed to fetch menu permissions' },
      { status: 500 }
    );
  }
}

// Update menu permissions for a designation
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { designationId, permissions, employeeId } = body;

    if (!designationId || !permissions || !Array.isArray(permissions)) {
      console.error('Invalid request data:', { designationId, permissions, employeeId });
      return NextResponse.json(
        { error: 'Invalid request data' },
        { status: 400 }
      );
    }

    if (!employeeId) {
      console.error('Employee ID is required but not provided');
      return NextResponse.json(
        { error: 'Employee ID is required' },
        { status: 400 }
      );
    }

    const pool = getDbPool();
    
    // Start a transaction
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Delete existing permissions for this designation
      await client.query(
        'DELETE FROM designation_menu_permissions WHERE designation_id = $1',
        [designationId]
      );

      // Insert new permissions
      for (const { menuItemId, canView } of permissions) {
        try {
          await client.query(`
            INSERT INTO designation_menu_permissions 
            (designation_id, menu_item_id, can_view, created_by, updated_by)
            VALUES ($1, $2, $3, $4, $4)
          `, [designationId, menuItemId, canView, employeeId]);
        } catch (insertError) {
          console.error('Error inserting permission:', {
            designationId,
            menuItemId,
            canView,
            employeeId,
            error: insertError
          });
          throw insertError;
        }

        // If parent menu item is enabled, ensure all parent items are also enabled
        if (canView) {
          try {
            await client.query(`
              WITH RECURSIVE menu_parents AS (
                SELECT parent_id
                FROM menu_items
                WHERE id = $1
                
                UNION
                
                SELECT mi.parent_id
                FROM menu_items mi
                INNER JOIN menu_parents mp ON mi.id = mp.parent_id
                WHERE mi.parent_id IS NOT NULL
              )
              INSERT INTO designation_menu_permissions 
                (designation_id, menu_item_id, can_view, created_by, updated_by)
              SELECT $2, parent_id, true, $3, $3
              FROM menu_parents
              WHERE parent_id IS NOT NULL
              ON CONFLICT (designation_id, menu_item_id) 
              DO UPDATE SET can_view = EXCLUDED.can_view;
            `, [menuItemId, designationId, employeeId]);
          } catch (parentError) {
            console.error('Error updating parent permissions:', {
              menuItemId,
              designationId,
              employeeId,
              error: parentError
            });
            throw parentError;
          }
        }
      }

      await client.query('COMMIT');
      return NextResponse.json({ success: true });
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('Transaction error:', error);
      return NextResponse.json(
        { error: error instanceof Error ? error.message : 'Failed to update menu permissions' },
        { status: 500 }
      );
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error updating menu permissions:', error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to update menu permissions' },
      { status: 500 }
    );
  }
} 