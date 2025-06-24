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
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

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
      // Check and handle designations table
      console.log('🧹 Checking designations table...');
      const constraintExists = await client.query(`
        SELECT 1 FROM pg_constraint WHERE conname = 'designations_name_key'
      `);

      if (constraintExists.rows.length === 0) {
        console.log('🔍 No unique constraint found, handling duplicates...');
        
        // Find and remove duplicates
        const duplicates = await client.query(`
          SELECT name, COUNT(*), MIN(id) as keep_id
          FROM designations
          GROUP BY name
          HAVING COUNT(*) > 1
        `);

        for (const row of duplicates.rows) {
          console.log(`   Removing duplicate: ${row.name}`);
          await client.query(
            'DELETE FROM designations WHERE name = $1 AND id != $2',
            [row.name, row.keep_id]
          );
        }

        // Add unique constraint
        console.log('🔒 Adding unique constraint...');
        await client.query(
          'ALTER TABLE designations ADD CONSTRAINT designations_name_key UNIQUE (name)'
        );
      } else {
        console.log('✅ Unique constraint exists');
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
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

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
      // Check and handle designations table
      console.log('🧹 Checking designations table...');
      const constraintExists = await client.query(`
        SELECT 1 FROM pg_constraint WHERE conname = 'designations_name_key'
      `);

      if (constraintExists.rows.length === 0) {
        console.log('🔍 No unique constraint found, handling duplicates...');
        
        // Find and remove duplicates
        const duplicates = await client.query(`
          SELECT name, COUNT(*), MIN(id) as keep_id
          FROM designations
          GROUP BY name
          HAVING COUNT(*) > 1
        `);

        for (const row of duplicates.rows) {
          console.log(`   Removing duplicate: ${row.name}`);
          await client.query(
            'DELETE FROM designations WHERE name = $1 AND id != $2',
            [row.name, row.keep_id]
          );
        }

        // Add unique constraint
        console.log('🔒 Adding unique constraint...');
        await client.query(
          'ALTER TABLE designations ADD CONSTRAINT designations_name_key UNIQUE (name)'
        );
      } else {
        console.log('✅ Unique constraint exists');
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