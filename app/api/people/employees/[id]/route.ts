import { NextRequest, NextResponse } from 'next/server'
import { getPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees/[id]
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getPool()

  try {
    const result = await pool.query(
      `SELECT 
        e.*,
        d.name as designation_name,
        dp.name as department_name,
        c.name as company_name,
        b.name as branch_name
      FROM employees e
      LEFT JOIN designations d ON e.designation_id = d.id
      LEFT JOIN departments dp ON e.department_id = dp.id
      LEFT JOIN companies c ON e.company_id = c.id
      LEFT JOIN branches b ON e.branch_id = b.id
      WHERE e.id = $1`,
      [params.id]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Employee not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      employee: result.rows[0]
    })
  } catch (error) {
    console.error('Error fetching employee:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch employee' },
      { status: 500 }
    )
  }
}

// PUT /api/people/employees/[id]
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getPool()

  try {
    const body = await request.json()
    const {
      first_name,
      last_name,
      email,
      phone,
      department_id,
      designation_id,
      company_id,
      branch_id,
      status
    } = body

    const result = await pool.query(
      `UPDATE employees SET
        first_name = $1,
        last_name = $2,
        email = $3,
        phone = $4,
        department_id = $5,
        designation_id = $6,
        company_id = $7,
        branch_id = $8,
        status = $9,
        updated_at = NOW()
      WHERE id = $10
      RETURNING *`,
      [
        first_name,
        last_name,
        email,
        phone,
        department_id,
        designation_id,
        company_id,
        branch_id,
        status,
        params.id
      ]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Employee not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      employee: result.rows[0]
    })
  } catch (error) {
    console.error('Error updating employee:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to update employee' },
      { status: 500 }
    )
  }
}

// DELETE /api/people/employees/[id]
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getPool()

  try {
    const result = await pool.query(
      'DELETE FROM employees WHERE id = $1 RETURNING *',
      [params.id]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Employee not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      message: 'Employee deleted successfully'
    })
  } catch (error) {
    console.error('Error deleting employee:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to delete employee' },
      { status: 500 }
    )
  }
} 