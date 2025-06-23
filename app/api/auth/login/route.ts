import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import db from '@/lib/db'
import { AUTH_COOKIE_NAME, AUTH_COOKIE_OPTIONS, AUTH_ERRORS } from '@/lib/constants'
import { AuthService } from '@/lib/auth'

export async function POST(request: Request) {
  try {
    const body = await request.json()
    const { employee_id, password } = body

    console.log('Login attempt for:', employee_id)

    // Input validation
    if (!employee_id || !password) {
      return NextResponse.json(
        { error: 'Employee ID and password are required' },
        { status: 400 }
      )
    }

    // Get employee from database
    const result = await db.query(
      `SELECT 
        e.id,
        e.employee_id,
        e.password_hash,
        e.first_name,
        e.last_name,
        e.designation_id,
        d.name as designation_name,
        ARRAY_AGG(DISTINCT dmp.menu_item_id) as permissions
      FROM employees e 
      LEFT JOIN designations d ON e.designation_id = d.id 
      LEFT JOIN designation_menu_permissions dmp ON d.id = dmp.designation_id AND dmp.can_view = true
      WHERE e.employee_id = $1 AND e.is_active = true
      GROUP BY e.id, e.first_name, e.last_name, d.name, e.designation_id, e.password_hash`,
      [employee_id]
    )

    const employee = result.rows[0]

    console.log('Employee found:', !!employee)

    // Employee not found or invalid password
    if (!employee || !employee.password_hash) {
      return NextResponse.json(
        { error: AUTH_ERRORS.INVALID_CREDENTIALS },
        { status: 401 }
      )
    }

    const isValidPassword = await bcrypt.compare(password, employee.password_hash)
    
    console.log('Password valid:', isValidPassword)

    if (!isValidPassword) {
      return NextResponse.json(
        { error: AUTH_ERRORS.INVALID_CREDENTIALS },
        { status: 401 }
      )
    }

    // Create JWT token
    const token = await AuthService.generateToken({
      userId: employee.id,
      employee_id: employee.employee_id,
      designation_id: employee.designation_id
    })

    // Create the response object first
    const response = new NextResponse(
      JSON.stringify({
        success: true,
        user: {
          id: employee.id,
          employee_id: employee.employee_id,
          name: `${employee.first_name} ${employee.last_name}`,
          designation: {
            id: employee.designation_id,
            name: employee.designation_name
          },
          permissions: employee.permissions || []
        }
      }),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
        }
      }
    )

    // Set the cookie on the response
    response.cookies.set(AUTH_COOKIE_NAME, token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      path: '/',
      maxAge: 7 * 24 * 60 * 60 // 7 days
    })

    console.log('Login successful, cookie set:', {
      cookieName: AUTH_COOKIE_NAME,
      tokenLength: token.length,
      secure: process.env.NODE_ENV === 'production'
    })

    return response

  } catch (error) {
    console.error('Login error:', error)
    return NextResponse.json(
      { error: AUTH_ERRORS.SERVER_ERROR },
      { status: 500 }
    )
  }
} 