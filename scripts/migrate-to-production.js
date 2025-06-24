const { Pool } = require('pg');
const config = require('./config');
const fs = require('fs').promises;

// Initialize connection pools
const devPool = new Pool(config.development.database);
const prodPool = new Pool(config.production.database);

// Migration order based on dependencies (adjusted to handle foreign keys properly)
const MIGRATION_ORDER = [
  // Core tables (no foreign key dependencies)
  'roles',
  'departments',
  'menu_items',
  'companies',
  
  // First level dependencies
  'designations',
  'branches',
  'services',
  'lead_sources',
  
  // Employee related
  'employees',
  'employee_companies',
  
  // Permissions and access
  'designation_menu_permissions',
  'role_menu_permissions',
  'role_menu_access',
  
  // Business related
  'leads',
  'activities',
  
  // AI and automation
  'ai_tasks',
  'ai_configurations',
  'business_rules',
  
  // Communication
  'call_analytics',
  'call_transcriptions',
  'call_triggers',
  'communications',
  'conversation_sessions',
  
  // Operations
  'deliverables',
  'dynamic_menus',
  'employee_assignments',
  'employee_devices',
  'events',
  
  // Social media
  'instagram_analytics',
  'instagram_comments',
  'instagram_interactions',
  'instagram_mentions',
  'instagram_messages',
  'instagram_story_mentions',
  
  // Business intelligence
  'management_insights',
  'notifications',
  'payments',
  
  // Quotations
  'quotation_approvals',
  'quotation_business_lifecycle',
  'quotation_events',
  'quotations',
  
  // Tasks and users
  'task_sequence_templates',
  'user_accounts',
  'whatsapp_messages'
];

// Skip these tables during migration
const SKIP_TABLES = [
  'pg_stat_statements',
  'schema_migrations',
  'ar_internal_metadata',
  'spatial_ref_sys',
  'quotations_backup_before_migration'
];

async function getTableColumns(pool, tableName) {
  const result = await pool.query(`
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns 
    WHERE table_name = $1 
    ORDER BY ordinal_position
  `, [tableName]);
  return result.rows;
}

async function getForeignKeyInfo(pool, tableName) {
  const query = `
    SELECT
      kcu.column_name,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name
    FROM 
      information_schema.table_constraints AS tc 
      JOIN information_schema.key_column_usage AS kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
      JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
        AND ccu.table_schema = tc.table_schema
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_name = $1;
  `;
  
  const result = await pool.query(query, [tableName]);
  return result.rows;
}

async function getTableData(pool, tableName) {
  const columns = await getTableColumns(pool, tableName);
  const foreignKeys = await getForeignKeyInfo(pool, tableName);
  const result = await pool.query(`SELECT * FROM ${tableName}`);
  return { columns, rows: result.rows, foreignKeys };
}

function processValue(value, dataType) {
  if (value === null) return null;

  switch (dataType) {
    case 'json':
    case 'jsonb':
      if (typeof value === 'string') {
        try {
          // Ensure it's valid JSON by parsing and stringifying
          return JSON.stringify(JSON.parse(value));
        } catch (e) {
          // If it's not valid JSON, return a default empty object
          return '{}';
        }
      }
      return JSON.stringify(value);
    case 'ARRAY':
      return Array.isArray(value) ? value : [];
    case 'timestamp':
    case 'timestamp without time zone':
    case 'timestamp with time zone':
      return value instanceof Date ? value : new Date(value);
    case 'boolean':
      return typeof value === 'boolean' ? value : (value === 'true' || value === 't' || value === '1');
    default:
      return value;
  }
}

async function checkForeignKeyDependencies(pool, tableName, row, foreignKeys) {
  for (const fk of foreignKeys) {
    const value = row[fk.column_name];
    if (value === null) continue;

    const checkQuery = `
      SELECT EXISTS (
        SELECT 1 
        FROM ${fk.foreign_table_name} 
        WHERE ${fk.foreign_column_name} = $1
      )
    `;
    
    const result = await pool.query(checkQuery, [value]);
    if (!result.rows[0].exists) {
      throw new Error(`Foreign key violation: ${fk.column_name}=${value} not found in ${fk.foreign_table_name}`);
    }
  }
}

