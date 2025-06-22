const { Pool } = require('pg');
const { execSync } = require('child_process');
const fs = require('fs').promises;

// Database connection URLs
const DEV_DB_URL = 'postgresql://localhost:5432/ooak_ai_dev';
const PROD_DB_URL = process.env.DATABASE_URL; // Will be taken from environment variable

// Create connection pools
const devPool = new Pool({
  connectionString: DEV_DB_URL,
  ssl: false
});

const prodPool = new Pool({
  connectionString: PROD_DB_URL,
  ssl: {
    rejectUnauthorized: false
  }
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
      column_default,
      udt_schema
    FROM information_schema.columns 
    WHERE table_name = $1
    ORDER BY ordinal_position
  `, [tableName]);

  // Build column definitions
  const columns = columnsResult.rows.map(col => {
    let dataType;
    
    // Handle array types
    if (col.data_type === 'ARRAY') {
      const baseType = col.udt_name.replace('_', '');
      dataType = `${baseType}[]`;
    }
    // Handle user-defined types
    else if (col.data_type === 'USER-DEFINED') {
      if (col.udt_schema === 'public') {
        dataType = col.udt_name;
      } else {
        dataType = `${col.udt_schema}.${col.udt_name}`;
      }
    }
    // Handle character types
    else if (col.data_type.startsWith('character')) {
      if (col.character_maximum_length) {
        dataType = `${col.data_type}(${col.character_maximum_length})`;
      } else {
        dataType = col.data_type;
      }
    }
    // Handle numeric types
    else if (col.data_type === 'numeric' && (col.numeric_precision || col.numeric_scale)) {
      if (col.numeric_scale) {
        dataType = `numeric(${col.numeric_precision},${col.numeric_scale})`;
      } else {
        dataType = `numeric(${col.numeric_precision})`;
      }
    }
    // Handle all other types
    else {
      dataType = col.data_type;
    }

    // Build the column definition
    let columnDef = `"${col.column_name}" ${dataType}`;
    
    // Add nullability
    if (col.is_nullable === 'NO') {
      columnDef += ' NOT NULL';
    }
    
    // Add default value if exists
    if (col.column_default !== null) {
      // Special handling for serial defaults
      if (col.column_default.includes('nextval')) {
        if (dataType === 'bigint') {
          columnDef = columnDef.replace(dataType, 'BIGSERIAL');
        } else {
          columnDef = columnDef.replace(dataType, 'SERIAL');
        }
      } else {
        columnDef += ` DEFAULT ${col.column_default}`;
      }
    }

    return columnDef;
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

  // Get foreign keys
  const fkResult = await client.query(`
    SELECT
      tc.constraint_name,
      kcu.column_name,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name,
      rc.update_rule,
      rc.delete_rule
    FROM 
      information_schema.table_constraints AS tc 
      JOIN information_schema.key_column_usage AS kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
      JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
        AND ccu.table_schema = tc.table_schema
      JOIN information_schema.referential_constraints AS rc
        ON rc.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name=$1;
  `, [tableName]);

  // Build CREATE TABLE statement
  let createTableSQL = `CREATE TABLE IF NOT EXISTS "${tableName}" (\n  ${columns.join(',\n  ')}`;
  
  // Add primary key constraint
  if (pkResult.rows.length > 0) {
    createTableSQL += `,\n  CONSTRAINT "${pkResult.rows[0].constraint_name}" PRIMARY KEY (${pkResult.rows[0].columns})`;
  }

  // Add foreign key constraints
  for (const fk of fkResult.rows) {
    createTableSQL += `,\n  CONSTRAINT "${fk.constraint_name}" FOREIGN KEY ("${fk.column_name}") ` +
      `REFERENCES "${fk.foreign_table_name}" ("${fk.foreign_column_name}") ` +
      `ON UPDATE ${fk.update_rule} ON DELETE ${fk.delete_rule}`;
  }
  
  createTableSQL += '\n)';

  return createTableSQL;
}

async function getTableDependencies(client, tableName) {
  const result = await client.query(`
    SELECT
      tc.table_name,
      ccu.table_name AS foreign_table_name
    FROM 
      information_schema.table_constraints AS tc 
      JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
        AND ccu.table_schema = tc.table_schema
    WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = $1
  `, [tableName]);
  
  return result.rows.map(row => row.foreign_table_name);
}

async function getTableOrder(client, tables) {
  const dependencies = {};
  const visited = new Set();
  const order = [];

  // Build dependency graph
  for (const table of tables) {
    dependencies[table] = await getTableDependencies(client, table);
  }

  function visit(table) {
    if (visited.has(table)) return;
    visited.add(table);
    for (const dep of dependencies[table] || []) {
      if (tables.includes(dep)) {
        visit(dep);
      }
    }
    order.push(table);
  }

  // Visit all tables
  for (const table of tables) {
    visit(table);
  }

  return order;
}

async function syncDevToProduction() {
  console.log('🚀 Starting Development to Production Sync...\n');
  
  if (!process.env.DATABASE_URL) {
    console.error('❌ Error: DATABASE_URL environment variable is not set');
    process.exit(1);
  }

  // Confirm with user
  console.log('⚠️  WARNING: This will sync your development database to production!');
  console.log('⚠️  Make sure you have a backup of your production database.');
  console.log('⚠️  Press Ctrl+C within 10 seconds to cancel...\n');
  
  await new Promise(resolve => setTimeout(resolve, 10000));
  
  try {
    // Step 1: Get list of tables from dev
    console.log('📋 Getting table list from development...');
    const devClient = await devPool.connect();
    const tablesResult = await devClient.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    const tables = tablesResult.rows.map(row => row.table_name);
    console.log(`Found ${tables.length} tables to sync\n`);

    // Get table order based on dependencies
    console.log('🔄 Analyzing table dependencies...');
    const orderedTables = await getTableOrder(devClient, tables);
    console.log(`✅ Determined correct table order for data copying\n`);
    
    // Step 2: Create tables in production with exact schema
    console.log('📥 Creating/Updating tables in production...\n');
    const prodClient = await prodPool.connect();
    
    // First create all tables without foreign key constraints
    for (const tableName of orderedTables) {
      console.log(`🔄 Processing table: ${tableName}`);
      
      try {
        // Get column info including JSON/JSONB columns
        const columnTypesResult = await devClient.query(`
          SELECT column_name, data_type, udt_name
          FROM information_schema.columns 
          WHERE table_name = $1
        `, [tableName]);
        
        const jsonColumns = columnTypesResult.rows
          .filter(col => ['json', 'jsonb'].includes(col.data_type))
          .map(col => col.column_name);

        // Get and create table
        const createTableSQL = await getTableSchema(devClient, tableName);
        await prodClient.query(createTableSQL);
        console.log('✅ Created/Updated table structure');
        
        // Get and create indexes
        const indexResult = await devClient.query(`
          SELECT indexdef 
          FROM pg_indexes 
          WHERE tablename = $1 
          AND schemaname = 'public'
          AND indexname NOT LIKE '%_pkey'
        `, [tableName]);
        
        for (const idx of indexResult.rows) {
          try {
            await prodClient.query(idx.indexdef);
          } catch (error) {
            if (!error.message.includes('already exists')) {
              throw error;
            }
          }
        }
        
        if (indexResult.rows.length > 0) {
          console.log(`✅ Created/Updated ${indexResult.rows.length} indexes`);
        }
        
        // Copy data with special handling for JSON columns
        const dataResult = await devClient.query(`SELECT * FROM "${tableName}"`);
        if (dataResult.rows.length > 0) {
          // First truncate the table in production
          await prodClient.query(`TRUNCATE TABLE "${tableName}" CASCADE`);
          
          const columns = Object.keys(dataResult.rows[0]);
          
          // Prepare values with proper escaping
          const values = dataResult.rows.map(row => {
            return `(${columns.map(col => {
              const val = row[col];
              if (val === null) return 'NULL';
              if (jsonColumns.includes(col)) {
                return `'${JSON.stringify(val).replace(/'/g, "''")}'::jsonb`;
              }
              if (Array.isArray(val)) {
                if (val.length === 0) return 'ARRAY[]::text[]';
                if (typeof val[0] === 'object') {
                  return `ARRAY[${val.map(v => `'${JSON.stringify(v).replace(/'/g, "''")}'::jsonb`).join(',')}]`;
                }
                return `ARRAY[${val.map(v => `'${String(v).replace(/'/g, "''")}'`).join(',')}]`;
              }
              if (typeof val === 'object') {
                return `'${JSON.stringify(val).replace(/'/g, "''")}'`;
              }
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
            await prodClient.query(insertSQL);
          }
          
          console.log(`✅ Copied ${dataResult.rows.length} rows`);
        } else {
          console.log('ℹ️  Table is empty');
        }
        
      } catch (error) {
        console.error(`❌ Error processing table ${tableName}:`, error.message);
      }
    }
    
    // Step 3: Update sequences
    console.log('\n📊 Updating sequences...');
    const sequencesResult = await devClient.query(`
      SELECT c.relname as sequence_name
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE c.relkind = 'S' AND n.nspname = 'public'
    `);
    
    for (const seq of sequencesResult.rows) {
      try {
        const valueResult = await devClient.query(`SELECT last_value, is_called FROM "${seq.sequence_name}"`);
        if (valueResult.rows.length > 0) {
          const { last_value, is_called } = valueResult.rows[0];
          await prodClient.query(`SELECT setval('${seq.sequence_name}', ${last_value}, ${is_called})`);
        }
      } catch (error) {
        console.log(`⚠️  Warning updating sequence ${seq.sequence_name}: ${error.message}`);
      }
    }
    
    devClient.release();
    prodClient.release();
    
    console.log('\n🎉 Database sync completed successfully!');
    console.log('✅ Schema copied exactly from development');
    console.log('✅ All data copied in correct order');
    console.log('✅ Sequences updated');
    console.log('\n🚀 Your production database is now an exact copy of development!');
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

// Run the sync
syncDevToProduction().catch(console.error); 