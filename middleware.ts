import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// Add matcher for all routes that require authentication
export const config = {
  matcher: [
    '/api/auth/me',
    '/api/auth/menu-permissions',
    '/api/admin/:path*',
    '/api/dashboard/:path*',
    '/api/leads/sources',
    '/api/leads/:path*',
    '/(authenticated)/:path*',
  ],
};

export async function middleware(request: NextRequest) {
  // Public API routes
  const publicApiRoutes = [
    '/api/auth/login',
    '/api/auth/logout',
    '/api/companies',
    '/api/branches',
    '/api/leads/sources',
  ];

  // Check if the current route is a public API route
  if (publicApiRoutes.includes(request.nextUrl.pathname)) {
    return NextResponse.next();
  }

  // Basic auth check
  const token = request.cookies.get('ooak_auth_token')?.value;

  if (!token) {
    // Handle API routes
    if (request.nextUrl.pathname.startsWith('/api/')) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Redirect to login for non-API routes
    const redirectUrl = new URL('/login', request.url);
    redirectUrl.searchParams.set('from', request.nextUrl.pathname);
    return NextResponse.redirect(redirectUrl);
  }

  return NextResponse.next();
} 