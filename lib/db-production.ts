import { Pool, PoolClient, QueryResult } from 'pg';

// Production database configuration with fallbacks
const getDbConfig = () => {
  // Render.com provides DATABASE_URL automatically
  if (process.env.DATABASE_URL) {
    return {
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 10000,
    };
  }
  
  // Fallback to individual environment variables
  return {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '5432'),
    database: process.env.POSTGRES_DB || 'ooak_ai_db',
    user: process.env.POSTGRES_USER || 'postgres',
    password: process.env.POSTGRES_PASSWORD || '',
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  };
};

// Create connection pool singleton
let pool: Pool | null = null;

function getPool(): Pool {
  if (!pool) {
    const config = getDbConfig();
    pool = new Pool(config);
    
    pool.on('connect', () => {
      console.log('🔗 Connected to OOAK.AI Production Database');
    });
    
    pool.on('error', (err) => {
      console.error('❌ Production database pool error:', err);
    });
    
    // Graceful shutdown
    process.on('SIGINT', async () => {
      console.log('🔒 Closing database pool...');
      await pool?.end();
      process.exit(0);
    });
    
    process.on('SIGTERM', async () => {
      console.log('🔒 Closing database pool...');
      await pool?.end();
      process.exit(0);
    });
  }
  
  return pool;
}

// Enhanced query function with retry logic for production
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

// Production-ready transaction function
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

// Health check for production monitoring
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

// Export connection pool for advanced usage
export const getDbPool = getPool;

// Export for environment-specific usage
export const isProduction = process.env.NODE_ENV === 'production'; 