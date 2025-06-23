import { NextRequest, NextResponse } from 'next/server';
import { AuthService } from '@/lib/auth';
import { AUTH_COOKIE_NAME } from '@/lib/constants';

// Specify Node.js runtime
export const runtime = 'nodejs'

export async function GET(request: NextRequest) {
  try {
    // Get token from cookie
    const token = request.cookies.get(AUTH_COOKIE_NAME)?.value;
    
    if (!token) {
      return NextResponse.json(
        { success: false, message: 'Not authenticated' },
        { status: 401 }
      );
    }

    // Verify token first
    const payload = await AuthService.verifyToken(token);
    if (!payload) {
      return NextResponse.json(
        { success: false, message: 'Invalid or expired token' },
        { status: 401 }
      );
    }

    // Get current user
    const user = await AuthService.getCurrentUser(token);
    
    if (!user) {
      return NextResponse.json(
        { success: false, message: 'User not found' },
        { status: 401 }
      );
    }

    return NextResponse.json({
      success: true,
      user,
    });
  } catch (error) {
    console.error('Get current user error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error' },
      { status: 500 }
    );
  }
} 