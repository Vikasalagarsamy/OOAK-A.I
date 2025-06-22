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
  
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL environment variable is not set');
  }
  console.log('DATABASE_URL is set ✅');

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

    // Read schema file
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    console.log('Reading schema from:', schemaPath);
    const schema = fs.readFileSync(schemaPath, 'utf8');

    // Split schema into individual statements
    const statements = schema
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0);

    console.log(`Found ${statements.length} SQL statements to execute`);

    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      try {
        console.log(`Executing statement ${i + 1}/${statements.length}...`);
        await pool.query(statement + ';');
        console.log('✅ Statement executed successfully');
      } catch (error) {
        console.error('❌ Error executing statement:', error.message);
        console.error('Statement:', statement);
        throw error;
      }
    }

    // Verify tables exist
    const tables = ['menu_items', 'designation_menu_permissions', 'bookings'];
    for (const table of tables) {
      try {
        const result = await pool.query(`
          SELECT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = $1
          );
        `, [table]);
        
        if (result.rows[0].exists) {
          console.log(`✅ Table ${table} exists`);
        } else {
          console.error(`❌ Table ${table} does not exist`);
          throw new Error(`Table ${table} was not created successfully`);
        }
      } catch (error) {
        console.error(`Error checking table ${table}:`, error.message);
        throw error;
      }
    }

    console.log('✅ Schema check and update completed successfully');
  } catch (error) {
    console.error('❌ Schema check failed:', error);
    process.exit(1);
  } finally {
    if (pool) {
      await pool.end();
    }
  }
}

// Run the schema check
checkAndUpdateSchema();

module.exports = { checkAndUpdateSchema }; 