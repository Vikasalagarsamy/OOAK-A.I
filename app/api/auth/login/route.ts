import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';
import db from '@/lib/db';
import { AuthServerService } from '@/lib/auth-server';
import { Permission } from '@/types/auth';

export async function POST(request: Request) {
  try {
    const { employee_id, password } = await request.json();

    // Validate input
    if (!employee_id || !password) {
      return NextResponse.json({ 
        success: false, 
        message: 'Employee ID and password are required' 
      }, { status: 400 });
    }

    // Get employee from database
    const result = await db.query(
      'SELECT e.*, d.name as designation_name, d.permissions FROM employees e LEFT JOIN designations d ON e.designation_id = d.id WHERE e.employee_id = $1',
      [employee_id]
    );

    const employee = result.rows[0];

    if (!employee) {
      return NextResponse.json({ 
        success: false, 
        message: 'Invalid credentials' 
      }, { status: 401 });
    }

    // Verify password
    const isValid = await AuthServerService.verifyPassword(password, employee.password);

    if (!isValid) {
      return NextResponse.json({ 
        success: false, 
        message: 'Invalid credentials' 
      }, { status: 401 });
    }

    // Generate JWT token with only the required fields from JWTPayload type
    const token = AuthServerService.generateToken({
      userId: employee.id,
      employee_id: employee.employee_id,
      designation_id: employee.designation_id || 0
    });

    // Set cookie
    cookies().set('auth_token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60 // 7 days
    });

    // Return user data
    return NextResponse.json({
      success: true,
      user: {
        id: employee.id,
        employee_id: employee.employee_id,
        name: employee.name,
        designation_id: employee.designation_id,
        designation_name: employee.designation_name,
        permissions: employee.permissions || []
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json({ 
      success: false, 
      message: 'Internal server error' 
    }, { status: 500 });
  }
} 