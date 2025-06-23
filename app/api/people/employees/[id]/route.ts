import { NextRequest, NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees/[id]
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      `SELECT 
        e.*,
        d.name as department_name,
        des.name as designation_name,
        b.name as branch_name,
        c.name as company_name
      FROM employees e
      LEFT JOIN departments d ON e.department_id = d.id
      LEFT JOIN designations des ON e.designation_id = des.id
      LEFT JOIN branches b ON e.home_branch_id = b.id
      LEFT JOIN companies c ON e.primary_company_id = c.id
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
  const pool: Pool = getDbPool()

  try {
    const body = await request.json()
    const {
      employee_id,
      first_name,
      last_name,
      email,
      phone,
      department_id,
      designation_id,
      home_branch_id,
      primary_company_id,
      status
    } = body

    const result = await pool.query(
      `UPDATE employees
      SET 
        employee_id = $1,
        first_name = $2,
        last_name = $3,
        email = $4,
        phone = $5,
        department_id = $6,
        designation_id = $7,
        home_branch_id = $8,
        primary_company_id = $9,
        status = $10,
        updated_at = NOW()
      WHERE id = $11
      RETURNING *`,
      [
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        department_id,
        designation_id,
        home_branch_id,
        primary_company_id,
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
  const pool: Pool = getDbPool()

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