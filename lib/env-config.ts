// Environment configuration with type safety
export const ENV = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  DATABASE_URL: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak',
  RENDER_EXTERNAL_URL: process.env.RENDER_EXTERNAL_URL || 'http://localhost:3000',
  JWT_SECRET: process.env.JWT_SECRET || 'local-dev-secret',
  COOKIE_DOMAIN: process.env.COOKIE_DOMAIN || 'localhost',
  PORT: parseInt(process.env.PORT || '3000', 10),
  IS_PRODUCTION: process.env.NODE_ENV === 'production',
  IS_RENDER: !!process.env.RENDER,
  DATABASE_CONNECTION_TIMEOUT: parseInt(process.env.DATABASE_CONNECTION_TIMEOUT || '30000', 10),
  DATABASE_STATEMENT_TIMEOUT: parseInt(process.env.DATABASE_STATEMENT_TIMEOUT || '60000', 10),
} as const

// Validate required environment variables in production
export function validateEnv() {
  if (ENV.IS_PRODUCTION) {
    const required = [
      'DATABASE_URL',
      'JWT_SECRET',
      'RENDER_EXTERNAL_URL',
      'NEXTAUTH_SECRET',
      'NEXTAUTH_URL'
    ]
    const missing = required.filter(key => !process.env[key])
    
    if (missing.length > 0) {
      throw new Error(`Missing required environment variables: ${missing.join(', ')}`)
    }

    // Validate database URL format
    try {
      const dbUrl = new URL(ENV.DATABASE_URL)
      if (!dbUrl.protocol || !dbUrl.host || !dbUrl.pathname) {
        throw new Error('Invalid DATABASE_URL format')
      }
    } catch (error: unknown) {
      throw new Error(`Invalid DATABASE_URL: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
}

// Get the correct domain configuration based on environment
export function getDomainConfig() {
  if (ENV.IS_RENDER) {
    try {
      const renderUrl = new URL(ENV.RENDER_EXTERNAL_URL)
      return {
        domain: renderUrl.hostname,
        secure: true,
        sameSite: 'lax' as const,
        path: '/'
      }
    } catch (error: unknown) {
      console.error('Invalid RENDER_EXTERNAL_URL:', error)
      throw new Error(`Invalid RENDER_EXTERNAL_URL configuration: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
  
  return {
    domain: ENV.COOKIE_DOMAIN,
    secure: ENV.IS_PRODUCTION,
    sameSite: 'lax' as const,
    path: '/'
  }
} 