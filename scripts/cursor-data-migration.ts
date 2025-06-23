import { runProductionMigration, getProductionClient } from '../lib/db-production';
import { promises as fs } from 'fs';
import path from 'path';

async function runDataMigration() {
  try {
    // 1. Read the schema file for data inserts
    console.log('📚 Reading data migration file...');
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    const schemaSQL = await fs.readFile(schemaPath, 'utf-8');

    // 2. Extract only data manipulation queries
    const dataSQL = schemaSQL
      .split('\n')
      .filter(line => line.trim().startsWith('INSERT INTO'))
      .join('\n');

    // 3. Run the data migration
    await runProductionMigration(dataSQL, 'Data migration only');

    // 4. Verify the data
    console.log('\n🔍 Verifying data...');
    const client = await getProductionClient();
    
    try {
      // Get table names
      const tablesResult = await client.query(`
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name;
      `);

      console.log('\n📊 Data Counts:');
      console.log('=============');

      // Count rows in each table
      for (const table of tablesResult.rows) {
        const countResult = await client.query(`
          SELECT COUNT(*) as count 
          FROM ${table.table_name}
        `);
        console.log(`📦 ${table.table_name.padEnd(30)}: ${countResult.rows[0].count} rows`);
      }

    } finally {
      client.release();
    }

  } catch (error) {
    console.error('❌ Data migration failed:', error);
    process.exit(1);
  }
}

// Run the data migration
console.log('🚀 Starting Cursor Production Data Migration...\n');
runDataMigration().catch(console.error); 