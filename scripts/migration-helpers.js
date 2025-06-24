const { Pool } = require('pg');
const config = require('./config');

// Initialize connection pools
const devPool = new Pool(config.development.database);
const prodPool = new Pool(config.production.database);

function getDataType(column) {
  // Handle array types
  if (column.data_type === 'ARRAY') {
    const baseType = column.udt_name.replace('_', '');
    return `${baseType}[]`;
  }
  
  // Handle user-defined types
  if (column.data_type === 'USER-DEFINED') {
    if (column.udt_schema === 'public') {
      return column.udt_name;
    }
    return `${column.udt_schema}.${column.udt_name}`;
  }
  
  // Handle character types
  if (column.data_type.startsWith('character')) {
    if (column.character_maximum_length) {
      return `${column.data_type}(${column.character_maximum_length})`;
    }
    return column.data_type;
  }
  
  // Handle numeric types
  if (column.data_type === 'numeric' && (column.numeric_precision || column.numeric_scale)) {
    if (column.numeric_scale) {
      return `numeric(${column.numeric_precision},${column.numeric_scale})`;
    }
    return `numeric(${column.numeric_precision})`;
  }
  
  return column.data_type;
}

function buildColumnDefinition(column, dataType) {
  let def = `"${column.column_name}" ${dataType}`;
  
  // Add nullability
  if (column.is_nullable === 'NO') {
    def += ' NOT NULL';
  }
  
  // Add default value
  if (column.column_default !== null) {
    if (column.column_default.includes('nextval')) {
      if (dataType === 'bigint') {
        def = def.replace(dataType, 'BIGSERIAL');
      } else {
        def = def.replace(dataType, 'SERIAL');
      }
    } else {
      def += ` DEFAULT ${column.column_default}`;
    }
  }
  
  return def;
}

async function getTableConstraints(client, tableName, schema) {
  // Get primary key constraints
  const pkResult = await client.query(`
    SELECT 
      c.conname as constraint_name,
      string_agg(a.attname, ', ') as columns
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_namespace n ON t.relnamespace = n.oid
    JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(c.conkey)
    WHERE c.contype = 'p' 
    AND t.relname = $1 
    AND n.nspname = $2
    GROUP BY c.conname
  `, [tableName, schema]);

  // Get foreign key constraints
  const fkResult = await client.query(`
    SELECT
      tc.constraint_name,
      kcu.column_name,
      ccu.table_schema AS foreign_table_schema,
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
      JOIN information_schema.referential_constraints AS rc
        ON rc.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = $1
    AND tc.table_schema = $2;
  `, [tableName, schema]);

  return {
    primaryKey: pkResult.rows[0],
    foreignKeys: fkResult.rows
  };
}

async function buildCreateTableStatement(tableName, schema, columns, constraints) {
  // Base table creation without foreign keys
  let baseTableSql = `CREATE TABLE IF NOT EXISTS "${schema}"."${tableName}" (\n  ${columns.join(',\n  ')}`;
  
  // Add primary key constraint
  if (constraints.primaryKey) {
    baseTableSql += `,\n  CONSTRAINT "${constraints.primaryKey.constraint_name}" PRIMARY KEY (${constraints.primaryKey.columns})`;
  }
  
  baseTableSql += '\n)';

  // Generate separate ALTER TABLE statements for foreign keys with IF NOT EXISTS check
  const foreignKeySql = constraints.foreignKeys.map(fk => `
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = '${fk.constraint_name}'
        AND table_schema = '${schema}'
        AND table_name = '${tableName}'
      ) THEN
        ALTER TABLE "${schema}"."${tableName}" 
        ADD CONSTRAINT "${fk.constraint_name}" 
        FOREIGN KEY ("${fk.column_name}") 
        REFERENCES "${fk.foreign_table_schema}"."${fk.foreign_table_name}" ("${fk.foreign_column_name}") 
        ON UPDATE ${fk.update_rule} 
        ON DELETE ${fk.delete_rule};
      END IF;
    END
    $$;
  `);

  return {
    baseTableSql,
    foreignKeySql
  };
}

