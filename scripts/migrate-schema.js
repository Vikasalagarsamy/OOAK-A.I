const { Pool } = require('pg');
const fs = require('fs').promises;

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
  ssl: {
    rejectUnauthorized: false
  }
};

// Create pools
const devPool = new Pool(DEV_CONFIG);
const prodPool = new Pool(PROD_CONFIG);

async function getTableSchema(client, tableName) {
  // Split schema and table name
  const [schema = 'public', table] = tableName.split('.');
  const actualTable = table || schema;
  const actualSchema = table ? schema : 'public';

  // Get column information
  const { rows: columns } = await client.query(`
    SELECT 
      column_name,
      data_type,
      character_maximum_length,
      column_default,
      is_nullable,
      udt_name,
      ordinal_position
    FROM information_schema.columns 
    WHERE table_schema = $1
    AND table_name = $2
    ORDER BY ordinal_position;
  `, [actualSchema, actualTable]);

  // Get constraint information
  const { rows: constraints } = await client.query(`
    SELECT
      c.conname as constraint_name,
      c.contype as constraint_type,
      pg_get_constraintdef(c.oid) as definition,
      c.contype = 'f' as is_foreign_key
    FROM pg_constraint c
    JOIN pg_namespace n ON n.oid = c.connamespace
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace tn ON tn.oid = t.relnamespace
    WHERE tn.nspname = $1
    AND t.relname = $2;
  `, [actualSchema, actualTable]);

  // Get index information
  const { rows: indexes } = await client.query(`
    SELECT
      i.relname as index_name,
      pg_get_indexdef(i.oid) as definition
    FROM pg_index x
    JOIN pg_class i ON i.oid = x.indexrelid
    JOIN pg_class t ON t.oid = x.indrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE t.relname = $1
    AND n.nspname = $2
    AND t.relkind = 'r'
    AND NOT x.indisprimary  -- Exclude primary key indexes as they'll be handled by constraints
    AND NOT x.indisunique;  -- Exclude unique indexes as they'll be handled by constraints
  `, [actualTable, actualSchema]);

  // Get sequence information if any column uses it
  const { rows: sequences } = await client.query(`
    SELECT 
      column_name,
      column_default
    FROM information_schema.columns
    WHERE table_schema = $1
    AND table_name = $2
    AND column_default LIKE 'nextval%';
  `, [actualSchema, actualTable]);

  return {
    schema: actualSchema,
    tableName: actualTable,
    columns,
    constraints,
    indexes,
    sequences
  };
}

async function getAllTables(client) {
  const { rows } = await client.query(`
    SELECT schemaname, tablename 
    FROM pg_tables 
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    ORDER BY schemaname, tablename;
  `);
  return rows.map(row => row.schemaname === 'public' ? row.tablename : `${row.schemaname}.${row.tablename}`);
}

function generateColumnDefinition(column) {
  let def = `"${column.column_name}" `;
  
  // Handle array types
  if (column.data_type === 'ARRAY') {
    // Map PostgreSQL internal type names to SQL type names
    const typeMap = {
      '_text': 'text',
      '_int4': 'integer',
      '_int8': 'bigint',
      '_float4': 'real',
      '_float8': 'double precision',
      '_bool': 'boolean',
      '_varchar': 'character varying',
      '_timestamp': 'timestamp without time zone',
      '_timestamptz': 'timestamp with time zone',
      '_date': 'date',
      '_time': 'time',
      '_timetz': 'time with time zone',
      '_numeric': 'numeric',
      '_uuid': 'uuid',
      '_json': 'json',
      '_jsonb': 'jsonb'
    };
    
    const baseType = typeMap[column.udt_name] || column.udt_name.replace(/^_/, '');
    def += `${baseType}[]`;
  } else {
    def += column.data_type;
  }
  
  if (column.character_maximum_length) {
    def += `(${column.character_maximum_length})`;
  }
  
  if (column.column_default && !column.column_default.includes('nextval')) {
    def += ` DEFAULT ${column.column_default}`;
  }
  
  if (column.is_nullable === 'NO') {
    def += ' NOT NULL';
  }
  
  return def;
}

async function generateCreateTableSQL(client, tableName, includeForeignKeys = false) {
  const schema = await getTableSchema(client, tableName);
  
  // Start with CREATE TABLE
  let sql = `CREATE TABLE ${schema.schema}.${schema.tableName} (\n`;
  
  // Add columns
  const columnDefs = schema.columns.map(col => '  ' + generateColumnDefinition(col));
  sql += columnDefs.join(',\n');
  
  // Add non-foreign key constraints that are part of CREATE TABLE
  const tableConstraints = schema.constraints
    .filter(con => !con.definition.startsWith('CREATE') && (!con.is_foreign_key || includeForeignKeys))
    .map(con => '  ' + con.definition);
  
  if (tableConstraints.length > 0) {
    sql += ',\n' + tableConstraints.join(',\n');
  }
  
  sql += '\n);\n\n';
  
  // Handle sequences
  for (const seq of schema.sequences) {
    const seqName = seq.column_default.match(/nextval\('([^']+)'/)[1];
    sql += `CREATE SEQUENCE IF NOT EXISTS ${seqName} OWNED BY ${schema.schema}.${schema.tableName}.${seq.column_name};\n`;
    sql += `ALTER TABLE ONLY ${schema.schema}.${schema.tableName} ALTER COLUMN ${seq.column_name} SET DEFAULT nextval('${seqName}');\n\n`;
  }
  
  // Add non-foreign key constraints that are separate ALTER TABLE commands
  const alterConstraints = schema.constraints
    .filter(con => con.definition.startsWith('CREATE') && (!con.is_foreign_key || includeForeignKeys))
    .map(con => con.definition);
  
  if (alterConstraints.length > 0) {
    sql += alterConstraints.join(';\n') + ';\n\n';
  }
  
  // Add indexes
  if (schema.indexes.length > 0) {
    sql += schema.indexes.map(idx => idx.definition).join(';\n') + ';\n';
  }
  
  return sql;
}

