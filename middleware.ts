import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// Define public paths that don't require authentication
const PUBLIC_PATHS = ['/', '/login', '/api/auth/login'];

export function middleware(request: NextRequest) {
  // Get the pathname of the request
  const path = request.nextUrl.pathname;

  // Get the token from the cookies
  const authToken = request.cookies.get('ooak_auth_token');

  // If we're at a public path
  if (PUBLIC_PATHS.includes(path)) {
    // If user is authenticated, redirect to dashboard
    if (authToken) {
      return NextResponse.redirect(new URL('/dashboard', request.url));
    }
    // Otherwise, allow access to public path
    return NextResponse.next();
  }

  // For API routes that don't need auth
  if (path.startsWith('/api/auth/') && !path.includes('/me')) {
    return NextResponse.next();
  }

  // For all other paths, require authentication
  if (!authToken) {
    // If the request is for an API route, return 401
    if (path.startsWith('/api/')) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }
    // For page routes, redirect to login
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // User is authenticated, allow access
  return NextResponse.next();
}

// Configure which paths should be handled by this middleware
export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
}; 