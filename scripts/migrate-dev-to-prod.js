const { Pool } = require('pg');
const config = require('./config');

// Tables to skip during migration (system tables, logs, etc.)
const SKIP_TABLES = [
  'pg_stat_statements',
  'schema_migrations',
  'ar_internal_metadata',
  'spatial_ref_sys',
  'role_menu_permissions', // Skip large permission tables that were cleaned
  'role_menu_access'
];

async function getTableDependencyOrder(pool) {
  const query = `
    WITH RECURSIVE dependencies AS (
      SELECT 
        tc.table_name,
        ccu.table_name AS depends_on,
        0 as level
      FROM information_schema.table_constraints tc
      LEFT JOIN information_schema.constraint_column_usage ccu 
        ON tc.constraint_name = ccu.constraint_name
        AND tc.table_schema = ccu.table_schema
      WHERE tc.constraint_type = 'FOREIGN KEY'
        AND tc.table_schema = 'public'
      
      UNION ALL
      
      SELECT
        d.table_name,
        ccu.table_name AS depends_on,
        d.level + 1
      FROM dependencies d
      JOIN information_schema.table_constraints tc 
        ON tc.table_name = d.depends_on
      JOIN information_schema.constraint_column_usage ccu 
        ON tc.constraint_name = ccu.constraint_name
        AND tc.table_schema = ccu.table_schema
      WHERE tc.constraint_type = 'FOREIGN KEY'
        AND tc.table_schema = 'public'
        AND d.level < 20
    ),
    table_list AS (
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
    ),
    max_levels AS (
      SELECT table_name, MAX(level) as max_level
      FROM (
        SELECT table_name, level FROM dependencies
        UNION
        SELECT table_name, 0 FROM table_list
      ) t
      GROUP BY table_name
    )
    SELECT table_name
    FROM max_levels
    WHERE table_name NOT IN (${SKIP_TABLES.map(t => `'${t}'`).join(',')})
    ORDER BY max_level DESC;
  `;

  const result = await pool.query(query);
  return result.rows.map(row => row.table_name);
}

async function getTableColumns(pool, tableName) {
  const query = `
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = $1
    ORDER BY ordinal_position;
  `;
  const result = await pool.query(query, [tableName]);
  return result.rows;
}

async function migrateTable(devPool, prodPool, tableName, batchSize = 1000) {
  console.log(`\nMigrating table: ${tableName}`);
  
  // Get column information
  const columns = await getTableColumns(devPool, tableName);
  const columnNames = columns.map(col => col.column_name);
  
  // Get total count
  const countResult = await devPool.query(`SELECT COUNT(*) FROM ${tableName}`);
  const totalRows = parseInt(countResult.rows[0].count);
  console.log(`Total rows to migrate: ${totalRows}`);

  // Start transaction in production
  await prodPool.query('BEGIN');

  try {
    // Clear existing data in production
    await prodPool.query(`DELETE FROM ${tableName}`);
    console.log(`Cleared existing data from ${tableName} in production`);

    // Migrate in batches
    for (let offset = 0; offset < totalRows; offset += batchSize) {
      const selectQuery = `
        SELECT ${columnNames.join(', ')}
        FROM ${tableName}
        ORDER BY ${columnNames[0]}
        LIMIT ${batchSize} OFFSET ${offset}
      `;
      
      const rows = await devPool.query(selectQuery);
      
      if (rows.rows.length > 0) {
        const values = rows.rows.map(row => 
          columnNames.map(col => row[col])
        );
        
        const placeholders = values.map((_, i) => 
          `(${columnNames.map((_, j) => `$${i * columnNames.length + j + 1}`).join(',')})`
        ).join(',');
        
        const insertQuery = `
          INSERT INTO ${tableName} (${columnNames.join(',')})
          VALUES ${placeholders}
        `;
        
        const flatValues = values.flat();
        await prodPool.query(insertQuery, flatValues);
        
        console.log(`Migrated batch: ${offset + rows.rows.length}/${totalRows} rows`);
      }
    }

    // Commit transaction
    await prodPool.query('COMMIT');
    console.log(`✅ Successfully migrated ${tableName}`);

  } catch (error) {
    await prodPool.query('ROLLBACK');
    console.error(`❌ Error migrating ${tableName}:`, error.message);
    throw error;
  }
}

async function migrateAllTables() {
  const devPool = new Pool(config.development.database);
  const prodPool = new Pool(config.production.database);

  try {
    console.log('Starting full database migration...');
    
    // Get tables in dependency order
    const tables = await getTableDependencyOrder(devPool);
    console.log('\nMigration order:', tables);

    // Migrate each table
    for (const table of tables) {
      await migrateTable(devPool, prodPool, table);
    }

    console.log('\n✅ Full database migration completed successfully!');

  } catch (error) {
    console.error('\n❌ Migration failed:', error.message);
    throw error;
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

// Run the migration
migrateAllTables().catch(console.error); 