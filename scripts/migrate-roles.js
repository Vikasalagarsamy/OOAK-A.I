const { Pool } = require('pg');

// Development database configuration
const DEV_CONFIG = {
  user: 'vikasalagarsamy',
  host: 'localhost',
  database: 'ooak_ai_db',
  port: 5432
};

// Production database configuration
const PROD_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create pools
const devPool = new Pool(DEV_CONFIG);
const prodPool = new Pool(PROD_CONFIG);

async function getTableColumns(client, tableName) {
  const { rows } = await client.query(`
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = $1
  `, [tableName]);
  return rows;
}

async function migrateRoles() {
  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    // Get column information from both databases
    const devColumns = await getTableColumns(devClient, 'roles');
    const prodColumns = await getTableColumns(prodClient, 'roles');
    
    // Create maps for easy lookup
    const prodColumnMap = new Map(prodColumns.map(col => [col.column_name, col]));
    
    // Build the SELECT query based on production columns
    const selectColumns = devColumns
      .filter(col => prodColumnMap.has(col.column_name))
      .map(col => {
        if (col.data_type === 'json' || col.data_type === 'jsonb') {
          return `COALESCE(${col.column_name}::text, '[]') as ${col.column_name}`;
        }
        return col.column_name;
      })
      .join(', ');

    // Get roles from development
    const { rows } = await devClient.query(`
      SELECT ${selectColumns}
      FROM roles 
      ORDER BY id
    `);
    
    if (rows.length === 0) {
      console.log('ℹ️  No roles to migrate');
      return;
    }

    // Insert each role
    for (const role of rows) {
      const columns = Object.keys(role);
      const valuePlaceholders = columns.map((_, i) => `$${i + 1}`).join(', ');
      const values = columns.map(col => role[col]);

      try {
        await prodClient.query(`
          INSERT INTO roles (${columns.join(', ')})
          VALUES (${valuePlaceholders})
          ON CONFLICT (id) DO NOTHING
        `, values);
      } catch (error) {
        console.error('❌ Error inserting role:', error.message);
        console.error('Role:', role);
        throw error;
      }
    }

    console.log(`✅ Migrated ${rows.length} roles`);

    // Verify the migration
    const devCount = (await devClient.query('SELECT COUNT(*) FROM roles')).rows[0].count;
    const prodCount = (await prodClient.query('SELECT COUNT(*) FROM roles')).rows[0].count;
    
    console.log('\n📊 Roles count:');
    console.log(`   Development: ${devCount}`);
    console.log(`   Production:  ${prodCount}`);

  } catch (error) {
    console.error('\n❌ Role migration failed:', error.message);
    process.exit(1);
  } finally {
    await devClient.release();
    await prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

console.log('🚀 Starting Roles Migration...\n');
migrateRoles(); 
 

// Development database configuration
const DEV_CONFIG = {
  user: 'vikasalagarsamy',
  host: 'localhost',
  database: 'ooak_ai_db',
  port: 5432
};

// Production database configuration
const PROD_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create pools
const devPool = new Pool(DEV_CONFIG);
const prodPool = new Pool(PROD_CONFIG);

async function getTableColumns(client, tableName) {
  const { rows } = await client.query(`
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = $1
  `, [tableName]);
  return rows;
}

async function migrateRoles() {
  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    // Get column information from both databases
    const devColumns = await getTableColumns(devClient, 'roles');
    const prodColumns = await getTableColumns(prodClient, 'roles');
    
    // Create maps for easy lookup
    const prodColumnMap = new Map(prodColumns.map(col => [col.column_name, col]));
    
    // Build the SELECT query based on production columns
    const selectColumns = devColumns
      .filter(col => prodColumnMap.has(col.column_name))
      .map(col => {
        if (col.data_type === 'json' || col.data_type === 'jsonb') {
          return `COALESCE(${col.column_name}::text, '[]') as ${col.column_name}`;
        }
        return col.column_name;
      })
      .join(', ');

    // Get roles from development
    const { rows } = await devClient.query(`
      SELECT ${selectColumns}
      FROM roles 
      ORDER BY id
    `);
    
    if (rows.length === 0) {
      console.log('ℹ️  No roles to migrate');
      return;
    }

    // Insert each role
    for (const role of rows) {
      const columns = Object.keys(role);
      const valuePlaceholders = columns.map((_, i) => `$${i + 1}`).join(', ');
      const values = columns.map(col => role[col]);

      try {
        await prodClient.query(`
          INSERT INTO roles (${columns.join(', ')})
          VALUES (${valuePlaceholders})
          ON CONFLICT (id) DO NOTHING
        `, values);
      } catch (error) {
        console.error('❌ Error inserting role:', error.message);
        console.error('Role:', role);
        throw error;
      }
    }

    console.log(`✅ Migrated ${rows.length} roles`);

    // Verify the migration
    const devCount = (await devClient.query('SELECT COUNT(*) FROM roles')).rows[0].count;
    const prodCount = (await prodClient.query('SELECT COUNT(*) FROM roles')).rows[0].count;
    
    console.log('\n📊 Roles count:');
    console.log(`   Development: ${devCount}`);
    console.log(`   Production:  ${prodCount}`);

  } catch (error) {
    console.error('\n❌ Role migration failed:', error.message);
    process.exit(1);
  } finally {
    await devClient.release();
    await prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

console.log('🚀 Starting Roles Migration...\n');
migrateRoles(); 