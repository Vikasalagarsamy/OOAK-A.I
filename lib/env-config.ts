// Environment configuration with type safety
export const ENV = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  DATABASE_URL: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak',
  RENDER_EXTERNAL_URL: process.env.RENDER_EXTERNAL_URL || 'http://localhost:3000',
  JWT_SECRET: process.env.JWT_SECRET || 'local-dev-secret',
  COOKIE_DOMAIN: process.env.COOKIE_DOMAIN || 'localhost',
  IS_PRODUCTION: process.env.NODE_ENV === 'production',
  IS_RENDER: !!process.env.RENDER,
} as const

// Validate required environment variables in production
export function validateEnv() {
  if (ENV.IS_PRODUCTION) {
    const required = ['DATABASE_URL', 'JWT_SECRET', 'RENDER_EXTERNAL_URL']
    const missing = required.filter(key => !process.env[key])
    
    if (missing.length > 0) {
      throw new Error(`Missing required environment variables: ${missing.join(', ')}`)
    }
  }
}

// Get the correct domain configuration based on environment
export function getDomainConfig() {
  if (ENV.IS_RENDER) {
    const renderUrl = new URL(ENV.RENDER_EXTERNAL_URL)
    return {
      domain: renderUrl.hostname,
      secure: true
    }
  }
  
  return {
    domain: ENV.COOKIE_DOMAIN,
    secure: ENV.IS_PRODUCTION
  }
} 