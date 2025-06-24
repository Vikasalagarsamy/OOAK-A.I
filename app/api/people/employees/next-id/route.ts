import { NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees/next-id
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    // Get the latest employee ID by ordering numerically
    const result = await pool.query(`
      SELECT employee_id 
      FROM employees 
      WHERE employee_id ~ '^EMP-\\d{2}-\\d{4}$'
      ORDER BY 
        CAST(SPLIT_PART(employee_id, '-', 2) AS INTEGER) DESC,
        CAST(SPLIT_PART(employee_id, '-', 3) AS INTEGER) DESC 
      LIMIT 1
    `)

    let nextId = 'EMP-25-0001'
    
    if (result.rows.length > 0) {
      const lastId = result.rows[0].employee_id
      const parts = lastId.split('-')
      const prefix = parts[0]
      const middlePart = parts[1]
      const numericPart = parseInt(parts[2])
      const nextNumeric = numericPart + 1
      nextId = `${prefix}-${middlePart}-${nextNumeric.toString().padStart(4, '0')}`
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