const { runProductionMigration, verifyProductionSchema, getProductionClient } = require('../lib/db-production');
const fs = require('fs/promises');
const path = require('path');

async function runSchemaMigration() {
  try {
    // 1. Read the schema file
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // 2. Extract schema-related SQL (everything up to the first INSERT)
    const lines = schemaSQL.split('\n');
    let schemaLines = [];
    for (const line of lines) {
      if (line.trim().startsWith('INSERT INTO')) {
        break;
      }
      schemaLines.push(line);
    }
    const schemaSQLCleaned = schemaLines.join('\n');

    // 3. Clean up duplicate designations and ensure unique constraint
    console.log('🧹 Checking designations table...');
    const client = await getProductionClient();
    try {
      // Start a transaction
      await client.query('BEGIN');

      // Check if unique constraint exists
      const constraintExists = await client.query(`
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'designations_name_key';
      `);

      if (constraintExists.rows.length === 0) {
        console.log('🔍 No unique constraint found, checking for duplicates...');
        // Find duplicates
        const duplicatesResult = await client.query(`
          SELECT name, COUNT(*), MIN(id) as keep_id
          FROM designations
          GROUP BY name
          HAVING COUNT(*) > 1;
        `);

        // Delete duplicates if any found
        for (const row of duplicatesResult.rows) {
          console.log(`   Found duplicate designation: ${row.name}`);
          await client.query(`
            DELETE FROM designations 
            WHERE name = $1 AND id != $2;
          `, [row.name, row.keep_id]);
        }

        // Add unique constraint
        console.log('🔒 Adding unique constraint to designations table...');
        await client.query(`
          ALTER TABLE designations 
          ADD CONSTRAINT designations_name_key UNIQUE (name);
        `);
      } else {
        console.log('✅ Unique constraint already exists on designations table');
      }

      await client.query('COMMIT');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }

    // 4. Run the schema migration
    await runProductionMigration(schemaSQLCleaned, 'Schema migration only');

    // 5. Verify the schema
    console.log('\n🔍 Verifying schema...');
    const schema = await verifyProductionSchema();
    
    console.log('\n📋 Current Production Schema:');
    console.log('=========================');
    
    let currentTable = '';
    schema.forEach(row => {
      if (row.table_name !== currentTable) {
        currentTable = row.table_name;
        console.log(`\n📦 ${currentTable}`);
        console.log('-------------------------');
      }
      console.log(`   ${row.column_name}: ${row.data_type}`);
    });

  } catch (error) {
    console.error('❌ Schema migration failed:', error);
    process.exit(1);
  }
}

// Run the schema migration
console.log('🚀 Starting Cursor Production Schema Migration...\n');
runSchemaMigration().catch(console.error); 