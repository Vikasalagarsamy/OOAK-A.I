import { NextResponse } from 'next/server'
import { getPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/people/employees/next-id
export async function GET() {
  const pool: Pool = getPool()

  try {
    // Get the current year's last two digits
    const currentYear = new Date().getFullYear().toString().slice(-2)

    // Get the latest employee ID for the current year
    const result = await pool.query(
      "SELECT employee_id FROM employees WHERE employee_id LIKE $1 ORDER BY employee_id DESC LIMIT 1",
      [`EMP-${currentYear}-%`]
    )

    let nextNumber = 1
    if (result.rows.length > 0) {
      // Extract the sequence number from the last employee ID
      const lastId = result.rows[0].employee_id
      const lastNumber = parseInt(lastId.split('-')[2])
      nextNumber = lastNumber + 1
    }

    // Format the new employee ID
    const nextId = `EMP-${currentYear}-${nextNumber.toString().padStart(4, '0')}`

    return NextResponse.json({
      success: true,
      employee_id: nextId
    })
  } catch (error) {
    console.error('Error generating next employee ID:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to generate next employee ID' },
      { status: 500 }
    )
  }
} 