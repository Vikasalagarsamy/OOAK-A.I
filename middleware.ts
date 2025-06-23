import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { AUTH_COOKIE_NAME, PUBLIC_ROUTES } from '@/lib/constants';
import { jwtVerify } from 'jose';

// Configure the middleware to run on all routes except static files
export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * 1. _next/static (static files)
     * 2. _next/image (image optimization files)
     * 3. favicon.ico (favicon file)
     * 4. api routes (they handle their own auth)
     */
    '/((?!_next/static|_next/image|favicon.ico|api).*)',
  ],
};

// Create TextEncoder instance for JWT secret
const JWT_SECRET = new TextEncoder().encode(process.env.JWT_SECRET || 'your-secret-key');

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  console.log('Middleware - Path:', pathname);

  // Always allow public routes
  if (PUBLIC_ROUTES.includes(pathname as typeof PUBLIC_ROUTES[number])) {
    console.log('Middleware - Public route, allowing access');
    return NextResponse.next();
  }

  // Check for static files
  if (
    pathname.startsWith('/_next') || // Static files
    pathname.includes('.') // Files with extensions (e.g. favicon.ico)
  ) {
    return NextResponse.next();
  }

  // Get the token from the cookies
  const token = request.cookies.get(AUTH_COOKIE_NAME);

  // If there's no token and we're not on a public route, redirect to login
  if (!token) {
    console.log('Middleware - No auth token found, redirecting to login');
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('redirect', pathname);
    return NextResponse.redirect(loginUrl);
  }

  try {
    // Verify token using jose
    const { payload } = await jwtVerify(token.value, JWT_SECRET);
    console.log('Middleware - Token payload:', payload);
    
    // Add user info to headers for downstream use
    const response = NextResponse.next();
    response.headers.set('x-user-id', payload.userId?.toString() || '');
    response.headers.set('x-employee-id', payload.employee_id?.toString() || '');
    response.headers.set('x-designation-id', payload.designation_id?.toString() || '');
    
    return response;
  } catch (error) {
    console.error('Middleware - Token verification failed:', error);
    // If token is invalid, clear it and redirect to login
    const response = NextResponse.redirect(new URL('/login', request.url));
    response.cookies.delete(AUTH_COOKIE_NAME);
    return response;
  }
} 