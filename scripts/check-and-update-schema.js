const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

async function checkAndUpdateSchema() {
  console.log('🔍 Checking database schema...');

  // Initialize the connection pool
  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false // Required for Render's SSL
    }
  });

  try {
    // Check if menu_items table exists
    const tableCheck = await pool.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'menu_items'
      );
    `);

    if (!tableCheck.rows[0].exists) {
      console.log('⚠️ Menu permissions tables not found. Creating schema...');
      
      // Read and execute schema file
      const schemaPath = path.join(__dirname, '../schema.sql');
      const schemaSQL = fs.readFileSync(schemaPath, 'utf8');
      
      await pool.query(schemaSQL);
      console.log('✅ Schema created successfully!');

      // Insert default menu items
      const defaultMenuItems = `
        -- Core menu items
        INSERT INTO menu_items (name, path, icon, parent_id, sort_order, is_active) VALUES
        ('Dashboard', '/dashboard', 'LayoutDashboard', NULL, 1, true),
        ('Sales', '/sales', 'TrendingUp', NULL, 2, true),
        ('Leads', '/sales/leads', 'Users', (SELECT id FROM menu_items WHERE name = 'Sales' LIMIT 1), 1, true),
        ('Quotations', '/sales/quotations', 'FileText', (SELECT id FROM menu_items WHERE name = 'Sales' LIMIT 1), 2, true),
        ('Reports', '/reports', 'BarChart', NULL, 3, true)
        ON CONFLICT (id) DO NOTHING;
        
        -- Default permissions for SALES HEAD
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
      
      await pool.query(defaultMenuItems);
      console.log('✅ Default menu items and permissions created!');
    } else {
      console.log('✅ Menu permissions tables already exist');
      
      // Check if we need to update any existing permissions
      const permissionsCheck = await pool.query(`
        SELECT COUNT(*) 
        FROM designation_menu_permissions dmp
        JOIN designations d ON d.id = dmp.designation_id
        WHERE d.name = 'SALES HEAD';
      `);

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
    console.error('❌ Error updating schema:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

// Run if called directly
if (require.main === module) {
  checkAndUpdateSchema();
}

module.exports = { checkAndUpdateSchema }; 