import { NextRequest, NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(`
      SELECT 
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
      ORDER BY e.created_at DESC
    `)

    return NextResponse.json({
      success: true,
      employees: result.rows
    })
  } catch (error) {
    console.error('Error fetching employees:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch employees' },
      { status: 500 }
    )
  }
}

// POST /api/people/employees
export async function POST(request: NextRequest) {
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
      company_id,
      branch_id,
      status
    } = body

    const result = await pool.query(
      `INSERT INTO employees (
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        department_id,
        designation_id,
        company_id,
        branch_id,
        status
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      RETURNING *`,
      [
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        department_id,
        designation_id,
        company_id,
        branch_id,
        status || 'active'
      ]
    )

    return NextResponse.json({
      success: true,
      employee: result.rows[0]
    })
  } catch (error) {
    console.error('Error creating employee:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to create employee' },
      { status: 500 }
    )
  }
} 