import { NextResponse } from 'next/server';
import { getDbPool } from '@/lib/db';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

// Specify Node.js runtime and force dynamic rendering
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

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
  level: number;
  children?: MenuItem[];
}

interface QueryResult {
  rows: MenuItem[];
}

export async function GET(request: Request) {
  try {
    // Get current user from session
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.designation?.id) {
      return NextResponse.json(
        { error: 'Not authenticated' },
        { status: 401 }
      );
    }

    const pool = getDbPool();
    
    // Get menu permissions for the user's designation
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
    `, [session.user.designation.id]) as QueryResult;

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
    result.rows.forEach(item => {
      menuMap.set(item.id, {
        ...item,
        children: []
      });
    });

    // Second pass: Build the tree structure
    result.rows.forEach(item => {
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