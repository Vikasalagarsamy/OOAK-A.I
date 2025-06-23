import { NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/departments
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      'SELECT id, name, description, created_at, updated_at FROM departments ORDER BY name'
    )

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
export async function POST(request: Request) {
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
      `INSERT INTO departments (name, description)
       VALUES ($1, $2)
       RETURNING id, name, description, created_at, updated_at`,
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