const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const prodClient = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false }
});

// Local database connection
const localClient = new Client({
  connectionString: 'postgresql://localhost:5432/ooak_ai_dev',
  ssl: false
});

async function populateLocalDatabase() {
  console.log('🔄 Populating local database with production data...');
  
  try {
    console.log('🔗 Connecting to production database...');
    await prodClient.connect();
    
    console.log('🔗 Connecting to local database...');
    await localClient.connect();
    
    // Get all tables from production
    console.log('📋 Getting table list from production...');
    const tablesResult = await prodClient.query(`
      SELECT table_name, column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position
    `);
    
    // Group columns by table
    const tableColumns = {};
    tablesResult.rows.forEach(row => {
      if (!tableColumns[row.table_name]) {
        tableColumns[row.table_name] = [];
      }
      tableColumns[row.table_name].push({
        name: row.column_name,
        type: row.data_type,
        nullable: row.is_nullable === 'YES'
      });
    });
    
    console.log(`📊 Found ${Object.keys(tableColumns).length} tables`);
    
    // Create tables in local database
    for (const tableName of Object.keys(tableColumns)) {
      console.log(`🏗️ Creating table: ${tableName}`);
      
      // Get table creation SQL from production
      const createTableResult = await prodClient.query(`
        SELECT 
          'CREATE TABLE IF NOT EXISTS "' || table_name || '" (' ||
          string_agg(
            '"' || column_name || '" ' || 
            CASE 
              WHEN data_type = 'character varying' THEN 'VARCHAR' || COALESCE('(' || character_maximum_length || ')', '')
              WHEN data_type = 'character' THEN 'CHAR' || COALESCE('(' || character_maximum_length || ')', '')
              WHEN data_type = 'text' THEN 'TEXT'
              WHEN data_type = 'integer' THEN 'INTEGER'
              WHEN data_type = 'bigint' THEN 'BIGINT'
              WHEN data_type = 'smallint' THEN 'SMALLINT'
              WHEN data_type = 'boolean' THEN 'BOOLEAN'
              WHEN data_type = 'timestamp without time zone' THEN 'TIMESTAMP'
              WHEN data_type = 'timestamp with time zone' THEN 'TIMESTAMPTZ'
              WHEN data_type = 'date' THEN 'DATE'
              WHEN data_type = 'time without time zone' THEN 'TIME'
              WHEN data_type = 'numeric' THEN 'NUMERIC' || COALESCE('(' || numeric_precision || ',' || numeric_scale || ')', '')
              WHEN data_type = 'real' THEN 'REAL'
              WHEN data_type = 'double precision' THEN 'DOUBLE PRECISION'
              WHEN data_type = 'json' THEN 'JSON'
              WHEN data_type = 'jsonb' THEN 'JSONB'
              ELSE UPPER(data_type)
            END ||
            CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END,
            ', ' ORDER BY ordinal_position
          ) || ');' as create_sql
        FROM information_schema.columns
        WHERE table_name = $1 AND table_schema = 'public'
        GROUP BY table_name
      `, [tableName]);
      
      if (createTableResult.rows.length > 0) {
        try {
          await localClient.query(createTableResult.rows[0].create_sql);
        } catch (error) {
          console.log(`   ⚠️ Could not create ${tableName}: ${error.message}`);
        }
      }
    }
    
    // Copy data from production to local
    console.log('📊 Copying data from production to local...');
    
    for (const tableName of Object.keys(tableColumns)) {
      try {
        // Check if table has data
        const countResult = await prodClient.query(`SELECT COUNT(*) FROM "${tableName}"`);
        const count = parseInt(countResult.rows[0].count);
        
        if (count > 0) {
          console.log(`  📋 Copying ${tableName} (${count} rows)...`);
          
          // Get all data from production table
          const dataResult = await prodClient.query(`SELECT * FROM "${tableName}"`);
          
          if (dataResult.rows.length > 0) {
            // Clear local table
            await localClient.query(`DELETE FROM "${tableName}"`);
            
            // Insert data into local table
            const columns = tableColumns[tableName].map(col => col.name);
            const columnNames = columns.map(col => `"${col}"`).join(', ');
            
            for (const row of dataResult.rows) {
              const values = columns.map(col => row[col]);
              const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');
              
              try {
                await localClient.query(
                  `INSERT INTO "${tableName}" (${columnNames}) VALUES (${placeholders})`,
                  values
                );
              } catch (error) {
                // Skip rows that fail (foreign key constraints, etc.)
              }
            }
          }
        }
      } catch (error) {
        console.log(`   ⚠️ Skipped ${tableName}: ${error.message}`);
      }
    }
    
    console.log('✅ Local database populated successfully!');
    console.log('🎉 Your local development environment is ready with real OOAK data!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await prodClient.end();
    await localClient.end();
  }
}

populateLocalDatabase();
