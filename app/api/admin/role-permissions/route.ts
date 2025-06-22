import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';

// GET all role permissions
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const roleId = searchParams.get('roleId');

    let queryStr = `
      SELECT 
        rmp.id,
        rmp.role_id,
        rmp.menu_string_id,
        rmp.can_view,
        rmp.can_add,
        rmp.can_edit,
        rmp.can_delete,
        rmp.created_at,
        rmp.updated_at,
        mi.name as menu_name,
        mi.description as menu_description,
        mi.icon,
        mi.path,
        mi.parent_id,
        CASE 
          WHEN parent_mi.name IS NOT NULL 
          THEN parent_mi.name || ' > ' || mi.name 
          ELSE mi.name 
        END as full_menu_path
      FROM role_menu_permissions rmp
      LEFT JOIN menu_items mi ON rmp.menu_string_id = mi.string_id
      LEFT JOIN menu_items parent_mi ON mi.parent_id = parent_mi.id
    `;

    const params = [];
    if (roleId) {
      queryStr += ' WHERE rmp.role_id = $1';
      params.push(parseInt(roleId));
    }

    queryStr += ' ORDER BY mi.sort_order ASC';

    const result = await query(queryStr, params);

    return NextResponse.json({
      success: true,
      data: result.rows
    });

  } catch (error) {
    console.error('Error fetching role permissions:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// POST - Create new role permission
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { role_id, menu_string_id, can_view, can_add, can_edit, can_delete } = body;

    // Validate required fields
    if (!role_id || !menu_string_id) {
      return NextResponse.json(
        { error: 'role_id and menu_string_id are required' },
        { status: 400 }
      );
    }

    // Check if permission already exists
    const existingResult = await query(`
      SELECT id FROM role_menu_permissions 
      WHERE role_id = $1 AND menu_string_id = $2
    `, [role_id, menu_string_id]);

    if (existingResult.rows.length > 0) {
      return NextResponse.json(
        { error: 'Permission already exists for this role and menu' },
        { status: 409 }
      );
    }

    // Create new permission
    const result = await query(`
      INSERT INTO role_menu_permissions 
      (role_id, menu_string_id, can_view, can_add, can_edit, can_delete, created_at, updated_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
      RETURNING *
    `, [
      role_id,
      menu_string_id,
      can_view || false,
      can_add || false,
      can_edit || false,
      can_delete || false
    ]);

    return NextResponse.json({
      success: true,
      data: result.rows[0],
      message: 'Role permission created successfully'
    });

  } catch (error) {
    console.error('Error creating role permission:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// PUT - Update role permission
export async function PUT(request: NextRequest) {
  try {
    const body = await request.json();
    const { id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete } = body;

    if (!id) {
      return NextResponse.json(
        { error: 'Permission ID is required' },
        { status: 400 }
      );
    }

    const result = await query(`
      UPDATE role_menu_permissions 
      SET 
        role_id = COALESCE($1, role_id),
        menu_string_id = COALESCE($2, menu_string_id),
        can_view = COALESCE($3, can_view),
        can_add = COALESCE($4, can_add),
        can_edit = COALESCE($5, can_edit),
        can_delete = COALESCE($6, can_delete),
        updated_at = NOW()
      WHERE id = $7
      RETURNING *
    `, [role_id, menu_string_id, can_view, can_add, can_edit, can_delete, id]);

    if (result.rows.length === 0) {
      return NextResponse.json(
        { error: 'Permission not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      data: result.rows[0],
      message: 'Role permission updated successfully'
    });

  } catch (error) {
    console.error('Error updating role permission:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// DELETE - Remove role permission
export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');

    if (!id) {
      return NextResponse.json(
        { error: 'Permission ID is required' },
        { status: 400 }
      );
    }

    const result = await query(`
      DELETE FROM role_menu_permissions 
      WHERE id = $1
      RETURNING *
    `, [parseInt(id)]);

    if (result.rows.length === 0) {
      return NextResponse.json(
        { error: 'Permission not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      message: 'Role permission deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting role permission:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
} 