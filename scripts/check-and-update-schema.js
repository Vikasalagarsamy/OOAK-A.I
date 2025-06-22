const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

async function checkAndUpdateSchema() {
  console.log('🔍 Starting database schema check...');
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
    await pool.query('SELECT NOW()');
    console.log('✅ Database connection successful');

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
      const schemaSQL = fs.readFileSync(schemaPath, 'utf8');
      
      // Split schema into individual statements
      const statements = schemaSQL.split(';').filter(stmt => stmt.trim());
      
      // Execute each statement separately
      for (const stmt of statements) {
        if (stmt.trim()) {
          console.log('Executing statement:', stmt.trim().substring(0, 50) + '...');
          await pool.query(stmt);
        }
      }
      console.log('✅ Schema created successfully!');

      // Insert default menu items
      console.log('Creating default menu items...');
      const defaultMenuItems = `
        -- Core menu items
        INSERT INTO menu_items (name, path, icon, parent_id, sort_order, is_active) VALUES
        ('Dashboard', '/dashboard', 'LayoutDashboard', NULL, 1, true),
        ('Sales', '/sales', 'TrendingUp', NULL, 2, true),
        ('Leads', '/sales/leads', 'Users', (SELECT id FROM menu_items WHERE name = 'Sales' LIMIT 1), 1, true),
        ('Quotations', '/sales/quotations', 'FileText', (SELECT id FROM menu_items WHERE name = 'Sales' LIMIT 1), 2, true),
        ('Reports', '/reports', 'BarChart', NULL, 3, true)
        ON CONFLICT (id) DO NOTHING;
      `;
      
      await pool.query(defaultMenuItems);
      console.log('✅ Default menu items created');

      // Set up permissions for SALES HEAD
      console.log('Setting up SALES HEAD permissions...');
      const salesHeadPermissions = `
        INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
        SELECT 
          d.id as designation_id,
          mi.id as menu_item_id,
          true as can_view
        FROM designations d
        CROSS JOIN menu_items mi
        WHERE d.name = 'SALES HEAD'
        ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
      `;
      
      await pool.query(salesHeadPermissions);
      console.log('✅ SALES HEAD permissions created');

      // Verify the tables were created
      const verifyTables = await pool.query(`
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name IN ('menu_items', 'designation_menu_permissions');
      `);
      
      console.log('Created tables:', verifyTables.rows.map(r => r.table_name));
    } else {
      console.log('✅ Menu permissions tables already exist');
      
      // Check if we need to update any existing permissions
      console.log('Checking SALES HEAD permissions...');
      const permissionsCheck = await pool.query(`
        SELECT COUNT(*) 
        FROM designation_menu_permissions dmp
        JOIN designations d ON d.id = dmp.designation_id
        WHERE d.name = 'SALES HEAD';
      `);

      console.log('Current SALES HEAD permissions count:', permissionsCheck.rows[0].count);

      if (permissionsCheck.rows[0].count === 0) {
        console.log('⚠️ No permissions found for SALES HEAD. Adding default permissions...');
        
        const updatePermissions = `
          INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
          SELECT 
            d.id as designation_id,
            mi.id as menu_item_id,
            true as can_view
          FROM designations d
          CROSS JOIN menu_items mi
          WHERE d.name = 'SALES HEAD'
          ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
        `;
        
        await pool.query(updatePermissions);
        console.log('✅ Default permissions added for SALES HEAD');
      } else {
        console.log('✅ SALES HEAD permissions are already set up');
      }
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
    throw error; // Re-throw to fail the build
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