async function sortTablesByDependencies(client, tables) {
  const dependencies = {};
  const visited = new Set();
  const sorted = [];
  const visiting = new Set();

  // Build dependency graph
  for (const table of tables) {
    const key = `${table.table_schema}.${table.table_name}`;
    const deps = await getForeignKeyDependencies(client, table.table_name, table.table_schema);
    dependencies[key] = deps;
  }

  // Topological sort with cycle detection
  function visit(tableKey) {
    if (visiting.has(tableKey)) {
      throw new Error(`Circular dependency detected involving table ${tableKey}`);
    }
    if (visited.has(tableKey)) {
      return;
    }

    visiting.add(tableKey);

    for (const dep of dependencies[tableKey] || []) {
      visit(dep);
    }

    visiting.delete(tableKey);
    visited.add(tableKey);
    sorted.unshift(tableKey);
  }

  // Visit all tables
  for (const table of tables) {
    const key = `${table.table_schema}.${table.table_name}`;
    try {
      visit(key);
    } catch (error) {
      if (error.message.includes('Circular dependency')) {
        console.warn(`Warning: ${error.message}. Will proceed with best-effort ordering.`);
      } else {
        throw error;
      }
    }
  }

  // Convert back to table objects
  return sorted.map(key => {
    const [schema, name] = key.split('.');
    return { table_schema: schema, table_name: name };
  });
}

async function getForeignKeyDependencies(client, tableName, schema) {
  const result = await client.query(`
    SELECT DISTINCT
      ccu.table_schema AS foreign_table_schema,
      ccu.table_name AS foreign_table_name
    FROM 
      information_schema.table_constraints AS tc 
      JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = $1
    AND tc.table_schema = $2
  `, [tableName, schema]);
  
  return result.rows.map(row => `${row.foreign_table_schema}.${row.foreign_table_name}`);
}

function formatValue(val, type) {
  if (val === null) return 'NULL';
  
  // Handle special data types
  if (type) {
    // Handle JSONB array type
    if (type.dataType === 'jsonb[]') {
      if (Array.isArray(val)) {
        return `ARRAY[${val.map(v => `'${JSON.stringify(v)}'::jsonb`).join(',')}]`;
      }
      return `ARRAY['${JSON.stringify(val)}'::jsonb]`;
    }
    
    // Handle JSONB type
    if (type.dataType === 'jsonb') {
      if (typeof val === 'string') {
        try {
          // Try to parse string as JSON
          JSON.parse(val);
          return `'${val}'::jsonb`;
        } catch (e) {
          // If not valid JSON, convert to JSONB array
          return `'[${val}]'::jsonb`;
        }
      }
      // Handle array of objects for JSONB
      if (Array.isArray(val)) {
        return `'${JSON.stringify(val)}'::jsonb`;
      }
      return `'${JSON.stringify(val)}'::jsonb`;
    }
    
    // Handle array types
    if (type.dataType === 'array' || type.dataType === 'text[]') {
      if (Array.isArray(val)) {
        if (val.length === 0) {
          // Use the base type from udtName for empty arrays
          return `'{}'::${type.udtName}`;
        }
        // Properly escape and quote array elements
        const escapedValues = val.map(v => {
          if (v === null) return 'NULL';
          if (typeof v === 'string') {
            // Escape quotes and backslashes
            return `"${v.replace(/"/g, '\\"').replace(/\\/g, '\\\\')}"`;
          }
          return v;
        });
        return `ARRAY[${escapedValues.join(',')}]::${type.udtName}`;
      }
      // If not an array but should be, make it one
      return `ARRAY[${formatValue(val)}]::${type.udtName}`;
    }
  }

  // Handle basic types
  if (typeof val === 'string') {
    // Handle date strings
    if (val.match(/^\d{4}-\d{2}-\d{2}$/)) {
      return `DATE '${val}'`;
    }
    // Handle timestamp strings
    if (val.match(/^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}/)) {
      return `TIMESTAMP '${val}'`;
    }
    // Handle regular strings
    return `'${val.replace(/'/g, "''")}'`;
  }
  
  if (Array.isArray(val)) {
    return `ARRAY[${val.map(v => formatValue(v)).join(',')}]`;
  }
  
  if (typeof val === 'object' && val !== null) {
    return `'${JSON.stringify(val)}'`;
  }
  
  return val;
}

