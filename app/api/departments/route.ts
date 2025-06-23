import { NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/departments
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      'SELECT id, name FROM departments ORDER BY name'
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