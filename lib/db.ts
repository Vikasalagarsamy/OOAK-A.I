import { Pool, PoolClient, QueryResult } from 'pg';
import { types } from 'pg';

// Configure pg to return dates as strings in YYYY-MM-DD format
types.setTypeParser(1082, (value: string) => value); // Type 1082 is DATE

// Define PostgreSQL error type
interface PostgresError extends Error {
  code?: string;
  detail?: string;
  hint?: string;
  where?: string;
}

// Define config types
interface ProductionConfig {
  connectionString: string;
  ssl: { rejectUnauthorized: boolean };
  max: number;
  idleTimeoutMillis: number;
  connectionTimeoutMillis: number;
}

interface DevelopmentConfig {
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
  ssl: { rejectUnauthorized: boolean } | boolean;
  max: number;
  idleTimeoutMillis: number;
  connectionTimeoutMillis: number;
}

type DbConfig = ProductionConfig | DevelopmentConfig;

// Standardized database configuration
const getDbConfig = (): DbConfig => {
  // Use DATABASE_URL in production only
  if (process.env.NODE_ENV === 'production' && process.env.DATABASE_URL) {
    console.log('📊 Using production database configuration');
    return {
      connectionString: process.env.DATABASE_URL,
      ssl: { rejectUnauthorized: false },
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 10000,
    };
  }
  
  // Use local config for development
  const config: DevelopmentConfig = {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '5432'),
    database: process.env.POSTGRES_DB || 'ooak_ai_dev',
    user: process.env.POSTGRES_USER || 'vikasalagarsamy',
    password: process.env.POSTGRES_PASSWORD || '',
    ssl: process.env.POSTGRES_SSL === 'true' ? { rejectUnauthorized: false } : false,
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  };

  // Log the configuration (without password)
  console.log('📊 Database Configuration:', {
    ...config,
    password: config.password ? '****' : '',
  });

  return config;
};

// Create connection pool singleton
let pool: Pool | null = null;

function getPool(): Pool {
  if (!pool) {
    const config = getDbConfig();
    pool = new Pool(config);
    
    pool.on('error', (err: Error) => {
      console.error('Unexpected error on idle client', err);
      process.exit(-1);
    });

    // Test the connection
    pool.query('SELECT NOW()', (err, res) => {
      if (err) {
        console.error('❌ Database connection test failed:', err);
      } else {
        console.log('✅ Database connection test successful');
      }
    });
  }
  
  return pool;
}

// Standardized query function with retry logic
export async function query<T = any>(
  text: string, 
  params?: any[]
): Promise<{ data: T[] | null; success: boolean; error?: string }> {
  const pool = getPool();
  let client: PoolClient | null = null;
  let retries = 3;
  
  while (retries > 0) {
    try {
      client = await pool.connect();
      const result = await client.query(text, params);
      
      return {
        data: result.rows as T[],
        success: true
      };
    } catch (error) {
      console.error(`❌ Database query error (${retries} retries left):`, error);
      retries--;
      
      if (retries === 0) {
        return {
          data: null,
          success: false,
          error: error instanceof Error ? error.message : 'Unknown database error'
        };
      }
      
      // Wait before retry
      await new Promise(resolve => setTimeout(resolve, 1000));
    } finally {
      if (client) {
        client.release();
      }
    }
  }
  
  return {
    data: null,
    success: false,
    error: 'Maximum retries exceeded'
  };
}

// Transaction function
export async function transaction<T>(
  callback: (queryFn: typeof query) => Promise<T>
): Promise<{ data: T | null; success: boolean; error?: string }> {
  const pool = getPool();
  let client: PoolClient | null = null;
  
  try {
    client = await pool.connect();
    await client.query('BEGIN');
    
    // Create a query function that uses this client
    const transactionQuery = async <U = any>(text: string, params?: any[]) => {
      if (!client) throw new Error('Transaction client not available');
      const result = await client.query(text, params);
      return {
        data: result.rows as U[],
        success: true
      };
    };
    
    const result = await callback(transactionQuery);
    await client.query('COMMIT');
    
    return {
      data: result,
      success: true
    };
  } catch (error) {
    if (client) {
      await client.query('ROLLBACK');
    }
    console.error('❌ Database transaction error:', error);
    return {
      data: null,
      success: false,
      error: error instanceof Error ? error.message : 'Unknown transaction error'
    };
  } finally {
    if (client) {
      client.release();
    }
  }
}

// Health check function
export async function healthCheck(): Promise<{ healthy: boolean; latency: number; error?: string }> {
  const startTime = Date.now();
  
  try {
    const result = await query('SELECT 1 as health_check, NOW() as server_time');
    const latency = Date.now() - startTime;
    
    if (result.success && result.data) {
      return {
        healthy: true,
        latency,
      };
    }
    
    return {
      healthy: false,
      latency,
      error: result.error || 'Unknown health check error'
    };
  } catch (error) {
    const latency = Date.now() - startTime;
    return {
      healthy: false,
      latency,
      error: error instanceof Error ? error.message : 'Health check failed'
    };
  }
}

// Get database connection for advanced usage
export async function getClient() {
  const pool = getPool();
  return await pool.connect();
}

// Export connection pool for advanced usage
export const getDbPool = getPool;

// Environment info
export const dbInfo = {
  environment: process.env.NODE_ENV || 'development',
  isProduction: process.env.NODE_ENV === 'production',
  isDevelopment: process.env.NODE_ENV === 'development',
  maxConnections: getDbConfig().max
};

export default getPool();