async function migrateTableData(tableName, schema) {
  const batchSize = 1000;
  let offset = 0;
  let total = 0;

  // Get column types first
  const columnTypes = await devPool.query(`
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns
    WHERE table_schema = $1 AND table_name = $2
    ORDER BY ordinal_position
  `, [schema, tableName]);

  const typeMap = {};
  const validColumns = new Set();
  for (const col of columnTypes.rows) {
    typeMap[col.column_name] = {
      dataType: col.data_type.toLowerCase(),
      udtName: col.udt_name
    };
    validColumns.add(col.column_name);
  }

  while (true) {
    // Get a batch of data
    const result = await devPool.query(`
      SELECT *
      FROM "${schema}"."${tableName}"
      ORDER BY 1
      LIMIT ${batchSize}
      OFFSET ${offset}
    `);

    if (result.rows.length === 0) {
      break;
    }

    // Insert the batch into production
    if (result.rows.length > 0) {
      // Only include columns that exist in the target table
      const columns = Object.keys(result.rows[0]).filter(col => validColumns.has(col));
      
      try {
        // Process each row individually for better error handling
        for (const row of result.rows) {
          const values = columns.map(col => formatValue(row[col], typeMap[col]));
          
          try {
            await prodPool.query(`
              INSERT INTO "${schema}"."${tableName}" (${columns.map(c => `"${c}"`).join(',')})
              VALUES (${values.join(',')})
              ON CONFLICT DO NOTHING
            `);
            
            total++;
            if (total % 100 === 0) {
              console.log(`Migrated ${total} rows for ${schema}.${tableName}`);
            }
          } catch (rowError) {
            console.error(`Error migrating row in ${schema}.${tableName}:`, rowError.message);
            console.error('Row data:', row);
            console.error('Formatted values:', values);
            // Continue with next row
          }
        }
        
        console.log(`Migrated ${total} rows for ${schema}.${tableName}`);
      } catch (error) {
        console.error(`Error migrating data for ${schema}.${tableName}:`, error.message);
        console.error('Column types:', typeMap);
        console.error('Valid columns:', Array.from(validColumns));
        throw error;
      }
    }

    offset += batchSize;
  }
}

module.exports = {
  getDataType,
  buildColumnDefinition,
  getTableConstraints,
  buildCreateTableStatement,
  sortTablesByDependencies,
  getForeignKeyDependencies,
  migrateTableData,
  devPool,
  prodPool
}; 
 
const config = require('./config');

// Initialize connection pools
const devPool = new Pool(config.development.database);
const prodPool = new Pool(config.production.database);

function getDataType(column) {
  // Handle array types
  if (column.data_type === 'ARRAY') {
    const baseType = column.udt_name.replace('_', '');
    return `${baseType}[]`;
  }
  
  // Handle user-defined types
  if (column.data_type === 'USER-DEFINED') {
    if (column.udt_schema === 'public') {
      return column.udt_name;
    }
    return `${column.udt_schema}.${column.udt_name}`;
  }
  
  // Handle character types
  if (column.data_type.startsWith('character')) {
    if (column.character_maximum_length) {
      return `${column.data_type}(${column.character_maximum_length})`;
    }
    return column.data_type;
  }
  
  // Handle numeric types
  if (column.data_type === 'numeric' && (column.numeric_precision || column.numeric_scale)) {
    if (column.numeric_scale) {
      return `numeric(${column.numeric_precision},${column.numeric_scale})`;
    }
    return `numeric(${column.numeric_precision})`;
  }
  
  return column.data_type;
}

function buildColumnDefinition(column, dataType) {
  let def = `"${column.column_name}" ${dataType}`;
  
  // Add nullability
  if (column.is_nullable === 'NO') {
    def += ' NOT NULL';
  }
  
  // Add default value
  if (column.column_default !== null) {
    if (column.column_default.includes('nextval')) {
      if (dataType === 'bigint') {
        def = def.replace(dataType, 'BIGSERIAL');
      } else {
        def = def.replace(dataType, 'SERIAL');
      }
    } else {
      def += ` DEFAULT ${column.column_default}`;
    }
  }
  
  return def;
}

