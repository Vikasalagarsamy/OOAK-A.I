import { Pool, PoolClient, QueryResult } from 'pg';

// Database configuration
const dbConfig = {
  host: process.env.POSTGRES_HOST || 'localhost',
  port: parseInt(process.env.POSTGRES_PORT || '5432'),
  database: process.env.POSTGRES_DB || 'ooak_ai_db',
  user: process.env.POSTGRES_USER || 'vikasalagarsamy',
  password: process.env.POSTGRES_PASSWORD || '',
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 2000, // Return error after 2 seconds if connection could not be established
};

// Create connection pool singleton
let pool: Pool | null = null;

function getPool(): Pool {
  if (!pool) {
    pool = new Pool(dbConfig);
    
    pool.on('connect', () => {
      console.log('🔗 Connected to OOAK.AI PostgreSQL database');
    });
    
    pool.on('error', (err) => {
      console.error('❌ PostgreSQL pool error:', err);
    });
  }
  
  return pool;
}

// Query function with automatic connection management
export async function query<T = any>(
  text: string, 
  params?: any[]
): Promise<{ data: T[] | null; success: boolean; error?: string }> {
  const pool = getPool();
  let client: PoolClient | null = null;
  
  try {
    client = await pool.connect();
    const result: QueryResult<T> = await client.query(text, params);
    
    return {
      data: result.rows,
      success: true
    };
  } catch (error) {
    console.error('❌ Database query error:', error);
    return {
      data: null,
      success: false,
      error: error instanceof Error ? error.message : 'Unknown database error'
    };
  } finally {
    if (client) {
      client.release();
    }
  }
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
      const result: QueryResult<U> = await client.query(text, params);
      return {
        data: result.rows,
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

// Test connection function
export async function testConnection(): Promise<boolean> {
  try {
    const result = await query('SELECT NOW() as current_time');
    if (result.success && result.data) {
      console.log('✅ Database connection test successful:', result.data[0]);
      return true;
    }
    return false;
  } catch (error) {
    console.error('❌ Database connection test failed:', error);
    return false;
  }
}

// Graceful shutdown
export async function closePool(): Promise<void> {
  if (pool) {
    await pool.end();
    pool = null;
    console.log('🔒 Database pool closed');
  }
}

// Export pool for advanced usage
export const getDbPool = getPool; 