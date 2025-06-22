import { NextRequest, NextResponse } from 'next/server';
import { AuthService } from '@/lib/auth';
import { LoginCredentials, JWTPayload } from '@/types/auth';

export async function POST(request: NextRequest) {
  try {
    const body: LoginCredentials = await request.json();
    const { employee_id, password } = body;

    // Validate input
    if (!employee_id || !password) {
      return NextResponse.json(
        { success: false, message: 'Employee ID and password are required' },
        { status: 400 }
      );
    }

    // Authenticate user
    const user = await AuthService.authenticateUser(employee_id, password);
    
    if (!user) {
      return NextResponse.json(
        { success: false, message: 'Invalid employee ID or password' },
        { status: 401 }
      );
    }

    // Generate JWT token
    const payload: JWTPayload = {
      userId: user.id,
      employee_id: user.employee_id,
      designation_id: user.designation.id,
    };

    const token = AuthService.generateToken(payload);

    // Create response with user data
    const response = NextResponse.json({
      success: true,
      user,
      message: 'Login successful',
    });

    // Set HTTP-only cookie
    response.cookies.set('ooak_auth_token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60, // 7 days
      path: '/',
    });

    return response;
  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error' },
      { status: 500 }
    );
  }
} 