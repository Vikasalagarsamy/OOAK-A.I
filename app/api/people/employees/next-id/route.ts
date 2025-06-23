import { NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees/next-id
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      'SELECT employee_id FROM employees ORDER BY id DESC LIMIT 1'
    )

    let nextId = 'EMP-25-0001'
    
    if (result.rows.length > 0) {
      const lastId = result.rows[0].employee_id
      const numericPart = parseInt(lastId.split('-')[2])
      const nextNumeric = numericPart + 1
      nextId = `EMP-25-${nextNumeric.toString().padStart(4, '0')}`
    }

    return NextResponse.json({
      success: true,
      nextId
    })
  } catch (error) {
    console.error('Error generating next employee ID:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to generate next employee ID' },
      { status: 500 }
    )
  }
} 