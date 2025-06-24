const dotenv = require('dotenv');
dotenv.config({ path: '.env.local' });

const config = {
  development: {
    database: {
      host: process.env.POSTGRES_HOST || 'localhost',
      port: parseInt(process.env.POSTGRES_PORT || '5432'),
      database: process.env.POSTGRES_DB || 'ooak_ai_dev',
      user: process.env.POSTGRES_USER || 'vikasalagarsamy',
      password: process.env.POSTGRES_PASSWORD,
      ssl: false
    }
  },
  production: {
    database: {
      connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
      ssl: {
        rejectUnauthorized: false
      }
    }
  }
};

// Validate required environment variables
const requiredVars = [
  'POSTGRES_HOST',
  'POSTGRES_PORT',
  'POSTGRES_DB',
  'POSTGRES_USER'
];

for (const varName of requiredVars) {
  if (!process.env[varName]) {
    throw new Error(`Missing required environment variable: ${varName}`);
  }
}

// Convert DATABASE_URL format for development if needed
if (!config.development.database.password && process.env.DATABASE_URL) {
  try {
    const url = new URL(process.env.DATABASE_URL);
    config.development.database.password = url.password;
  } catch (error) {
    console.warn('Failed to parse DATABASE_URL for password:', error.message);
  }
}

module.exports = config; 
 