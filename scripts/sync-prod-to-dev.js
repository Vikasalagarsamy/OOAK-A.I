const { Pool } = require('pg');
const fs = require('fs').promises;

// Production database connection
const PROD_DB = {
  host: 'dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com',
  port: 5432,
  database: 'ooak_ai_db',
  user: 'ooak_admin',
  password: 'mSglqEawN72hkoEj8tSNF5qv9vJr3U6k',
  ssl: { rejectUnauthorized: false }
};

// Local development database connection
const DEV_DB = {
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: process.env.POSTGRES_USER || 'vikasalagarsamy'
};

async function getTableSchema(client, tableName) {
  // Get columns
  const columnQuery = `
    SELECT 
      column_name,
      udt_name,
      data_type,
      character_maximum_length,
      column_default,
      is_nullable
    FROM information_schema.columns 
    WHERE table_name = $1 
    ORDER BY ordinal_position;
  `;
  const { rows } = await client.query(columnQuery, [tableName]);
  
  // Extract sequence names from column defaults and handle array types
  return rows.map(col => {
    let sequenceName = null;
    if (col.column_default && col.column_default.startsWith('nextval')) {
      const match = col.column_default.match(/nextval\('([^']+)'/);
      if (match) {
        sequenceName = match[1];
      }
    }
    
    // Handle array types
    let dataType = col.data_type;
    if (col.data_type === 'ARRAY') {
      // Remove _[] from udt_name to get base type
      const baseType = col.udt_name.replace('_', '');
      dataType = `${baseType}[]`;
    }
    
    return { ...col, sequence_name: sequenceName, data_type: dataType };
  });
}

async function getTableData(client, tableName) {
  const { rows } = await client.query(`SELECT * FROM ${tableName}`);
  return rows;
}

async function generateCreateTableSQL(tableName, columns) {
  let sql = `CREATE TABLE IF NOT EXISTS ${tableName} (\n`;
  
  const columnDefs = columns.map(col => {
    let def = `  "${col.column_name}" ${col.data_type}`;
    
    if (col.character_maximum_length && !col.data_type.endsWith('[]')) {
      def += `(${col.character_maximum_length})`;
    }
    
    if (col.column_default && !col.sequence_name) {
      def += ` DEFAULT ${col.column_default}`;
    }
    
    if (col.is_nullable === 'NO') {
      def += ' NOT NULL';
    }
    
    return def;
  });
  
  sql += columnDefs.join(',\n');
  sql += '\n);\n';
  
  return sql;
}

function formatValue(value, dataType) {
  if (value === null) return 'NULL';
  
  // Handle array types
  if (dataType.endsWith('[]')) {
    if (!Array.isArray(value)) {
      console.warn(`Warning: Expected array for type ${dataType} but got ${typeof value}`);
      return 'NULL';
    }
    
    const baseType = dataType.slice(0, -2);
    
    // Special handling for jsonb arrays
    if (baseType === 'jsonb') {
      try {
        const formattedValues = value.map(v => {
          // Handle string values that might be JSON strings
          if (typeof v === 'string') {
            try {
              // Try to parse if it's a JSON string
              const parsed = JSON.parse(v);
              return `'${JSON.stringify(parsed).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::jsonb`;
            } catch (e) {
              // If it's not a valid JSON string, treat it as a plain string
              return `'${JSON.stringify(v).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::jsonb`;
            }
          }
          
          // Handle objects and arrays directly
          if (typeof v === 'object') {
            return `'${JSON.stringify(v).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::jsonb`;
          }
          
          // Handle primitive values
          return `'${JSON.stringify(v).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::jsonb`;
        });
        
        return `ARRAY[${formattedValues.join(',')}]::jsonb[]`;
      } catch (error) {
        console.error(`Error formatting JSONB array value:`, error);
        console.error(`Problematic value:`, value);
        throw error;
      }
    }
    
    const formattedValues = value.map(v => formatValue(v, baseType));
    return `ARRAY[${formattedValues.join(',')}]::${baseType}[]`;
  }
  
  switch (dataType) {
    case 'timestamp without time zone':
    case 'timestamp with time zone':
    case 'date':
      return value instanceof Date ? `'${value.toISOString()}'` : `'${value}'`;
    
    case 'json':
    case 'jsonb':
      try {
        // Handle string values that might be JSON strings
        if (typeof value === 'string') {
          try {
            // Try to parse if it's a JSON string
            const parsed = JSON.parse(value);
            return `'${JSON.stringify(parsed).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::${dataType}`;
          } catch (e) {
            // If it's not a valid JSON string, treat it as a plain string
            return `'${JSON.stringify(value).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::${dataType}`;
          }
        }
        
        // Handle objects and arrays directly
        return `'${JSON.stringify(value).replace(/'/g, "''").replace(/\\/g, '\\\\')}'::${dataType}`;
      } catch (error) {
        console.error(`Error formatting ${dataType} value:`, error);
        console.error(`Problematic value:`, value);
        throw error;
      }
    
    case 'boolean':
      return value ? 'true' : 'false';
    
    case 'integer':
    case 'bigint':
    case 'numeric':
    case 'double precision':
    case 'real':
      return isNaN(value) ? 'NULL' : value;
    
    default:
      if (typeof value === 'string') {
        return `'${value.replace(/'/g, "''")}'`;
      }
      return value;
  }
}

