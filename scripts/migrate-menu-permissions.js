const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

async function migrateMenuPermissions() {
  console.log('🚀 Starting OOAK.AI Menu Permissions Migration...');
  
  // Get production environment variables
  const dbUrl = process.env.DATABASE_URL;
  const dbHost = process.env.POSTGRES_HOST;
  const dbPort = process.env.POSTGRES_PORT || '5432';
  const dbName = process.env.POSTGRES_DB;
  const dbUser = process.env.POSTGRES_USER;
  const dbPassword = process.env.POSTGRES_PASSWORD;
  
  if (!dbUrl && (!dbHost || !dbName || !dbUser)) {
    console.error('❌ Missing database configuration. Please set DATABASE_URL or individual DB environment variables.');
    process.exit(1);
  }
  
  try {
    console.log('✅ Production database configuration found');
    console.log(`🗄️  Database: ${dbName || 'from DATABASE_URL'}`);
    console.log(`🌐 Host: ${dbHost || 'from DATABASE_URL'}`);
    
    // Read the menu permissions schema
    const schemaFile = path.join(__dirname, '../schema.sql');
    const schemaContent = fs.readFileSync(schemaFile, 'utf8');
    
    // Execute the schema
    if (dbUrl) {
      execSync(`psql "${dbUrl}" -c "${schemaContent}"`, { stdio: 'inherit' });
    } else {
      const pgConnStr = `postgresql://${dbUser}:${dbPassword}@${dbHost}:${dbPort}/${dbName}`;
      execSync(`psql "${pgConnStr}" -c "${schemaContent}"`, { stdio: 'inherit' });
    }
    
    console.log('✅ Menu permissions schema created successfully!');
    
    // Insert default menu items
    const defaultMenuItems = `
      -- Core menu items
      INSERT INTO menu_items (name, path, icon, parent_id, sort_order, is_active) VALUES
      ('Sales', '/sales', 'TrendingUp', NULL, 1, true),
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
    
    if (dbUrl) {
      execSync(`psql "${dbUrl}" -c "${defaultMenuItems}"`, { stdio: 'inherit' });
    } else {
      const pgConnStr = `postgresql://${dbUser}:${dbPassword}@${dbHost}:${dbPort}/${dbName}`;
      execSync(`psql "${pgConnStr}" -c "${defaultMenuItems}"`, { stdio: 'inherit' });
    }
    
    console.log('✅ Default menu items and permissions created!');
    console.log('🎉 Menu permissions migration completed successfully!');
    
  } catch (error) {
    console.error('❌ Menu permissions migration failed:', error.message);
    console.error('💡 Make sure the database is accessible and credentials are correct');
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  migrateMenuPermissions();
}

module.exports = { migrateMenuPermissions }; 