async function insertData(pool, tableName, columns, rows, foreignKeys) {
  if (rows.length === 0) return 0;

  const columnList = columns.map(col => col.column_name).join(', ');
  let insertedCount = 0;
  let failedRows = [];
  
  // Special handling for designations table
  if (tableName === 'designations') {
    // Insert one by one for designations to identify problematic row
    for (const row of rows) {
      try {
        const values = columns.map(col => processValue(row[col.column_name], col.data_type));
        const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
        
        // First check if row exists
        const checkQuery = `SELECT id FROM ${tableName} WHERE id = $1`;
        const checkResult = await pool.query(checkQuery, [row.id]);
        
        if (checkResult.rowCount > 0) {
          // Row exists, update it
          const updateColumns = columns
            .filter(col => col.column_name !== 'id')
            .map((col, i) => `${col.column_name} = $${i + 2}`);
            
          const updateQuery = `
            UPDATE ${tableName}
            SET ${updateColumns.join(', ')}
            WHERE id = $1
            RETURNING id
          `;
          
          await pool.query('BEGIN');
          const result = await pool.query(updateQuery, [row.id, ...values.slice(1)]);
          await pool.query('COMMIT');
          
          if (result.rowCount > 0) {
            insertedCount++;
            console.log(`Successfully updated designation ${row.id} (${row.name})`);
          }
        } else {
          // Row doesn't exist, insert it
          const insertQuery = `
            INSERT INTO ${tableName} (${columnList})
            VALUES (${placeholders})
            RETURNING id
          `;
          
          await pool.query('BEGIN');
          const result = await pool.query(insertQuery, values);
          await pool.query('COMMIT');
          
          if (result.rowCount > 0) {
            insertedCount++;
            console.log(`Successfully inserted designation ${row.id} (${row.name})`);
          }
        }
      } catch (error) {
        await pool.query('ROLLBACK');
        console.error(`Failed to process designation ${row.id}:`, error.message);
        failedRows.push({ row, error: error.message });
      }
    }
    
    // Log failed rows
    if (failedRows.length > 0) {
      const failedRowsLog = `failed_rows_${tableName}.json`;
      await fs.writeFile(failedRowsLog, JSON.stringify(failedRows, null, 2));
      console.warn(`${failedRows.length} designations failed to process. See ${failedRowsLog} for details.`);
    }
    
    return insertedCount;
  }
  
  // For other tables, use batch insert
  const batchSize = 1000;
  
  try {
    await pool.query('BEGIN');
    
    for (let i = 0; i < rows.length; i += batchSize) {
      const batch = rows.slice(i, i + batchSize);
      const values = [];
      const paramReferences = [];
      
      batch.forEach((row, rowIndex) => {
        const rowValues = columns.map((col, colIndex) => {
          const value = row[col.column_name];
          values.push(processValue(value, col.data_type));
          return `$${rowIndex * columns.length + colIndex + 1}`;
        });
        paramReferences.push(`(${rowValues.join(', ')})`);
      });
      
      const query = `
        INSERT INTO ${tableName} (${columnList})
        VALUES ${paramReferences.join(', ')}
        ON CONFLICT (id) DO UPDATE
        SET ${columns.filter(col => col.column_name !== 'id')
          .map(col => `${col.column_name} = EXCLUDED.${col.column_name}`)
          .join(', ')}
      `;
      
      const result = await pool.query(query, values);
      insertedCount += result.rowCount;
      
      console.log(`Processed batch ${Math.floor(i/batchSize) + 1}/${Math.ceil(rows.length/batchSize)} for ${tableName}`);
    }
    
    await pool.query('COMMIT');
    
  } catch (error) {
    await pool.query('ROLLBACK');
    console.error('Batch insertion failed:', {
      tableName,
      error: error.message,
      detail: error.detail
    });
    throw error;
  }
  
  return insertedCount;
}

async function disableForeignKeyChecks(pool) {
  await pool.query('SET session_replication_role = replica;');
}

async function enableForeignKeyChecks(pool) {
  await pool.query('SET session_replication_role = DEFAULT;');
}

async function getForeignKeyConstraints(pool, tableName) {
  const query = `
    SELECT
      tc.constraint_name,
      tc.table_name,
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
        ON tc.constraint_name = rc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND (tc.table_name = $1 OR ccu.table_name = $1);
  `;
  
  const result = await pool.query(query, [tableName]);
  return result.rows;
}