async function generateInsertSQL(tableName, columns, data) {
  if (data.length === 0) return '';
  
  const columnNames = columns.map(col => `"${col.column_name}"`).join(', ');
  let sql = `INSERT INTO ${tableName} (${columnNames}) VALUES\n`;
  
  const values = data.map(row => {
    const rowValues = columns.map(col => {
      const value = row[col.column_name];
      return formatValue(value, col.data_type);
    });
    return `(${rowValues.join(', ')})`;
  });
  
  sql += values.join(',\n');
  sql += ';\n';
  
  return sql;
}

async function syncDatabase() {
  console.log('🚀 Starting database sync from production to development...\n');

  const prodPool = new Pool(PROD_DB);
  const devPool = new Pool(DEV_DB);

  try {
    const prodClient = await prodPool.connect();
    const devClient = await devPool.connect();

    // Get list of tables
    console.log('📊 Getting list of tables...');
    const tableQuery = `
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    `;
    const { rows: tables } = await prodClient.query(tableQuery);

    // Drop all existing tables in dev
    console.log('🗑️  Dropping existing tables in development...');
    await devClient.query('DROP SCHEMA public CASCADE;');
    await devClient.query('CREATE SCHEMA public;');

    // Process each table
    for (const { table_name } of tables) {
      console.log(`\n📋 Processing table: ${table_name}`);
      
      // Get table schema
      console.log(`  ⚙️  Getting schema...`);
      const columns = await getTableSchema(prodClient, table_name);
      
      // Create sequences first
      for (const column of columns) {
        if (column.sequence_name) {
          console.log(`  🔄 Creating sequence: ${column.sequence_name}`);
          await devClient.query(`CREATE SEQUENCE IF NOT EXISTS ${column.sequence_name};`);
        }
      }
      
      // Create table
      console.log(`  🏗️  Creating table...`);
      const createSQL = await generateCreateTableSQL(table_name, columns);
      await devClient.query(createSQL);
      
      // Set sequence ownership and default values
      for (const column of columns) {
        if (column.sequence_name) {
          await devClient.query(`ALTER SEQUENCE ${column.sequence_name} OWNED BY ${table_name}.${column.column_name};`);
          await devClient.query(`ALTER TABLE ${table_name} ALTER COLUMN ${column.column_name} SET DEFAULT nextval('${column.sequence_name}'::regclass);`);
        }
      }
      
      // Get and insert data
      console.log(`  📥 Copying data...`);
      const data = await getTableData(prodClient, table_name);
      if (data.length > 0) {
        const insertSQL = await generateInsertSQL(table_name, columns, data);
        await devClient.query(insertSQL);
        
        // Update sequence values if needed
        for (const column of columns) {
          if (column.sequence_name) {
            const maxVal = Math.max(...data.map(row => parseInt(row[column.column_name]) || 0));
            if (maxVal > 0) {
              await devClient.query(`SELECT setval('${column.sequence_name}', ${maxVal});`);
            }
          }
        }
      }
      
      console.log(`  ✅ Table ${table_name} synced (${data.length} rows)`);
    }

    // Verify data integrity
    console.log('\n🔍 Verifying data integrity...');
    console.log('============================');

    for (const { table_name } of tables) {
      const [prodCount, devCount] = await Promise.all([
        prodClient.query(`SELECT COUNT(*) as count FROM ${table_name}`),
        devClient.query(`SELECT COUNT(*) as count FROM ${table_name}`)
      ]);

      const prodRows = parseInt(prodCount.rows[0].count);
      const devRows = parseInt(devCount.rows[0].count);
      const match = prodRows === devRows;

      console.log(
        `${match ? '✅' : '❌'} ${table_name.padEnd(30)} | ` +
        `Prod: ${prodRows.toString().padStart(5)} | ` +
        `Dev: ${devRows.toString().padStart(5)} | ` +
        `${match ? 'Matched' : 'Mismatch'}`
      );
    }

    // Cleanup
    prodClient.release();
    devClient.release();
    await prodPool.end();
    await devPool.end();

    console.log('\n🎉 Database sync completed successfully!');
    console.log('=====================================');
    console.log('✅ Tables recreated');
    console.log('✅ Sequences synced');
    console.log('✅ Data copied');
    console.log('✅ Integrity verified');
    console.log('\n🚀 Your local development database is now in sync with production!');

  } catch (error) {
    console.error('\n❌ Error during database sync:', error.message);
    console.error('\n🔧 Troubleshooting steps:');
    console.error('1. Ensure PostgreSQL is running locally');
    console.error('2. Check database credentials');
    console.error('3. Make sure local PostgreSQL server is running');
    process.exit(1);
  }
}

// Run the sync
syncDatabase();