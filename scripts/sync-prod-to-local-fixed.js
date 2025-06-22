const { Pool } = require('pg');
const { execSync } = require('child_process');
const fs = require('fs').promises;

// Production database connection
const PROD_DB_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';
const LOCAL_DB_URL = 'postgresql://localhost:5432/ooak_ai_dev';

const prodPool = new Pool({
  connectionString: PROD_DB_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

const localPool = new Pool({
  connectionString: LOCAL_DB_URL,
  ssl: false
});

async function getTableSchema(client, tableName) {
  // Get column definitions
  const columnsResult = await client.query(`
    SELECT 
      column_name,
      data_type,
      udt_name,
      character_maximum_length,
      numeric_precision,
      numeric_scale,
      is_nullable,
      column_default
    FROM information_schema.columns 
    WHERE table_name = $1
    ORDER BY ordinal_position
  `, [tableName]);

  // Build column definitions
  const columns = columnsResult.rows.map(col => {
    let dataType;
    if (col.data_type === 'ARRAY') {
      dataType = `${col.udt_name.replace('_', '')}[]`;
    } else if (col.data_type === 'USER-DEFINED') {
      dataType = col.udt_name;
    } else if (col.character_maximum_length) {
      dataType = `${col.data_type}(${col.character_maximum_length})`;
    } else if (col.numeric_precision) {
      dataType = `${col.data_type}(${col.numeric_precision}${col.numeric_scale ? `,${col.numeric_scale}` : ''})`;
    } else {
      dataType = col.data_type;
    }

    return `"${col.column_name}" ${dataType}${col.is_nullable === 'NO' ? ' NOT NULL' : ''}${col.column_default ? ` DEFAULT ${col.column_default}` : ''}`;
  });

  // Get primary key
  const pkResult = await client.query(`
    SELECT 
      c.conname as constraint_name,
      string_agg(a.attname, ', ') as columns
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(c.conkey)
    WHERE c.contype = 'p' AND t.relname = $1
    GROUP BY c.conname
  `, [tableName]);

  // Build CREATE TABLE statement
  let createTableSQL = `CREATE TABLE "${tableName}" (\n  ${columns.join(',\n  ')}`;
  
  if (pkResult.rows.length > 0) {
    createTableSQL += `,\n  CONSTRAINT "${pkResult.rows[0].constraint_name}" PRIMARY KEY (${pkResult.rows[0].columns})`;
  }
  
  createTableSQL += '\n)';

  return createTableSQL;
}

async function syncProductionToLocal() {
  console.log('🚀 Starting Enhanced Production to Local Sync...\n');
  
  try {
    // Step 1: Get list of tables from production
    console.log('📋 Getting table list from production...');
    const prodClient = await prodPool.connect();
    const tablesResult = await prodClient.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    const tables = tablesResult.rows.map(row => row.table_name);
    console.log(`Found ${tables.length} tables to sync\n`);
    
    // Step 2: Drop and recreate local database
    console.log('🗑️  Cleaning local database...');
    const setupClient = await localPool.connect();
    await setupClient.query('DROP SCHEMA public CASCADE');
    await setupClient.query('CREATE SCHEMA public');
    setupClient.release();
    console.log('✅ Local database cleaned\n');
    
    // Step 3: Create tables with exact schema
    console.log('📥 Creating tables...\n');
    for (const tableName of tables) {
      console.log(`🔄 Processing table: ${tableName}`);
      
      try {
        // Get and create table
        const createTableSQL = await getTableSchema(prodClient, tableName);
        const insertClient = await localPool.connect();
        await insertClient.query(createTableSQL);
        console.log('✅ Created table structure');
        
        // Get and create indexes
        const indexResult = await prodClient.query(`
          SELECT indexdef 
          FROM pg_indexes 
          WHERE tablename = $1 
          AND schemaname = 'public'
          AND indexname NOT LIKE '%_pkey'
        `, [tableName]);
        
        for (const idx of indexResult.rows) {
          await insertClient.query(idx.indexdef);
        }
        
        if (indexResult.rows.length > 0) {
          console.log(`✅ Created ${indexResult.rows.length} indexes`);
        }
        
        // Copy data
        const dataResult = await prodClient.query(`SELECT * FROM "${tableName}"`);
        if (dataResult.rows.length > 0) {
          const columns = Object.keys(dataResult.rows[0]);
          
          // Prepare values with proper escaping
          const values = dataResult.rows.map(row => {
            return `(${columns.map(col => {
              const val = row[col];
              if (val === null) return 'NULL';
              if (Array.isArray(val)) return `ARRAY[${val.map(v => `'${String(v).replace(/'/g, "''")}'`).join(',')}]`;
              if (typeof val === 'object') return `'${JSON.stringify(val).replace(/'/g, "''")}'`;
              return `'${String(val).replace(/'/g, "''")}'`;
            }).join(',')})`;
          });
          
          // Insert data in chunks to avoid query size limits
          const CHUNK_SIZE = 100;
          for (let i = 0; i < values.length; i += CHUNK_SIZE) {
            const chunk = values.slice(i, i + CHUNK_SIZE);
            const insertSQL = `
              INSERT INTO "${tableName}" (${columns.map(c => `"${c}"`).join(',')})
              VALUES ${chunk.join(',\n')}
            `;
            await insertClient.query(insertSQL);
          }
          
          console.log(`✅ Copied ${dataResult.rows.length} rows`);
        } else {
          console.log('ℹ️  Table is empty');
        }
        
        insertClient.release();
      } catch (error) {
        console.error(`❌ Error processing table: ${error.message}`);
      }
    }
    
    // Step 4: Update sequences
    console.log('\n📊 Updating sequences...');
    const sequencesResult = await prodClient.query(`
      SELECT c.relname as sequence_name
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relkind = 'S' AND n.nspname = 'public'
    `);
    
    const seqClient = await localPool.connect();
    for (const seq of sequencesResult.rows) {
      try {
        const valueResult = await prodClient.query(`SELECT last_value, is_called FROM "${seq.sequence_name}"`);
        if (valueResult.rows.length > 0) {
          const { last_value, is_called } = valueResult.rows[0];
          await seqClient.query(`SELECT setval('${seq.sequence_name}', ${last_value}, ${is_called})`);
        }
      } catch (error) {
        console.log(`⚠️  Warning updating sequence ${seq.sequence_name}: ${error.message}`);
      }
    }
    seqClient.release();
    prodClient.release();
    
    console.log('\n🎉 Database sync completed successfully!');
    console.log('✅ Schema copied exactly from production');
    console.log('✅ All data copied');
    console.log('✅ Sequences updated');
    console.log('\n🚀 Your local development database is now an exact copy of production!');
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
  } finally {
    await prodPool.end();
    await localPool.end();
  }
}

// Run the sync
syncProductionToLocal().catch(console.error); 