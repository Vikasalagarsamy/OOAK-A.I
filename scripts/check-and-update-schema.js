const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

async function waitForDatabase(pool, maxAttempts = 30, delaySeconds = 2) {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      console.log(`Attempt ${attempt}/${maxAttempts} to connect to database...`);
      await pool.query('SELECT 1');
      console.log('✅ Database is ready!');
      return true;
    } catch (error) {
      console.log(`Database not ready (${error.message}), waiting ${delaySeconds} seconds...`);
      await new Promise(resolve => setTimeout(resolve, delaySeconds * 1000));
    }
  }
  throw new Error(`Database not available after ${maxAttempts} attempts`);
}

async function checkAndUpdateSchema() {
  console.log('🔍 Starting database schema check...');
  console.log('Current working directory:', process.cwd());
  console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Present' : 'Missing');

  if (!process.env.DATABASE_URL) {
    console.error('❌ DATABASE_URL environment variable is not set');
    process.exit(1);
  }

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

    // Wait for database to be ready
    await waitForDatabase(pool);

    // List all tables in public schema
    console.log('Listing existing tables...');
    const tablesResult = await pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
      ORDER BY table_name;
    `);
    console.log('Existing tables:', tablesResult.rows.map(r => r.table_name));

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

      // Create bookings table if it doesn't exist
      console.log('Creating bookings table...');
      await pool.query(`
        CREATE TABLE IF NOT EXISTS bookings (
          id SERIAL PRIMARY KEY,
          lead_id INTEGER NOT NULL,
          client_id INTEGER NOT NULL,
          event_date DATE NOT NULL,
          status VARCHAR(50) NOT NULL DEFAULT 'pending',
          total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        
        -- Add indexes
        CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
        CREATE INDEX IF NOT EXISTS idx_bookings_event_date ON bookings(event_date);
        CREATE INDEX IF NOT EXISTS idx_bookings_lead_id ON bookings(lead_id);
        CREATE INDEX IF NOT EXISTS idx_bookings_client_id ON bookings(client_id);
      `);
      console.log('✅ Bookings table created successfully!');

    } catch (err) {
      console.error('❌ Error reading or parsing schema file:', err);
      throw err;
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