const fs = require('fs').promises;
const path = require('path');
const {
  getDataType,
  buildColumnDefinition,
  getTableConstraints,
  buildCreateTableStatement,
  sortTablesByDependencies,
  getForeignKeyDependencies,
  migrateTableData,
  devPool,
  prodPool
} = require('./migration-helpers');

// Logger setup
const logFile = path.join(__dirname, '../logs/migration.log');
const log = async (message) => {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${message}\n`;
  console.log(message);
  await fs.appendFile(logFile, logMessage);
};

async function validateConnection() {
  // Test development database connection
  try {
    const devClient = await devPool.connect();
    const devResult = await devClient.query('SELECT current_database()');
    await log(`Successfully connected to development database: ${devResult.rows[0].current_database}`);
    devClient.release();
  } catch (error) {
    throw new Error(`Failed to connect to development database: ${error.message}`);
  }

  // Test production database connection if DATABASE_URL is provided
  if (process.env.DATABASE_URL) {
    try {
      const prodClient = await prodPool.connect();
      const prodResult = await prodClient.query('SELECT current_database()');
      await log(`Successfully connected to production database: ${prodResult.rows[0].current_database}`);
      prodClient.release();
    } catch (error) {
      throw new Error(`Failed to connect to production database: ${error.message}`);
    }
  }
}

async function ensureSchemas() {
  const schemas = ['public', 'auth', 'extensions'];
  for (const schema of schemas) {
    await prodPool.query(`CREATE SCHEMA IF NOT EXISTS "${schema}"`);
    await log(`Created schema: ${schema}`);
  }
}

async function ensureExtensions() {
  const extensions = [
    { name: 'uuid-ossp', schema: 'extensions' },
    { name: 'pgcrypto', schema: 'extensions' },
    { name: 'citext', schema: 'extensions' }
  ];

  for (const ext of extensions) {
    try {
      await prodPool.query(`
        CREATE EXTENSION IF NOT EXISTS "${ext.name}" 
        WITH SCHEMA "${ext.schema}"
      `);
      await log(`Created extension: ${ext.name} in schema ${ext.schema}`);
    } catch (error) {
      await log(`Error creating extension ${ext.name}: ${error.message}`);
      throw error;
    }
  }
}

async function getTableSchema(client, tableName, schema = 'public') {
  try {
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
      WHERE table_name = $1 AND table_schema = $2
      ORDER BY ordinal_position
    `, [tableName, schema]);

    if (columnsResult.rows.length === 0) {
      throw new Error(`Table ${schema}.${tableName} not found`);
    }

    // Build column definitions
    const columns = columnsResult.rows.map(col => {
      let dataType = getDataType(col);
      return buildColumnDefinition(col, dataType);
    });

    // Get constraints
    const constraints = await getTableConstraints(client, tableName, schema);
    
    // Build CREATE TABLE statement
    return buildCreateTableStatement(tableName, schema, columns, constraints);
  } catch (error) {
    await log(`Error getting schema for ${schema}.${tableName}: ${error.message}`);
    throw error;
  }
}

async function migrateSchema() {
  const client = await devPool.connect();
  try {
    // Get all tables from development database
    const tablesResult = await client.query(`
      SELECT table_name, table_schema
      FROM information_schema.tables
      WHERE table_schema IN ('public', 'auth')
      AND table_type = 'BASE TABLE'
    `);

    // Sort tables by dependencies
    const sortedTables = await sortTablesByDependencies(client, tablesResult.rows);

    // First pass: Create tables without foreign keys
    for (const table of sortedTables) {
      const schema = await getTableSchema(client, table.table_name, table.table_schema);
      await prodPool.query(schema.baseTableSql);
      await log(`Created table: ${table.table_schema}.${table.table_name}`);
    }

    // Second pass: Add foreign key constraints
    for (const table of sortedTables) {
      const schema = await getTableSchema(client, table.table_name, table.table_schema);
      for (const fkSql of schema.foreignKeySql) {
        await prodPool.query(fkSql);
      }
      await log(`Added foreign keys for: ${table.table_schema}.${table.table_name}`);
    }

  } catch (error) {
    await log(`Error during schema migration: ${error.message}`);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    // Ensure log directory exists
    await fs.mkdir(path.join(__dirname, '../logs'), { recursive: true });
    
    await log('Starting database migration...');
    
    // Validate database connections
    await validateConnection();
    
    // Step 1: Create schemas
    await log('Creating schemas...');
    await ensureSchemas();
    
    // Step 2: Create extensions
    await log('Creating extensions...');
    await ensureExtensions();
    
    // Step 3: Migrate schema
    await log('Migrating schema...');
    await migrateSchema();
    
    // Step 4: Migrate data
    await log('Migrating data...');
    for (const schema of ['public', 'auth']) {
      const tables = await devPool.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = $1
        AND table_type = 'BASE TABLE'
      `, [schema]);
      
      for (const table of tables.rows) {
        await migrateTableData(table.table_name, schema);
      }
    }
    
    await log('Migration completed successfully!');
  } catch (error) {
    await log(`Migration failed: ${error.message}`);
    process.exit(1);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  migrateSchema,
  migrateData: async () => {
    for (const schema of ['public', 'auth']) {
      const tables = await devPool.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = $1
        AND table_type = 'BASE TABLE'
      `, [schema]);
      
      for (const table of tables.rows) {
        await migrateTableData(table.table_name, schema);
      }
    }
  }
}; 
 