async function getTableConstraints(client, tableName, schema) {
  // Get primary key constraints
  const pkResult = await client.query(`
    SELECT 
      c.conname as constraint_name,
      string_agg(a.attname, ', ') as columns
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_namespace n ON t.relnamespace = n.oid
    JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(c.conkey)
    WHERE c.contype = 'p' 
    AND t.relname = $1 
    AND n.nspname = $2
    GROUP BY c.conname
  `, [tableName, schema]);

  // Get foreign key constraints
  const fkResult = await client.query(`
    SELECT
      tc.constraint_name,
      kcu.column_name,
      ccu.table_schema AS foreign_table_schema,
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
      JOIN information_schema.referential_constraints AS rc
        ON rc.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = $1
    AND tc.table_schema = $2;
  `, [tableName, schema]);

  return {
    primaryKey: pkResult.rows[0],
    foreignKeys: fkResult.rows
  };
}

async function buildCreateTableStatement(tableName, schema, columns, constraints) {
  // Base table creation without foreign keys
  let baseTableSql = `CREATE TABLE IF NOT EXISTS "${schema}"."${tableName}" (\n  ${columns.join(',\n  ')}`;
  
  // Add primary key constraint
  if (constraints.primaryKey) {
    baseTableSql += `,\n  CONSTRAINT "${constraints.primaryKey.constraint_name}" PRIMARY KEY (${constraints.primaryKey.columns})`;
  }
  
  baseTableSql += '\n)';

  // Generate separate ALTER TABLE statements for foreign keys with IF NOT EXISTS check
  const foreignKeySql = constraints.foreignKeys.map(fk => `
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = '${fk.constraint_name}'
        AND table_schema = '${schema}'
        AND table_name = '${tableName}'
      ) THEN
        ALTER TABLE "${schema}"."${tableName}" 
        ADD CONSTRAINT "${fk.constraint_name}" 
        FOREIGN KEY ("${fk.column_name}") 
        REFERENCES "${fk.foreign_table_schema}"."${fk.foreign_table_name}" ("${fk.foreign_column_name}") 
        ON UPDATE ${fk.update_rule} 
        ON DELETE ${fk.delete_rule};
      END IF;
    END
    $$;
  `);

  return {
    baseTableSql,
    foreignKeySql
  };
}

async function sortTablesByDependencies(client, tables) {
  const dependencies = {};
  const visited = new Set();
  const sorted = [];
  const visiting = new Set();

  // Build dependency graph
  for (const table of tables) {
    const key = `${table.table_schema}.${table.table_name}`;
    const deps = await getForeignKeyDependencies(client, table.table_name, table.table_schema);
    dependencies[key] = deps;
  }

  // Topological sort with cycle detection
  function visit(tableKey) {
    if (visiting.has(tableKey)) {
      throw new Error(`Circular dependency detected involving table ${tableKey}`);
    }
    if (visited.has(tableKey)) {
      return;
    }

    visiting.add(tableKey);

    for (const dep of dependencies[tableKey] || []) {
      visit(dep);
    }

    visiting.delete(tableKey);
    visited.add(tableKey);
    sorted.unshift(tableKey);
  }

  // Visit all tables
  for (const table of tables) {
    const key = `${table.table_schema}.${table.table_name}`;
    try {
      visit(key);
    } catch (error) {
      if (error.message.includes('Circular dependency')) {
        console.warn(`Warning: ${error.message}. Will proceed with best-effort ordering.`);
      } else {
        throw error;
      }
    }
  }

  // Convert back to table objects
  return sorted.map(key => {
    const [schema, name] = key.split('.');
    return { table_schema: schema, table_name: name };
  });
}

async function getForeignKeyDependencies(client, tableName, schema) {
  const result = await client.query(`
    SELECT DISTINCT
      ccu.table_schema AS foreign_table_schema,
      ccu.table_name AS foreign_table_name
    FROM 
      information_schema.table_constraints AS tc 
      JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
    WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = $1
    AND tc.table_schema = $2
  `, [tableName, schema]);
  
  return result.rows.map(row => `${row.foreign_table_schema}.${row.foreign_table_name}`);
}

