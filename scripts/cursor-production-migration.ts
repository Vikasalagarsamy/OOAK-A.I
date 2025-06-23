import { runProductionMigration, verifyProductionSchema } from '../lib/db-production';
import fs from 'fs/promises';
import path from 'path';

async function runMigration() {
  try {
    // 1. Read the schema file
    console.log('📚 Reading schema file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // 2. Run the migration
    await runProductionMigration(schemaSQL, 'Full schema migration');

    // 3. Verify the schema
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
    console.error('❌ Migration failed:', error);
    process.exit(1);
  }
}

// Run the migration
console.log('🚀 Starting Cursor Production Migration...\n');
runMigration().catch(console.error); 