const path = require('path');
const {
  getDataType,
  buildColumnDefinition,
  getTableConstraints,
  buildCreateTableStatement,
  sortTablesByDependencies,
  getForeignKeyDependencies,
  migrateTableData,
  devPool,
  prodPool
} = require('./migration-helpers');

// Logger setup
const logFile = path.join(__dirname, '../logs/migration.log');
const log = async (message) => {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${message}\n`;
  console.log(message);
  await fs.appendFile(logFile, logMessage);
};

async function validateConnection() {
  // Test development database connection
  try {
    const devClient = await devPool.connect();
    const devResult = await devClient.query('SELECT current_database()');
    await log(`Successfully connected to development database: ${devResult.rows[0].current_database}`);
    devClient.release();
  } catch (error) {
    throw new Error(`Failed to connect to development database: ${error.message}`);
  }

  // Test production database connection if DATABASE_URL is provided
  if (process.env.DATABASE_URL) {
    try {
      const prodClient = await prodPool.connect();
      const prodResult = await prodClient.query('SELECT current_database()');
      await log(`Successfully connected to production database: ${prodResult.rows[0].current_database}`);
      prodClient.release();
    } catch (error) {
      throw new Error(`Failed to connect to production database: ${error.message}`);
    }
  }
}

async function ensureSchemas() {
  const schemas = ['public', 'auth', 'extensions'];
  for (const schema of schemas) {
    await prodPool.query(`CREATE SCHEMA IF NOT EXISTS "${schema}"`);
    await log(`Created schema: ${schema}`);
  }
}

async function ensureExtensions() {
  const extensions = [
    { name: 'uuid-ossp', schema: 'extensions' },
    { name: 'pgcrypto', schema: 'extensions' },
    { name: 'citext', schema: 'extensions' }
  ];

  for (const ext of extensions) {
    try {
      await prodPool.query(`
        CREATE EXTENSION IF NOT EXISTS "${ext.name}" 
        WITH SCHEMA "${ext.schema}"
      `);
      await log(`Created extension: ${ext.name} in schema ${ext.schema}`);
    } catch (error) {
      await log(`Error creating extension ${ext.name}: ${error.message}`);
      throw error;
    }
  }
}

async function getTableSchema(client, tableName, schema = 'public') {
  try {
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
      WHERE table_name = $1 AND table_schema = $2
      ORDER BY ordinal_position
    `, [tableName, schema]);

    if (columnsResult.rows.length === 0) {
      throw new Error(`Table ${schema}.${tableName} not found`);
    }

    // Build column definitions
    const columns = columnsResult.rows.map(col => {
      let dataType = getDataType(col);
      return buildColumnDefinition(col, dataType);
    });

    // Get constraints
    const constraints = await getTableConstraints(client, tableName, schema);
    
    // Build CREATE TABLE statement
    return buildCreateTableStatement(tableName, schema, columns, constraints);
  } catch (error) {
    await log(`Error getting schema for ${schema}.${tableName}: ${error.message}`);
    throw error;
  }
}

async function migrateSchema() {
  const client = await devPool.connect();
  try {
    // Get all tables from development database
    const tablesResult = await client.query(`
      SELECT table_name, table_schema
      FROM information_schema.tables
      WHERE table_schema IN ('public', 'auth')
      AND table_type = 'BASE TABLE'
    `);

    // Sort tables by dependencies
    const sortedTables = await sortTablesByDependencies(client, tablesResult.rows);

    // First pass: Create tables without foreign keys
    for (const table of sortedTables) {
      const schema = await getTableSchema(client, table.table_name, table.table_schema);
      await prodPool.query(schema.baseTableSql);
      await log(`Created table: ${table.table_schema}.${table.table_name}`);
    }

    // Second pass: Add foreign key constraints
    for (const table of sortedTables) {
      const schema = await getTableSchema(client, table.table_name, table.table_schema);
      for (const fkSql of schema.foreignKeySql) {
        await prodPool.query(fkSql);
      }
      await log(`Added foreign keys for: ${table.table_schema}.${table.table_name}`);
    }

  } catch (error) {
    await log(`Error during schema migration: ${error.message}`);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    // Ensure log directory exists
    await fs.mkdir(path.join(__dirname, '../logs'), { recursive: true });
    
    await log('Starting database migration...');
    
    // Validate database connections
    await validateConnection();
    
    // Step 1: Create schemas
    await log('Creating schemas...');
    await ensureSchemas();
    
    // Step 2: Create extensions
    await log('Creating extensions...');
    await ensureExtensions();
    
    // Step 3: Migrate schema
    await log('Migrating schema...');
    await migrateSchema();
    
    // Step 4: Migrate data
    await log('Migrating data...');
    for (const schema of ['public', 'auth']) {
      const tables = await devPool.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = $1
        AND table_type = 'BASE TABLE'
      `, [schema]);
      
      for (const table of tables.rows) {
        await migrateTableData(table.table_name, schema);
      }
    }
    
    await log('Migration completed successfully!');
  } catch (error) {
    await log(`Migration failed: ${error.message}`);
    process.exit(1);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  migrateSchema,
  migrateData: async () => {
    for (const schema of ['public', 'auth']) {
      const tables = await devPool.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = $1
        AND table_type = 'BASE TABLE'
      `, [schema]);
      
      for (const table of tables.rows) {
        await migrateTableData(table.table_name, schema);
      }
    }
  }
}; 