import { Pool } from 'pg';
import fs from 'fs/promises';
import path from 'path';

interface TableRow {
  table_name: string;
}

interface ColumnRow {
  column_name: string;
  data_type: string;
  character_maximum_length: number | null;
  column_default: string | null;
  is_nullable: string;
}

interface PrimaryKeyRow {
  column_name: string;
}

interface ForeignKeyRow {
  constraint_name: string;
  column_name: string;
  foreign_table_name: string;
  foreign_column_name: string;
  update_rule: string;
  delete_rule: string;
}

interface IndexRow {
  indexname: string;
  indexdef: string;
}

const pool = new Pool({
  host: 'localhost',
  database: 'ooak_ai_dev',
  user: 'vikasalagarsamy',
  port: 5432
});

async function extractSchema() {
  const client = await pool.connect();
  try {
    console.log('🔍 Extracting schema from local database...');

    // Get all tables
    const tablesResult = await client.query<TableRow>(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    `);

    console.log('\n📊 Found tables:', tablesResult.rows.map(t => t.table_name).join(', '));

    let schemaSQL = '-- Auto-generated schema from local database\n\n';

    // For each table, get its structure
    for (const table of tablesResult.rows) {
      const tableName = table.table_name;
      console.log(`\n📋 Extracting structure for table: ${tableName}`);

      // Get column information
      const columnsResult = await client.query<ColumnRow>(`
        SELECT 
          column_name,
          data_type,
          character_maximum_length,
          column_default,
          is_nullable
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND table_name = $1
        ORDER BY ordinal_position;
      `, [tableName]);

      // Get primary key constraints
      const pkResult = await client.query<PrimaryKeyRow>(`
        SELECT c.column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
        JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
          AND tc.table_name = c.table_name AND ccu.column_name = c.column_name
        WHERE constraint_type = 'PRIMARY KEY'
          AND tc.table_schema = 'public'
          AND tc.table_name = $1;
      `, [tableName]);

      // Get foreign key constraints
      const fkResult = await client.query<ForeignKeyRow>(`
        SELECT
          tc.constraint_name,
          kcu.column_name,
          ccu.table_name AS foreign_table_name,
          ccu.column_name AS foreign_column_name,
          rc.update_rule,
          rc.delete_rule
        FROM information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
        JOIN information_schema.referential_constraints AS rc ON rc.constraint_name = tc.constraint_name
        WHERE constraint_type = 'FOREIGN KEY'
          AND tc.table_schema = 'public'
          AND tc.table_name = $1;
      `, [tableName]);

      // Build CREATE TABLE statement
      schemaSQL += `-- Table: ${tableName}\n`;
      schemaSQL += `CREATE TABLE IF NOT EXISTS ${tableName} (\n`;

      // Add columns
      const columnDefs = columnsResult.rows.map(col => {
        let def = `  ${col.column_name} ${col.data_type}`;
        if (col.character_maximum_length) {
          def += `(${col.character_maximum_length})`;
        }
        if (col.column_default) {
          def += ` DEFAULT ${col.column_default}`;
        }
        if (col.is_nullable === 'NO') {
          def += ' NOT NULL';
        }
        return def;
      });

      // Add primary key
      if (pkResult.rows.length > 0) {
        columnDefs.push(`  PRIMARY KEY (${pkResult.rows.map(r => r.column_name).join(', ')})`);
      }

      // Add foreign keys
      fkResult.rows.forEach(fk => {
        columnDefs.push(`  FOREIGN KEY (${fk.column_name}) REFERENCES ${fk.foreign_table_name}(${fk.foreign_column_name}) ON UPDATE ${fk.update_rule} ON DELETE ${fk.delete_rule}`);
      });

      schemaSQL += columnDefs.join(',\n');
      schemaSQL += '\n);\n\n';

      // Get indexes
      const indexesResult = await client.query<IndexRow>(`
        SELECT indexname, indexdef
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND tablename = $1
          AND indexname NOT LIKE '%_pkey';
      `, [tableName]);

      // Add indexes
      indexesResult.rows.forEach(idx => {
        schemaSQL += `${idx.indexdef};\n`;
      });

      schemaSQL += '\n';
    }

    // Write schema to file
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    await fs.writeFile(schemaPath, schemaSQL);
    console.log(`\n✅ Schema extracted and saved to schema.sql`);

  } catch (error) {
    console.error('❌ Error extracting schema:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

// Run the extraction
console.log('🚀 Starting schema extraction...');
extractSchema().catch(error => {
  console.error('❌ Fatal error:', error);
  process.exit(1);
}); 