function formatValue(val, type) {
  if (val === null) return 'NULL';
  
  // Handle special data types
  if (type) {
    // Handle JSONB array type
    if (type.dataType === 'jsonb[]') {
      if (Array.isArray(val)) {
        return `ARRAY[${val.map(v => `'${JSON.stringify(v)}'::jsonb`).join(',')}]`;
      }
      return `ARRAY['${JSON.stringify(val)}'::jsonb]`;
    }
    
    // Handle JSONB type
    if (type.dataType === 'jsonb') {
      if (typeof val === 'string') {
        try {
          // Try to parse string as JSON
          JSON.parse(val);
          return `'${val}'::jsonb`;
        } catch (e) {
          // If not valid JSON, convert to JSONB array
          return `'[${val}]'::jsonb`;
        }
      }
      // Handle array of objects for JSONB
      if (Array.isArray(val)) {
        return `'${JSON.stringify(val)}'::jsonb`;
      }
      return `'${JSON.stringify(val)}'::jsonb`;
    }
    
    // Handle array types
    if (type.dataType === 'array' || type.dataType === 'text[]') {
      if (Array.isArray(val)) {
        if (val.length === 0) {
          // Use the base type from udtName for empty arrays
          return `'{}'::${type.udtName}`;
        }
        // Properly escape and quote array elements
        const escapedValues = val.map(v => {
          if (v === null) return 'NULL';
          if (typeof v === 'string') {
            // Escape quotes and backslashes
            return `"${v.replace(/"/g, '\\"').replace(/\\/g, '\\\\')}"`;
          }
          return v;
        });
        return `ARRAY[${escapedValues.join(',')}]::${type.udtName}`;
      }
      // If not an array but should be, make it one
      return `ARRAY[${formatValue(val)}]::${type.udtName}`;
    }
  }

  // Handle basic types
  if (typeof val === 'string') {
    // Handle date strings
    if (val.match(/^\d{4}-\d{2}-\d{2}$/)) {
      return `DATE '${val}'`;
    }
    // Handle timestamp strings
    if (val.match(/^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}/)) {
      return `TIMESTAMP '${val}'`;
    }
    // Handle regular strings
    return `'${val.replace(/'/g, "''")}'`;
  }
  
  if (Array.isArray(val)) {
    return `ARRAY[${val.map(v => formatValue(v)).join(',')}]`;
  }
  
  if (typeof val === 'object' && val !== null) {
    return `'${JSON.stringify(val)}'`;
  }
  
  return val;
}

async function migrateTableData(tableName, schema) {
  const batchSize = 1000;
  let offset = 0;
  let total = 0;

  // Get column types first
  const columnTypes = await devPool.query(`
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns
    WHERE table_schema = $1 AND table_name = $2
    ORDER BY ordinal_position
  `, [schema, tableName]);

  const typeMap = {};
  const validColumns = new Set();
  for (const col of columnTypes.rows) {
    typeMap[col.column_name] = {
      dataType: col.data_type.toLowerCase(),
      udtName: col.udt_name
    };
    validColumns.add(col.column_name);
  }

  while (true) {
    // Get a batch of data
    const result = await devPool.query(`
      SELECT *
      FROM "${schema}"."${tableName}"
      ORDER BY 1
      LIMIT ${batchSize}
      OFFSET ${offset}
    `);

    if (result.rows.length === 0) {
      break;
    }

    // Insert the batch into production
    if (result.rows.length > 0) {
      // Only include columns that exist in the target table
      const columns = Object.keys(result.rows[0]).filter(col => validColumns.has(col));
      
      try {
        // Process each row individually for better error handling
        for (const row of result.rows) {
          const values = columns.map(col => formatValue(row[col], typeMap[col]));
          
          try {
            await prodPool.query(`
              INSERT INTO "${schema}"."${tableName}" (${columns.map(c => `"${c}"`).join(',')})
              VALUES (${values.join(',')})
              ON CONFLICT DO NOTHING
            `);
            
            total++;
            if (total % 100 === 0) {
              console.log(`Migrated ${total} rows for ${schema}.${tableName}`);
            }
          } catch (rowError) {
            console.error(`Error migrating row in ${schema}.${tableName}:`, rowError.message);
            console.error('Row data:', row);
            console.error('Formatted values:', values);
            // Continue with next row
          }
        }
        
        console.log(`Migrated ${total} rows for ${schema}.${tableName}`);
      } catch (error) {
        console.error(`Error migrating data for ${schema}.${tableName}:`, error.message);
        console.error('Column types:', typeMap);
        console.error('Valid columns:', Array.from(validColumns));
        throw error;
      }
    }

    offset += batchSize;
  }
}

module.exports = {
  getDataType,
  buildColumnDefinition,
  getTableConstraints,
  buildCreateTableStatement,
  sortTablesByDependencies,
  getForeignKeyDependencies,
  migrateTableData,
  devPool,
  prodPool
}; 