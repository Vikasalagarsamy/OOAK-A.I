const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

// Add console timestamp
const log = (...args) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}]`, ...args);
};

async function waitForDatabase(pool, maxAttempts = 30, delaySeconds = 2) {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      log(`Attempt ${attempt}/${maxAttempts} to connect to database...`);
      await pool.query('SELECT 1');
      log('✅ Database is ready!');
      return true;
    } catch (error) {
      log(`Database not ready (${error.message}), waiting ${delaySeconds} seconds...`);
      await new Promise(resolve => setTimeout(resolve, delaySeconds * 1000));
    }
  }
  throw new Error(`Database not available after ${maxAttempts} attempts`);
}

async function applySchema() {
  log('🔍 Starting schema application...');
  log('Current working directory:', process.cwd());
  
  if (!process.env.DATABASE_URL) {
    throw new Error('DATABASE_URL environment variable is not set');
  }
  log('DATABASE_URL is set ✅');

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

    // First, check which tables exist
    const tables = ['menu_items', 'designation_menu_permissions', 'bookings'];
    log('Checking existing tables...');
    for (const table of tables) {
      const result = await pool.query(`
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = $1
        );
      `, [table]);
      
      log(`Table ${table}: ${result.rows[0].exists ? 'exists' : 'does not exist'}`);
    }

    // Read schema file
    const schemaPath = path.join(process.cwd(), 'schema.sql');
    log('Reading schema from:', schemaPath);
    const schema = fs.readFileSync(schemaPath, 'utf8');
    log('Schema file read successfully, size:', schema.length, 'bytes');

    // Split schema into individual statements
    const statements = schema
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0);

    log(`Found ${statements.length} SQL statements to execute`);

    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      try {
        log(`Executing statement ${i + 1}/${statements.length}...`);
        log('Statement:', statement);
        await pool.query(statement + ';');
        log('✅ Statement executed successfully');
      } catch (error) {
        log('❌ Error executing statement:', error.message);
        log('Statement:', statement);
        log('Error details:', {
          code: error.code,
          detail: error.detail,
          where: error.where,
          schema: error.schema,
          table: error.table,
          constraint: error.constraint
        });
        throw error;
      }
    }

    // Verify tables exist
    log('Verifying tables...');
    for (const table of tables) {
      const result = await pool.query(`
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = $1
        );
      `, [table]);
      
      if (result.rows[0].exists) {
        log(`✅ Table ${table} exists`);
        
        // Get table structure
        const structure = await pool.query(`
          SELECT column_name, data_type, character_maximum_length
          FROM information_schema.columns
          WHERE table_schema = 'public'
          AND table_name = $1
          ORDER BY ordinal_position;
        `, [table]);
        
        log(`Table ${table} structure:`, structure.rows);
      } else {
        log(`❌ Table ${table} does not exist`);
        throw new Error(`Table ${table} was not created successfully`);
      }
    }

    log('✅ Schema applied successfully');
  } catch (error) {
    log('❌ Schema application failed:', error);
    log('Error details:', {
      message: error.message,
      stack: error.stack
    });
    process.exit(1);
  } finally {
    if (pool) {
      await pool.end();
    }
  }
}

// Run the schema application
applySchema(); 