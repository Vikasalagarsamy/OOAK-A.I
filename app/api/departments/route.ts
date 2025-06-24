import { NextRequest, NextResponse } from 'next/server'
import { getPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/departments
export async function GET() {
  const pool: Pool = getPool()

  try {
    const result = await pool.query(`
      SELECT 
        d.*,
        COUNT(e.id) as employee_count
      FROM departments d
      LEFT JOIN employees e ON d.id = e.department_id
      GROUP BY d.id
      ORDER BY d.name
    `)

    return NextResponse.json({
      success: true,
      departments: result.rows
    })
  } catch (error) {
    console.error('Error fetching departments:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch departments' },
      { status: 500 }
    )
  }
}

// POST /api/departments
export async function POST(request: NextRequest) {
  const pool: Pool = getPool()

  try {
    const body = await request.json()
    const { name, description } = body

    // Validate required fields
    if (!name) {
      return NextResponse.json(
        { success: false, error: 'Department name is required' },
        { status: 400 }
      )
    }

    const result = await pool.query(
      'INSERT INTO departments (name, description) VALUES ($1, $2) RETURNING *',
      [name, description]
    )

    return NextResponse.json({
      success: true,
      department: result.rows[0]
    })
  } catch (error) {
    console.error('Error creating department:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to create department' },
      { status: 500 }
    )
  }
} 