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