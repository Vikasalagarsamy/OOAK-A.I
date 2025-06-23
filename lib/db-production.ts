const { Pool } = require('pg');

// Production database configuration
const PRODUCTION_CONFIG = {
  host: 'dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com',
  database: 'ooak_ai_db',
  user: 'ooak_admin',
  password: 'mSglqEawN72hkoEj8tSNF5qv9vJr3U6k',
  port: 5432,
  ssl: { rejectUnauthorized: false }
};

const PRODUCTION_DATABASE_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';

// Create a production pool with proper error handling
const productionPool = new Pool({
  connectionString: PRODUCTION_DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

// Helper function to get a production client
async function getProductionClient() {
  try {
    const client = await productionPool.connect();
    return client;
  } catch (error) {
    console.error('Failed to connect to production database:', error);
    throw error;
  }
}

// Helper function to run migrations on production
async function runProductionMigration(migrationSQL, description) {
  const client = await getProductionClient();
  try {
    await client.query('BEGIN');
    console.log(`🚀 Running migration: ${description}`);
    
    await client.query(migrationSQL);
    
    await client.query('COMMIT');
    console.log('✅ Migration completed successfully');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    client.release();
  }
}

// Helper function to verify production schema
async function verifyProductionSchema() {
  const client = await getProductionClient();
  try {
    const tables = await client.query(`
      SELECT table_name, column_name, data_type 
      FROM information_schema.columns 
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position;
    `);
    return tables.rows;
  } finally {
    client.release();
  }
}

module.exports = {
  PRODUCTION_CONFIG,
  PRODUCTION_DATABASE_URL,
  productionPool,
  getProductionClient,
  runProductionMigration,
  verifyProductionSchema
};

// Enhanced query function with retry logic for production
async function query<T = any>(
  text: string, 
  params?: any[]
): Promise<{ data: T[] | null; success: boolean; error?: string }> {
  const pool = productionPool;
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
async function transaction<T>(
  callback: (queryFn: typeof query) => Promise<T>
): Promise<{ data: T | null; success: boolean; error?: string }> {
  const pool = productionPool;
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
async function healthCheck(): Promise<{ healthy: boolean; latency: number; error?: string }> {
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
const getDbPool = productionPool;

// Export for environment-specific usage
const isProduction = process.env.NODE_ENV === 'production'; 