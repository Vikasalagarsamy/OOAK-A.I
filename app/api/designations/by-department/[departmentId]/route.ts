import { NextRequest, NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/designations/by-department/[departmentId]
export async function GET(
  request: NextRequest,
  { params }: { params: { departmentId: string } }
) {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      'SELECT id, name FROM designations WHERE department_id = $1 ORDER BY name',
      [params.departmentId]
    )

    return NextResponse.json({
      success: true,
      designations: result.rows
    })
  } catch (error) {
    console.error('Error fetching designations:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch designations' },
      { status: 500 }
    )
  }
} 