async function getForeignKeyConstraints(client, tableName) {
  const schema = await getTableSchema(client, tableName);
  const { rows: constraints } = await client.query(`
    SELECT pg_get_constraintdef(c.oid) as definition
    FROM pg_constraint c
    JOIN pg_namespace n ON n.oid = c.connamespace
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace tn ON tn.oid = t.relnamespace
    WHERE tn.nspname = $1
    AND t.relname = $2
    AND c.contype = 'f';
  `, [schema.schema, schema.tableName]);

  return constraints.map(c => `ALTER TABLE ONLY ${schema.schema}.${schema.tableName} ADD ${c.definition};`);
}

async function getRequiredExtensions(client) {
  const { rows } = await client.query(`
    SELECT extname
    FROM pg_extension;
  `);
  return rows.map(row => row.extname);
}

async function getRequiredSchemas(client) {
  const { rows } = await client.query(`
    SELECT DISTINCT schemaname
    FROM pg_tables
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema');
  `);
  return rows.map(row => row.schemaname);
}

async function migrateSchema() {
  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    console.log('🔍 Analyzing schemas...\n');

    // Get all tables
    const devTables = await getAllTables(devClient);
    const prodTables = await getAllTables(prodClient);

    console.log('📊 Table count:');
    console.log(`   Development: ${devTables.length} tables`);
    console.log(`   Production:  ${prodTables.length} tables`);

    // Start transaction for production changes
    await prodClient.query('BEGIN');

    try {
      // Create required schemas
      console.log('\n🔧 Setting up schemas...');
      const schemas = await getRequiredSchemas(devClient);
      for (const schema of schemas) {
        try {
          await prodClient.query(`CREATE SCHEMA IF NOT EXISTS ${schema};`);
          console.log(`   ✅ Created schema: ${schema}`);
        } catch (error) {
          console.log(`   ⚠️  Could not create schema ${schema}: ${error.message}`);
        }
      }

      // Create extensions schema and copy extensions
      console.log('\n🔧 Setting up extensions...');
      await prodClient.query('CREATE SCHEMA IF NOT EXISTS extensions;');
      
      const extensions = await getRequiredExtensions(devClient);
      for (const ext of extensions) {
        try {
          await prodClient.query(`CREATE EXTENSION IF NOT EXISTS "${ext}" SCHEMA extensions;`);
          console.log(`   ✅ Created extension: ${ext}`);
        } catch (error) {
          console.log(`   ⚠️  Could not create extension ${ext}: ${error.message}`);
        }
      }

      // First pass: Create all tables without foreign key constraints
      console.log('\n🔨 Creating tables (without foreign keys)...');
      for (const tableName of devTables) {
        console.log(`\n📦 Processing table: ${tableName}`);

        // Drop existing table if it exists
        const schema = await getTableSchema(devClient, tableName);
        await prodClient.query(`DROP TABLE IF EXISTS ${schema.schema}.${schema.tableName} CASCADE`);
        
        // Create table without foreign keys
        const createSQL = await generateCreateTableSQL(devClient, tableName, false);
        await prodClient.query(createSQL);
        console.log(`   ✅ Created table ${tableName}`);
      }

      // Second pass: Add foreign key constraints
      console.log('\n🔗 Adding foreign key constraints...');
      for (const tableName of devTables) {
        console.log(`\n📦 Processing foreign keys for: ${tableName}`);
        
        const constraints = await getForeignKeyConstraints(devClient, tableName);
        if (constraints.length > 0) {
          for (const constraint of constraints) {
            await prodClient.query(constraint);
          }
          console.log(`   ✅ Added ${constraints.length} foreign key(s)`);
        } else {
          console.log('   ℹ️  No foreign keys to add');
        }
      }

      await prodClient.query('COMMIT');
      console.log('\n✅ Schema migration completed successfully');

    } catch (error) {
      await prodClient.query('ROLLBACK');
      throw error;
    }

  } catch (error) {
    console.error('\n❌ Schema migration failed:', error.message);
    process.exit(1);
  } finally {
    await devClient.release();
    await prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

console.log('🚀 Starting Schema Migration...\n');
migrateSchema(); 
 