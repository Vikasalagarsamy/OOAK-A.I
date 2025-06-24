import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import db from '@/lib/db'
import { AUTH_COOKIE_NAME, AUTH_COOKIE_OPTIONS, AUTH_ERRORS } from '@/lib/constants'
import { AuthService } from '@/lib/auth'

// Specify Node.js runtime
export const runtime = 'nodejs'

export async function POST(request: Request) {
  try {
    const body = await request.json()
    const { employee_id, password } = body

    if (!employee_id || !password) {
      return new NextResponse(
        JSON.stringify({ error: 'Employee ID and password are required' }),
        { status: 400 }
      )
    }

    console.log('Attempting login for employee:', employee_id)

    // Get employee with designation
    const result = await db.query(`
      SELECT 
        e.id,
        e.employee_id,
        e.first_name,
        e.last_name,
        e.email,
        e.department_id,
        e.designation_id,
        e.password_hash,
        d.name as designation_name
      FROM employees e
      LEFT JOIN designations d ON e.designation_id = d.id
      WHERE e.employee_id = $1 AND e.status = 'active'
    `, [employee_id])

    if (!result.success || !result.data || result.data.length === 0) {
      console.log('Employee not found')
      return new NextResponse(
        JSON.stringify({ error: 'Invalid credentials' }),
        { status: 401 }
      )
    }

    const employee = result.data[0]

    console.log('Employee found:', !!employee)

    // Check if password hash exists
    if (!employee.password_hash) {
      console.log('No password hash found')
      return new NextResponse(
        JSON.stringify({ error: 'Password not set' }),
        { status: 401 }
      )
    }

    // Verify password
    const isValidPassword = await AuthService.verifyPassword(
      password,
      employee.password_hash
    )

    if (!isValidPassword) {
      console.log('Invalid password')
      return new NextResponse(
        JSON.stringify({ error: 'Invalid credentials' }),
        { status: 401 }
      )
    }

    // Get user permissions
    const permissions = AuthService.getUserPermissions(
      employee.designation_name || ''
    )

    // Create authenticated user object
    const user = {
      id: employee.id,
      employee_id: employee.employee_id,
      first_name: employee.first_name,
      last_name: employee.last_name,
      email: employee.email,
      designation: {
        id: employee.designation_id,
        name: employee.designation_name || 'Unknown',
      },
      department_id: employee.department_id,
      permissions,
    }

    // Generate JWT token
    const token = await AuthService.generateToken({
      userId: user.id,
      employee_id: user.employee_id,
      designation_id: user.designation.id,
    })

    // Set auth cookie
    AuthService.setAuthCookie(token)

    return new NextResponse(JSON.stringify({ user }))
  } catch (error) {
    console.error('Login error:', error)
    return new NextResponse(
      JSON.stringify({ error: 'An error occurred during login' }),
      { status: 500 }
    )
  }
} 