import { NextRequest, NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/organization/branches/by-company/[companyId]
export async function GET(
  request: NextRequest,
  { params }: { params: { companyId: string } }
) {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      'SELECT id, name FROM branches WHERE company_id = $1 ORDER BY name',
      [params.companyId]
    )

    return NextResponse.json({
      success: true,
      branches: result.rows
    })
  } catch (error) {
    console.error('Error fetching branches:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch branches' },
      { status: 500 }
    )
  }
} 