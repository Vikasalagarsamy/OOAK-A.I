import { NextRequest, NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// PUT /api/departments/[id]
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getDbPool()

  try {
    const { name, description } = await request.json()

    // Validate required fields
    if (!name) {
      return NextResponse.json(
        { success: false, error: 'Department name is required' },
        { status: 400 }
      )
    }

    const result = await pool.query(
      `UPDATE departments
       SET name = $1, description = $2, updated_at = CURRENT_TIMESTAMP
       WHERE id = $3
       RETURNING id, name, description, created_at, updated_at`,
      [name, description, params.id]
    )

    if (result.rowCount === 0) {
      return NextResponse.json(
        { success: false, error: 'Department not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      department: result.rows[0]
    })
  } catch (error) {
    console.error('Error updating department:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to update department' },
      { status: 500 }
    )
  }
}

// DELETE /api/departments/[id]
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getDbPool()

  try {
    // Check if the department has any designations
    const designationsCheck = await pool.query(
      'SELECT COUNT(*) FROM designations WHERE department_id = $1',
      [params.id]
    )

    if (parseInt(designationsCheck.rows[0].count) > 0) {
      return NextResponse.json(
        {
          success: false,
          error: 'Cannot delete department with existing designations'
        },
        { status: 400 }
      )
    }

    // Check if the department has any employees
    const employeesCheck = await pool.query(
      'SELECT COUNT(*) FROM employees WHERE department_id = $1',
      [params.id]
    )

    if (parseInt(employeesCheck.rows[0].count) > 0) {
      return NextResponse.json(
        {
          success: false,
          error: 'Cannot delete department with existing employees'
        },
        { status: 400 }
      )
    }

    const result = await pool.query(
      'DELETE FROM departments WHERE id = $1 RETURNING id',
      [params.id]
    )

    if (result.rowCount === 0) {
      return NextResponse.json(
        { success: false, error: 'Department not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      message: 'Department deleted successfully'
    })
  } catch (error) {
    console.error('Error deleting department:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to delete department' },
      { status: 500 }
    )
  }
} 