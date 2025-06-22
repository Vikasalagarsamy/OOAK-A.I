const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

async function checkAndUpdateSchema() {
  console.log('🔍 Starting database schema check...');
  console.log('Current working directory:', process.cwd());
  console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Present' : 'Missing');

  let pool;
  try {
    // Initialize the connection pool with SSL required for Render
    pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: {
        rejectUnauthorized: false // Required for Render's SSL
      },
      // Add connection timeout
      connectionTimeoutMillis: 10000,
      query_timeout: 10000
    });

    // Test the connection
    console.log('Testing database connection...');
    const testResult = await pool.query('SELECT NOW()');
    console.log('✅ Database connection successful, server time:', testResult.rows[0].now);

    // List all tables in public schema
    console.log('Listing existing tables...');
    const tablesResult = await pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
      ORDER BY table_name;
    `);
    console.log('Existing tables:', tablesResult.rows.map(r => r.table_name));

    // Check if menu_items table exists
    console.log('Checking if menu_items table exists...');
    const tableCheck = await pool.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'menu_items'
      );
    `);

    console.log('Table check result:', tableCheck.rows[0].exists);

    if (!tableCheck.rows[0].exists) {
      console.log('⚠️ Menu permissions tables not found. Creating schema...');
      
      // Read schema file
      const schemaPath = path.join(__dirname, '../schema.sql');
      console.log('Reading schema from:', schemaPath);
      
      try {
        const schemaSQL = fs.readFileSync(schemaPath, 'utf8');
        console.log('Schema file size:', schemaSQL.length, 'bytes');
        console.log('First 500 characters of schema:', schemaSQL.substring(0, 500));
        
        // Split schema into individual statements
        const statements = schemaSQL.split(';').filter(stmt => stmt.trim());
        console.log('Number of SQL statements found:', statements.length);
        
        // Execute each statement separately
        for (let i = 0; i < statements.length; i++) {
          const stmt = statements[i].trim();
          if (stmt) {
            console.log(`Executing statement ${i + 1}/${statements.length}:`, stmt.substring(0, 100) + '...');
            try {
              await pool.query(stmt);
              console.log(`✅ Statement ${i + 1} executed successfully`);
            } catch (err) {
              console.error(`❌ Error executing statement ${i + 1}:`, err.message);
              throw err;
            }
          }
        }
        console.log('✅ Schema created successfully!');

        // Verify the tables were created
        const verifyTables = await pool.query(`
          SELECT table_name 
          FROM information_schema.tables 
          WHERE table_schema = 'public'
          ORDER BY table_name;
        `);
        
        console.log('Tables after schema creation:', verifyTables.rows.map(r => r.table_name));
      } catch (err) {
        console.error('❌ Error reading or parsing schema file:', err);
        throw err;
      }
    } else {
      console.log('✅ Menu permissions tables already exist');
    }

    console.log('🎉 Database schema check completed successfully!');
  } catch (error) {
    console.error('❌ Error in schema update:', error);
    console.error('Error details:', {
      message: error.message,
      code: error.code,
      detail: error.detail,
      where: error.where,
      schema: error.schema,
      table: error.table,
      constraint: error.constraint
    });
    throw error;
  } finally {
    if (pool) {
      console.log('Closing database connection...');
      await pool.end();
    }
  }
}

// Run if called directly
if (require.main === module) {
  checkAndUpdateSchema()
    .catch(error => {
      console.error('Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { checkAndUpdateSchema }; 