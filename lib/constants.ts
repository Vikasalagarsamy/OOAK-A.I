import { ENV, getDomainConfig } from './env-config'

// Authentication Constants
export const AUTH_COOKIE_NAME = 'ooak_auth_token'

// Get domain configuration based on environment
const domainConfig = getDomainConfig()

export const AUTH_COOKIE_OPTIONS = {
  httpOnly: true,
  secure: domainConfig.secure,
  sameSite: 'lax' as const,
  path: '/',
  domain: domainConfig.domain,
  // 7 days in seconds
  maxAge: 7 * 24 * 60 * 60
}

// API Routes
export const API_ROUTES = {
  LOGIN: '/api/auth/login',
  LOGOUT: '/api/auth/logout',
  ME: '/api/auth/me'
} as const

// Public Routes that don't require authentication
export const PUBLIC_ROUTES = [
  '/login',
  '/api/auth/login',
  '/api/health',
  '/favicon.ico'
] as const

// Authentication Error Messages
export const AUTH_ERRORS = {
  INVALID_CREDENTIALS: 'Invalid employee ID or password',
  SESSION_EXPIRED: 'Your session has expired. Please login again.',
  UNAUTHORIZED: 'You are not authorized to access this resource',
  SERVER_ERROR: 'An error occurred. Please try again later.'
} as const

// Validation Constants
export const VALIDATION = {
  PASSWORD_MIN_LENGTH: 8,
  PASSWORD_MAX_LENGTH: 100,
  EMPLOYEE_ID_PATTERN: /^EMP-\d{2}-\d{4}$/
} as const 