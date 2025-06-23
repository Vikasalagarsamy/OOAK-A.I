const { runProductionMigration, getProductionClient } = require('../lib/db-production');
const fs = require('fs/promises');
const path = require('path');

async function runDataMigration() {
  try {
    const client = await getProductionClient();

    try {
      // 1. Insert MANAGING DIRECTOR designation
      console.log('📝 Adding MANAGING DIRECTOR designation...');
      await client.query(`
        INSERT INTO designations (name, description)
        VALUES ('MANAGING DIRECTOR', 'Managing Director of OOAK.AI')
        ON CONFLICT (name) DO NOTHING
        RETURNING id;
      `);

      // 2. Insert System Administration menu item
      console.log('📝 Adding System Administration menu item...');
      const sysAdminResult = await client.query(`
        INSERT INTO menu_items (
          name, 
          path, 
          icon, 
          parent_id,
          string_id,
          section_name,
          is_admin_only,
          sort_order,
          is_visible
        )
        VALUES (
          'System Administration',
          '/admin',
          'Settings',
          NULL,
          'system-administration',
          'Administration',
          true,
          100,
          true
        )
        ON CONFLICT (string_id) DO NOTHING
        RETURNING id;
      `);

      // 3. Insert Menu Permissions under System Administration
      console.log('📝 Adding Menu Permissions menu item...');
      if (sysAdminResult.rows.length > 0) {
        const menuPermResult = await client.query(`
          INSERT INTO menu_items (
            name,
            path,
            icon,
            parent_id,
            string_id,
            section_name,
            is_admin_only,
            sort_order,
            is_visible
          )
          VALUES (
            'Menu Permissions',
            '/admin/menu-permissions',
            'Settings',
            $1,
            'menu-permissions',
            'Configuration',
            true,
            10,
            true
          )
          ON CONFLICT (string_id) DO NOTHING
          RETURNING id;
        `, [sysAdminResult.rows[0].id]);

        // 4. Set permissions for MANAGING DIRECTOR
        if (menuPermResult.rows.length > 0) {
          console.log('📝 Setting up permissions for MANAGING DIRECTOR...');
          await client.query(`
            INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
            SELECT 
              d.id,
              $1,
              true
            FROM designations d
            WHERE d.name = 'MANAGING DIRECTOR'
            ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
          `, [menuPermResult.rows[0].id]);
        }
      }

      // 5. Verify the data
      console.log('\n🔍 Verifying data...');
      
      // Check menu items
      const menuItems = await client.query(`
        SELECT 
          mi.name,
          mi.path,
          mi.section_name,
          p.name as parent_name
        FROM menu_items mi
        LEFT JOIN menu_items p ON p.id = mi.parent_id
        WHERE mi.string_id IN ('system-administration', 'menu-permissions')
        ORDER BY mi.sort_order;
      `);

      console.log('\n📋 Menu Structure:');
      console.log('===============');
      menuItems.rows.forEach(item => {
        console.log(`📦 ${item.name}`);
        console.log(`   Path: ${item.path}`);
        console.log(`   Section: ${item.section_name}`);
        console.log(`   Parent: ${item.parent_name || 'None'}`);
        console.log('---------------');
      });

      // Check permissions
      const permissions = await client.query(`
        SELECT 
          d.name as designation,
          mi.name as menu_item,
          dmp.can_view
        FROM designation_menu_permissions dmp
        JOIN designations d ON d.id = dmp.designation_id
        JOIN menu_items mi ON mi.id = dmp.menu_item_id
        WHERE mi.string_id IN ('system-administration', 'menu-permissions')
        ORDER BY d.name, mi.name;
      `);

      console.log('\n📋 Permissions:');
      console.log('============');
      permissions.rows.forEach(perm => {
        console.log(`👤 ${perm.designation}`);
        console.log(`   Menu: ${perm.menu_item}`);
        console.log(`   Can View: ${perm.can_view}`);
        console.log('---------------');
      });

    } finally {
      client.release();
    }

  } catch (error) {
    console.error('❌ Data migration failed:', error);
    process.exit(1);
  }
}

// Run the data migration
console.log('🚀 Starting Cursor Production Data Migration...\n');
runDataMigration().catch(console.error); 