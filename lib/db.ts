import { Pool } from 'pg';

// Auto-detect environment and use appropriate database configuration
const isDevelopment = process.env.NODE_ENV === 'development';
const isProduction = process.env.NODE_ENV === 'production';

let connectionConfig;

if (isDevelopment) {
  // Local development database
  connectionConfig = {
    connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak_ai_dev',
    ssl: false,
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
  };
} else if (isProduction) {
  // Production database (Render)
  connectionConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    },
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  };
} else {
  // Staging or other environments
  connectionConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    },
    max: 15,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 7000,
  };
}

// Create connection pool
const pool = new Pool(connectionConfig);

// Connection event handlers
pool.on('connect', (client) => {
  if (isDevelopment) {
    console.log('🔗 Connected to local development database');
  }
});

pool.on('error', (err) => {
  console.error('❌ Database connection error:', err);
  process.exit(-1);
});

// Database query function with error handling and retry logic
export async function query(text: string, params?: any[]): Promise<any> {
  const maxRetries = 3;
  let retries = 0;
  
  while (retries < maxRetries) {
    try {
      const start = Date.now();
      const result = await pool.query(text, params);
      const duration = Date.now() - start;
      
      if (isDevelopment && duration > 1000) {
        console.warn(`⚠️ Slow query (${duration}ms): ${text.substring(0, 100)}...`);
      }
      
      return result;
    } catch (error: any) {
      retries++;
      console.error(`❌ Database query error (attempt ${retries}/${maxRetries}):`, error.message);
      
      if (retries >= maxRetries) {
        throw error;
      }
      
      // Wait before retry (exponential backoff)
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, retries) * 1000));
    }
  }
}

// Get database connection for transactions
export async function getClient() {
  return await pool.connect();
}

// Health check function
export async function healthCheck(): Promise<boolean> {
  try {
    const result = await query('SELECT 1 as health');
    return result.rows[0].health === 1;
  } catch (error) {
    console.error('❌ Database health check failed:', error);
    return false;
  }
}

// Environment info
export const dbInfo = {
  environment: process.env.NODE_ENV || 'development',
  isDevelopment,
  isProduction,
  maxConnections: connectionConfig.max
};

export default pool;
