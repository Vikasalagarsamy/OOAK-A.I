const { runProductionMigration, verifyProductionSchema } = require('../lib/db-production');
const fs = require('fs/promises');
const path = require('path');

async function runSchemaMigration() {
  try {
    // 1. Read the schema file
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // 2. Extract only schema-related SQL (no data manipulation)
    const schemaSQLCleaned = schemaSQL
      .split('\n')
      .filter(line => !line.trim().startsWith('INSERT INTO'))
      .join('\n');

    // 3. Run the schema migration
    await runProductionMigration(schemaSQLCleaned, 'Schema migration only');

    // 4. Verify the schema
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