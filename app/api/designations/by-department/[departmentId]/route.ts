import { NextRequest, NextResponse } from 'next/server'
import { getPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/designations/by-department/[departmentId]
export async function GET(
  request: NextRequest,
  { params }: { params: { departmentId: string } }
) {
  const pool: Pool = getPool()

  try {
    const result = await pool.query(
      `SELECT 
        d.*,
        COUNT(e.id) as employee_count
      FROM designations d
      LEFT JOIN employees e ON d.id = e.designation_id
      WHERE d.department_id = $1
      GROUP BY d.id
      ORDER BY d.name`,
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