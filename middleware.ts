import { withAuth } from 'next-auth/middleware';
import { NextResponse } from 'next/server';

// Configure the middleware to run on all routes except static files and health check
export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * 1. _next/static (static files)
     * 2. _next/image (image optimization files)
     * 3. favicon.ico (favicon file)
     * 4. public files (public folder)
     * 5. api routes (they handle their own auth)
     * 6. login page
     * 7. health check endpoint
     */
    '/((?!_next/static|_next/image|favicon.ico|api/health|api/auth|login|public).*)',
  ],
};

export default withAuth(
  function middleware(req) {
    try {
      // Add CORS headers for API routes
      if (req.nextUrl.pathname.startsWith('/api/')) {
        const response = NextResponse.next();
        response.headers.set('Access-Control-Allow-Origin', '*');
        response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
        return response;
      }

      return NextResponse.next();
    } catch (error) {
      console.error('Middleware error:', error);
      return NextResponse.next();
    }
  },
  {
    callbacks: {
      authorized: ({ token }) => {
        // Only allow access if we have a valid token
        return !!token;
      },
    },
    pages: {
      signIn: '/login',
      error: '/login',
    },
  }
); 