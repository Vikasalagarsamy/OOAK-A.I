import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

// GET /api/designations
export async function GET() {
  try {
    const result = await query(`
      SELECT d.*, dep.name as department_name 
      FROM designations d
      LEFT JOIN departments dep ON d.department_id = dep.id
      ORDER BY dep.name, d.name
    `);
    if (!result.success) {
      throw new Error(result.error);
    }
    return NextResponse.json({ success: true, designations: result.data });
  } catch (error) {
    console.error('Error fetching designations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch designations' },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const { name, department_id, description } = await request.json();

    // Validate required fields
    if (!name || !department_id) {
      return NextResponse.json(
        { success: false, error: 'Name and department are required' },
        { status: 400 }
      );
    }

    // Check if department exists
    const deptCheck = await query('SELECT id FROM departments WHERE id = $1', [department_id]);
    if (!deptCheck.success || !deptCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Department not found' },
        { status: 404 }
      );
    }

    // Check for duplicate designation name in the same department
    const duplicateCheck = await query(
      'SELECT id FROM designations WHERE name = $1 AND department_id = $2',
      [name, department_id]
    );
    if (!duplicateCheck.success) {
      throw new Error(duplicateCheck.error);
    }
    if (duplicateCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Designation already exists in this department' },
        { status: 400 }
      );
    }

    // Insert new designation
    const result = await query(
      `INSERT INTO designations (name, department_id, description)
       VALUES ($1, $2, $3)
       RETURNING id, name, department_id, description, created_at, updated_at`,
      [name, department_id, description]
    );
    if (!result.success) {
      throw new Error(result.error);
    }

    return NextResponse.json({ success: true, designation: result.data?.[0] });
  } catch (error) {
    console.error('Error creating designation:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to create designation' },
      { status: 500 }
    );
  }
} 