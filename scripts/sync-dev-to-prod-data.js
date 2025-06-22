const { Pool } = require('pg');

// Database connection URLs
const DEV_DB_URL = 'postgresql://localhost:5432/ooak_ai_dev';
const PROD_DB_URL = process.env.DATABASE_URL;

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

// Core tables that should be copied first
const CORE_TABLES = [
  'designations',
  'menu_items',
  'departments',
  'branches',
  'companies',
  'roles',
  'services',
  'lead_sources',
  'deliverable_master',
  'service_packages'
];

// Tables with foreign key dependencies
const DEPENDENT_TABLES = [
  'employees',
  'designation_menu_permissions',
  'role_menu_permissions',
  'role_menu_access',
  'leads',
  'clients',
  'quotations',
  'quote_services_snapshot',
  'quote_deliverables_snapshot',
  'quotation_approvals',
  'post_sale_confirmations',
  'post_sales_workflows',
  'deliverables',
  'ai_configurations',
  'ai_communication_tasks',
  'call_transcriptions',
  'communications',
  'dynamic_menus',
  'events',
  'instagram_analytics',
  'instagram_comments',
  'instagram_interactions',
  'instagram_mentions',
  'instagram_messages',
  'instagram_story_mentions',
  'management_insights',
  'task_sequence_templates',
  'quotations_backup_before_migration'
];

async function getTableConstraints(client, tableName) {
  const result = await client.query(`
    SELECT 
      tc.constraint_name,
      tc.constraint_type,
      kcu.column_name,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name,
      rc.update_rule,
      rc.delete_rule
    FROM information_schema.table_constraints tc
    LEFT JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
    LEFT JOIN information_schema.constraint_column_usage ccu
      ON tc.constraint_name = ccu.constraint_name
    LEFT JOIN information_schema.referential_constraints rc
      ON tc.constraint_name = rc.constraint_name
    WHERE tc.table_name = $1
      AND tc.constraint_type IN ('FOREIGN KEY', 'PRIMARY KEY', 'UNIQUE')
  `, [tableName]);
  
  return result.rows;
}

async function dropTableConstraints(client, tableName) {
  const constraints = await getTableConstraints(client, tableName);
  
  for (const constraint of constraints) {
    try {
      await client.query(`
        ALTER TABLE "${tableName}" 
        DROP CONSTRAINT IF EXISTS "${constraint.constraint_name}" CASCADE
      `);
      console.log(`  ↪ Dropped constraint: ${constraint.constraint_name}`);
    } catch (error) {
      console.error(`  ❌ Error dropping constraint ${constraint.constraint_name}:`, error.message);
    }
  }
  
  return constraints;
}

async function recreateTableConstraints(client, tableName, constraints) {
  for (const constraint of constraints) {
    try {
      let sql = '';
      
      if (constraint.constraint_type === 'FOREIGN KEY') {
        sql = `
          ALTER TABLE "${tableName}"
          ADD CONSTRAINT "${constraint.constraint_name}"
          FOREIGN KEY ("${constraint.column_name}")
          REFERENCES "${constraint.foreign_table_name}" ("${constraint.foreign_column_name}")
          ON UPDATE ${constraint.update_rule}
          ON DELETE ${constraint.delete_rule}
        `;
      } else if (constraint.constraint_type === 'PRIMARY KEY') {
        sql = `
          ALTER TABLE "${tableName}"
          ADD CONSTRAINT "${constraint.constraint_name}"
          PRIMARY KEY ("${constraint.column_name}")
        `;
      } else if (constraint.constraint_type === 'UNIQUE') {
        sql = `
          ALTER TABLE "${tableName}"
          ADD CONSTRAINT "${constraint.constraint_name}"
          UNIQUE ("${constraint.column_name}")
        `;
      }
      
      if (sql) {
        await client.query(sql);
        console.log(`  ↪ Recreated constraint: ${constraint.constraint_name}`);
      }
    } catch (error) {
      console.error(`  ❌ Error recreating constraint ${constraint.constraint_name}:`, error.message);
    }
  }
}

async function copyTableData(devClient, prodClient, tableName) {
  console.log(`\n🔄 Copying data for table: ${tableName}`);

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

    // Get data from dev
    const dataResult = await devClient.query(`SELECT * FROM "${tableName}"`);
    
    if (dataResult.rows.length > 0) {
      // Drop constraints before truncating
      console.log('  📝 Dropping constraints...');
      const constraints = await dropTableConstraints(prodClient, tableName);
      
      // Truncate the table
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
      
      console.log(`  ✅ Copied ${dataResult.rows.length} rows`);

      // Update sequence if exists
      try {
        const seqName = `${tableName}_id_seq`;
        const seqResult = await devClient.query(`SELECT last_value, is_called FROM "${seqName}"`);
        if (seqResult.rows.length > 0) {
          const { last_value, is_called } = seqResult.rows[0];
          await prodClient.query(`SELECT setval('${seqName}', ${last_value}, ${is_called})`);
          console.log(`  ✅ Updated sequence ${seqName}`);
        }
      } catch (error) {
        // Sequence might not exist, which is fine
      }

      // Recreate constraints
      console.log('  📝 Recreating constraints...');
      await recreateTableConstraints(prodClient, tableName, constraints);
      
    } else {
      console.log('  ℹ️  Table is empty in development');
    }
  } catch (error) {
    console.error(`  ❌ Error copying table ${tableName}:`, error.message);
    throw error;
  }
}

async function syncData() {
  console.log('🚀 Starting Data Sync from Development to Production...\n');
  
  if (!process.env.DATABASE_URL) {
    console.error('❌ Error: DATABASE_URL environment variable is not set');
    process.exit(1);
  }

  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    // Copy core tables first
    console.log('\n📦 Copying core tables...');
    for (const tableName of CORE_TABLES) {
      await copyTableData(devClient, prodClient, tableName);
    }

    // Copy dependent tables
    console.log('\n📦 Copying dependent tables...');
    for (const tableName of DEPENDENT_TABLES) {
      await copyTableData(devClient, prodClient, tableName);
    }

    console.log('\n🎉 Data sync completed successfully!');
    console.log('✅ Core tables copied');
    console.log('✅ Dependent tables copied');
    console.log('✅ Sequences updated');
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
  } finally {
    devClient.release();
    prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

// Run the sync
syncData().catch(console.error); 