async function dropForeignKeyConstraints(pool, constraints) {
  for (const constraint of constraints) {
    const query = `
      ALTER TABLE ${constraint.table_name}
      DROP CONSTRAINT IF EXISTS ${constraint.constraint_name};
    `;
    await pool.query(query);
    console.log(`Dropped constraint ${constraint.constraint_name} from ${constraint.table_name}`);
  }
}

async function recreateForeignKeyConstraints(pool, constraints) {
  for (const constraint of constraints) {
    const query = `
      ALTER TABLE ${constraint.table_name}
      ADD CONSTRAINT ${constraint.constraint_name}
      FOREIGN KEY (${constraint.column_name})
      REFERENCES ${constraint.foreign_table_name}(${constraint.foreign_column_name})
      ON UPDATE ${constraint.update_rule}
      ON DELETE ${constraint.delete_rule};
    `;
    await pool.query(query);
    console.log(`Recreated constraint ${constraint.constraint_name} on ${constraint.table_name}`);
  }
}

async function migrateTable(tableName) {
  if (SKIP_TABLES.includes(tableName)) {
    console.log(`\nSkipping table: ${tableName} (in skip list)`);
    return;
  }

  console.log(`\nMigrating table: ${tableName}`);
  
  try {
    // Get source data
    const { columns, rows, foreignKeys } = await getTableData(devPool, tableName);
    console.log(`Found ${rows.length} rows to migrate`);

    if (rows.length === 0) {
      console.log('No data to migrate, skipping...');
      return;
    }

    // Get all foreign key constraints affecting this table
    const constraints = await getForeignKeyConstraints(prodPool, tableName);
    
    // Drop foreign key constraints
    if (constraints.length > 0) {
      console.log(`Dropping ${constraints.length} foreign key constraints...`);
      await dropForeignKeyConstraints(prodPool, constraints);
    }

    // Clear existing data
    await prodPool.query('BEGIN');
    await prodPool.query(`DELETE FROM ${tableName}`);
    await prodPool.query('COMMIT');
    console.log(`Cleared existing data from ${tableName}`);

    // Insert data with retries for critical tables
    let insertedCount = 0;
    const maxRetries = tableName === 'designations' ? 3 : 1;
    let retryCount = 0;
    
    while (retryCount < maxRetries && insertedCount < rows.length) {
      try {
        insertedCount = await insertData(prodPool, tableName, columns, rows, foreignKeys);
        if (insertedCount < rows.length && retryCount < maxRetries - 1) {
          console.log(`Retry ${retryCount + 1}: ${insertedCount}/${rows.length} rows migrated`);
          retryCount++;
        }
      } catch (error) {
        console.error(`Error on try ${retryCount + 1}:`, error.message);
        retryCount++;
        if (retryCount === maxRetries) throw error;
      }
    }
    
    console.log(`Successfully migrated ${insertedCount}/${rows.length} rows`);

    // Recreate foreign key constraints
    if (constraints.length > 0) {
      console.log(`Recreating ${constraints.length} foreign key constraints...`);
      await recreateForeignKeyConstraints(prodPool, constraints);
    }

    // Log the migration
    await fs.appendFile('migration.log', 
      `${new Date().toISOString()} - ${tableName}: ${insertedCount}/${rows.length} rows migrated\n`
    );

  } catch (error) {
    console.error(`Error migrating ${tableName}:`, error.message);
    await fs.appendFile('migration.log', 
      `${new Date().toISOString()} - ERROR - ${tableName}: ${error.message}\n`
    );
    // Don't throw the error, continue with next table
    return;
  }
}

async function main() {
  try {
    console.log('Starting database migration...');
    console.log('This will migrate data from development to production.');
    console.log('Migration logs will be written to migration.log');

    // Test database connections
    await devPool.query('SELECT NOW()');
    await prodPool.query('SELECT NOW()');
    console.log('Database connections successful\n');

    // Only migrate designations and employee_assignments
    const tablesToMigrate = ['designations', 'employee_assignments'];
    
    for (const tableName of tablesToMigrate) {
      await migrateTable(tableName);
    }

    console.log('\nMigration completed! Check migration.log for details.');
    console.log('If any rows failed to migrate, check the failed_rows_*.json files.');

  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

// Run the migration
main().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
}); 