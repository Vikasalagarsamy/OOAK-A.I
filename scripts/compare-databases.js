const { Pool } = require('pg');
const config = require('./config');

// Initialize connection pools
const devPool = new Pool(config.development.database);
const prodPool = new Pool(config.production.database);

async function getTableInfo(pool, schema = 'public') {
  // Get all tables
  const tables = await pool.query(`
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = $1 
    AND table_type = 'BASE TABLE'
    ORDER BY table_name
  `, [schema]);

  const tableInfo = {};

  // Get column info and row count for each table
  for (const table of tables.rows) {
    const tableName = table.table_name;
    
    // Get columns
    const columns = await pool.query(`
      SELECT column_name, data_type, udt_name, is_nullable, column_default
      FROM information_schema.columns
      WHERE table_schema = $1 AND table_name = $2
      ORDER BY ordinal_position
    `, [schema, tableName]);

    // Get row count
    const count = await pool.query(`
      SELECT COUNT(*) as count 
      FROM "${schema}"."${tableName}"
    `);

    // Get sample data
    const sample = await pool.query(`
      SELECT * 
      FROM "${schema}"."${tableName}"
      LIMIT 1
    `);

    tableInfo[tableName] = {
      columns: columns.rows,
      rowCount: parseInt(count.rows[0].count),
      sampleData: sample.rows[0]
    };
  }

  return tableInfo;
}

async function compareSchemas() {
  try {
    console.log('Comparing development and production databases...\n');

    const devInfo = await getTableInfo(devPool);
    const prodInfo = await getTableInfo(prodPool);

    // Compare tables
    const allTables = new Set([...Object.keys(devInfo), ...Object.keys(prodInfo)]);

    console.log('=== Schema Comparison ===\n');
    
    for (const tableName of allTables) {
      console.log(`Table: ${tableName}`);
      
      if (!devInfo[tableName]) {
        console.log('  ❌ Missing in development');
        continue;
      }
      
      if (!prodInfo[tableName]) {
        console.log('  ❌ Missing in production');
        continue;
      }

      // Compare column count
      const devColumns = devInfo[tableName].columns;
      const prodColumns = prodInfo[tableName].columns;
      
      console.log(`  Columns: ${devColumns.length} (dev) vs ${prodColumns.length} (prod)`);
      
      // Compare row count
      const devCount = devInfo[tableName].rowCount;
      const prodCount = prodInfo[tableName].rowCount;
      
      console.log(`  Rows: ${devCount} (dev) vs ${prodCount} (prod)`);
      
      // Check for column differences
      const devColNames = new Set(devColumns.map(c => c.column_name));
      const prodColNames = new Set(prodColumns.map(c => c.column_name));
      
      const missingInProd = [...devColNames].filter(x => !prodColNames.has(x));
      const missingInDev = [...prodColNames].filter(x => !devColNames.has(x));
      
      if (missingInProd.length > 0) {
        console.log('  ⚠️  Columns missing in production:', missingInProd.join(', '));
      }
      
      if (missingInDev.length > 0) {
        console.log('  ⚠️  Columns missing in development:', missingInDev.join(', '));
      }

      // Compare column types
      const typeMismatches = [];
      devColumns.forEach(devCol => {
        const prodCol = prodColumns.find(c => c.column_name === devCol.column_name);
        if (prodCol && (devCol.data_type !== prodCol.data_type || devCol.udt_name !== prodCol.udt_name)) {
          typeMismatches.push(`${devCol.column_name} (dev: ${devCol.data_type}, prod: ${prodCol.data_type})`);
        }
      });

      if (typeMismatches.length > 0) {
        console.log('  ⚠️  Type mismatches:', typeMismatches.join(', '));
      }

      console.log('');
    }

  } catch (error) {
    console.error('Error comparing schemas:', error);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

compareSchemas().catch(console.error); 