import { withAuth } from 'next-auth/middleware';
import { NextResponse } from 'next/server';

// Configure the middleware to run on all routes except static files
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
     */
    '/((?!_next/static|_next/image|favicon.ico|api|login|public).*)',
  ],
};

export default withAuth(
  function middleware(req) {
    // Add any custom middleware logic here if needed
    return NextResponse.next();
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