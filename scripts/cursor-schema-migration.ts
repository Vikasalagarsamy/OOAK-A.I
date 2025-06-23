import { runProductionMigration, verifyProductionSchema } from '../lib/db-production';
import { promises as fs } from 'fs';
import path from 'path';

async function runSchemaMigration() {
  try {
    // 1. Read the schema file
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // 2. Extract only schema-related queries (CREATE TABLE, ALTER TABLE, etc.)
    const schemaQueries = schemaSQL
      .split('\n')
      .filter(line => {
        const trimmedLine = line.trim().toUpperCase();
        return trimmedLine.startsWith('CREATE TABLE') ||
               trimmedLine.startsWith('ALTER TABLE') ||
               trimmedLine.startsWith('CREATE INDEX') ||
               trimmedLine.startsWith('CREATE UNIQUE INDEX');
      })
      .join('\n');

    // 3. Run the schema migration
    await runProductionMigration(schemaQueries, 'Schema migration only');

    // 4. Verify the schema
    console.log('\n🔍 Verifying schema...');
    const schema = await verifyProductionSchema();
    
    console.log('\n📊 Schema Structure:');
    console.log('================');
    
    let currentTable = '';
    schema.forEach(column => {
      if (column.table_name !== currentTable) {
        currentTable = column.table_name;
        console.log(`\n📦 ${currentTable}:`);
      }
      console.log(`   ${column.column_name.padEnd(30)} ${column.data_type}`);
    });

  } catch (error) {
    console.error('❌ Schema migration failed:', error);
    process.exit(1);
  }
}

// Run the schema migration
console.log('🚀 Starting Cursor Production Schema Migration...\n');
runSchemaMigration().catch(console.error); 