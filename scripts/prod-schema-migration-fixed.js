const { Pool } = require('pg');
const fs = require('fs/promises');
const path = require('path');

// Production database configuration
const PRODUCTION_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create production pool
const pool = new Pool(PRODUCTION_CONFIG);

async function runSchemaMigration() {
  const client = await pool.connect();
  
  try {
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    let schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // Replace the owner with ooak_admin
    schemaSQL = schemaSQL.replace(/Owner: vikasalagarsamy/g, 'Owner: ooak_admin');
    schemaSQL = schemaSQL.replace(/OWNER TO vikasalagarsamy/g, 'OWNER TO ooak_admin');

    // Extract schema-only SQL (before first INSERT)
    const lines = schemaSQL.split('\n');
    const schemaLines = [];
    for (const line of lines) {
      if (line.trim().startsWith('INSERT INTO')) break;
      schemaLines.push(line);
    }
    const schemaSQLCleaned = schemaLines.join('\n');

    // Start transaction
    await client.query('BEGIN');

    try {
      // Get list of all tables
      console.log('📊 Getting list of existing tables...');
      const tablesResult = await client.query(`
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
      `);
      
      // Drop existing tables in reverse order to handle dependencies
      if (tablesResult.rows.length > 0) {
        console.log('🗑️  Dropping existing tables...');
        const tables = tablesResult.rows.map(row => row.tablename);
        await client.query(`DROP TABLE IF EXISTS ${tables.join(', ')} CASCADE`);
      }

      // Apply schema
      console.log('🚀 Applying schema changes...');
      await client.query(schemaSQLCleaned);

      // Verify schema
      console.log('🔍 Verifying schema...');
      const schema = await client.query(`
        SELECT table_name, column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position
      `);

      // Log schema
      console.log('\n📋 Production Schema:');
      let currentTable = '';
      schema.rows.forEach(row => {
        if (row.table_name !== currentTable) {
          currentTable = row.table_name;
          console.log(`\n📦 ${currentTable}`);
          console.log('-------------------------');
        }
        console.log(`   ${row.column_name}: ${row.data_type}`);
      });

      await client.query('COMMIT');
      console.log('\n✅ Schema migration completed successfully');
      
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    }

  } catch (error) {
    console.error('❌ Migration failed:', error);
    process.exit(1);
  } finally {
    await client.release();
    await pool.end();
  }
}

console.log('🚀 Starting Production Schema Migration...\n');
runSchemaMigration(); 
 
const fs = require('fs/promises');
const path = require('path');

// Production database configuration
const PRODUCTION_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create production pool
const pool = new Pool(PRODUCTION_CONFIG);

async function runSchemaMigration() {
  const client = await pool.connect();
  
  try {
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    let schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // Replace the owner with ooak_admin
    schemaSQL = schemaSQL.replace(/Owner: vikasalagarsamy/g, 'Owner: ooak_admin');
    schemaSQL = schemaSQL.replace(/OWNER TO vikasalagarsamy/g, 'OWNER TO ooak_admin');

    // Extract schema-only SQL (before first INSERT)
    const lines = schemaSQL.split('\n');
    const schemaLines = [];
    for (const line of lines) {
      if (line.trim().startsWith('INSERT INTO')) break;
      schemaLines.push(line);
    }
    const schemaSQLCleaned = schemaLines.join('\n');

    // Start transaction
    await client.query('BEGIN');

    try {
      // Get list of all tables
      console.log('📊 Getting list of existing tables...');
      const tablesResult = await client.query(`
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
      `);
      
      // Drop existing tables in reverse order to handle dependencies
      if (tablesResult.rows.length > 0) {
        console.log('🗑️  Dropping existing tables...');
        const tables = tablesResult.rows.map(row => row.tablename);
        await client.query(`DROP TABLE IF EXISTS ${tables.join(', ')} CASCADE`);
      }

      // Apply schema
      console.log('🚀 Applying schema changes...');
      await client.query(schemaSQLCleaned);

      // Verify schema
      console.log('🔍 Verifying schema...');
      const schema = await client.query(`
        SELECT table_name, column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position
      `);

      // Log schema
      console.log('\n📋 Production Schema:');
      let currentTable = '';
      schema.rows.forEach(row => {
        if (row.table_name !== currentTable) {
          currentTable = row.table_name;
          console.log(`\n📦 ${currentTable}`);
          console.log('-------------------------');
        }
        console.log(`   ${row.column_name}: ${row.data_type}`);
      });

      await client.query('COMMIT');
      console.log('\n✅ Schema migration completed successfully');
      
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    }

  } catch (error) {
    console.error('❌ Migration failed:', error);
    process.exit(1);
  } finally {
    await client.release();
    await pool.end();
  }
}

console.log('🚀 Starting Production Schema Migration...\n');
runSchemaMigration(); 