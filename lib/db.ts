import { Pool, PoolClient, QueryResult, QueryResultRow } from 'pg';
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

// Define SSL configuration type
type SSLConfig = boolean | { rejectUnauthorized: boolean };

// Define config types
interface ProductionConfig {
  connectionString: string;
  ssl: SSLConfig;
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
  ssl: SSLConfig;
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
      ssl: process.env.POSTGRES_SSL === 'true' ? { rejectUnauthorized: false } : false,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: parseInt(process.env.DATABASE_CONNECTION_TIMEOUT || '10000'),
    };
  }
  
  // Use local config for development
  const config: DevelopmentConfig = {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '5432'),
    database: process.env.POSTGRES_DB || 'ooak_ai_dev',
    user: process.env.POSTGRES_USER || 'vikasalagarsamy',
    password: process.env.POSTGRES_PASSWORD || '',
    ssl: process.env.POSTGRES_SSL === 'true',
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: parseInt(process.env.DATABASE_CONNECTION_TIMEOUT || '10000'),
  };

  // Log the configuration (without password)
  console.log('📊 Database Configuration:', {
    ...config,
    password: config.password ? '****' : '',
  });

  return config;
};

// Create a connection pool
const pool = new Pool(getDbConfig());

// Generic query function with retries
async function query<T extends QueryResultRow = any>(
  text: string,
  params?: any[],
  retries = 3
): Promise<{ success: boolean; data: T[] | null; error?: string }> {
  try {
    const result = await pool.query<T>(text, params);
    return { success: true, data: result.rows };
  } catch (error) {
    console.error(`❌ Database query error (${retries} retries left):`, error);
    if (retries > 0) {
      return query<T>(text, params, retries - 1);
    }
    return { success: false, data: null, error: (error as Error).message };
  }
}

// Transaction helper
async function transaction<T>(
  callback: (client: PoolClient) => Promise<T>
): Promise<{ success: boolean; data: T | null; error?: string }> {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const result = await callback(client);
    await client.query('COMMIT');
    return { success: true, data: result };
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Transaction error:', error);
    return { success: false, data: null, error: (error as Error).message };
  } finally {
    client.release();
  }
}

// Health check function
async function healthCheck(): Promise<boolean> {
  try {
    console.log('🔍 Health check requested...');
    const result = await query('SELECT NOW()');
    if (result.success) {
      console.log('✅ Database health check passed');
      return true;
    }
    console.log('❌ Health check failed');
    return false;
  } catch (error) {
    console.error('❌ Health check error:', error);
    return false;
  }
}

// Get the pool instance
function getPool(): Pool {
  return pool;
}

// Create a default export for the database
const db = {
  query,
  transaction,
  healthCheck,
  getPool
};

export default db;
export { query, transaction, healthCheck, getPool };
