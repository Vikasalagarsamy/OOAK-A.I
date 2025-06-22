const { Pool } = require('pg');

// Production database connection
const productionPool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_URL ? { rejectUnauthorized: false } : false
});

// Local database connection  
const localPool = new Pool({
  connectionString: 'postgresql://localhost:5432/ooak_ai_dev',
  ssl: false
});

async function syncProductionMenus() {
  console.log('🚀 Syncing Menu Items from Local to Production...\n');

  try {
    // Get menu items from local database
    console.log('📋 Fetching menu items from local database...');
    const localMenus = await localPool.query(`
      SELECT id, parent_id, name, description, icon, path, sort_order, 
             is_visible, string_id, section_name, is_admin_only, 
             badge_text, badge_variant, is_new, category, created_at, updated_at
      FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
      ORDER BY sort_order
    `);

    console.log(`✅ Found ${localMenus.rowCount} core menu items in local database`);
    
    // Get current production menu items
    console.log('\n📋 Checking production database...');
    const prodMenus = await productionPool.query(`
      SELECT string_id FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);
    
    const existingProdMenus = new Set(prodMenus.rows.map(row => row.string_id));
    console.log(`✅ Found ${prodMenus.rowCount} matching menu items in production`);

    // Sync each menu item
    console.log('\n🔄 Syncing menu items...');
    for (const menu of localMenus.rows) {
      if (!existingProdMenus.has(menu.string_id)) {
        // Get next available ID in production
        const maxIdResult = await productionPool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM menu_items');
        const nextId = maxIdResult.rows[0].next_id;

        // Handle parent_id for hierarchical items
        let parent_id = null;
        if (menu.parent_id) {
          // Find parent in production by string_id
          const parentLocal = await localPool.query('SELECT string_id FROM menu_items WHERE id = $1', [menu.parent_id]);
          if (parentLocal.rowCount > 0) {
            const parentProd = await productionPool.query('SELECT id FROM menu_items WHERE string_id = $1', [parentLocal.rows[0].string_id]);
            if (parentProd.rowCount > 0) {
              parent_id = parentProd.rows[0].id;
            }
          }
        }

        await productionPool.query(`
          INSERT INTO menu_items (
            id, parent_id, name, description, icon, path, sort_order,
            is_visible, string_id, section_name, is_admin_only,
            badge_text, badge_variant, is_new, category, created_at, updated_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, NOW(), NOW())
        `, [
          nextId, parent_id, menu.name, menu.description, menu.icon, 
          menu.path, menu.sort_order, menu.is_visible, menu.string_id,
          menu.section_name, menu.is_admin_only, menu.badge_text,
          menu.badge_variant, menu.is_new, menu.category
        ]);

        console.log(`   ✅ Added to production: ${menu.name} (${menu.string_id})`);
      } else {
        console.log(`   ⏭️  Already exists: ${menu.name} (${menu.string_id})`);
      }
    }

    // Sync role permissions
    console.log('\n🔐 Syncing role permissions...');
    const localPermissions = await localPool.query(`
      SELECT role_id, menu_string_id, can_view, can_add, can_edit, can_delete
      FROM role_menu_permissions 
      WHERE menu_string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
      ORDER BY role_id, menu_string_id
    `);

    console.log(`✅ Found ${localPermissions.rowCount} permissions in local database`);

    for (const perm of localPermissions.rows) {
      // Check if permission exists in production
      const existingPerm = await productionPool.query(`
        SELECT id FROM role_menu_permissions 
        WHERE role_id = $1 AND menu_string_id = $2
      `, [perm.role_id, perm.menu_string_id]);

      if (existingPerm.rowCount === 0) {
        // Get next ID for production
        const maxPermIdResult = await productionPool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM role_menu_permissions');
        const nextPermId = maxPermIdResult.rows[0].next_id;

        await productionPool.query(`
          INSERT INTO role_menu_permissions (
            id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete,
            created_at, updated_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
        `, [nextPermId, perm.role_id, perm.menu_string_id, perm.can_view, perm.can_add, perm.can_edit, perm.can_delete]);

        console.log(`   ✅ Added permission: Role ${perm.role_id} -> ${perm.menu_string_id}`);
      } else {
        console.log(`   ⏭️  Permission exists: Role ${perm.role_id} -> ${perm.menu_string_id}`);
      }
    }

    // Verify sync
    console.log('\n📊 Verifying sync...');
    const finalProdMenus = await productionPool.query(`
      SELECT COUNT(*) as count FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);
    
    const finalProdPerms = await productionPool.query(`
      SELECT COUNT(*) as count FROM role_menu_permissions 
      WHERE menu_string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);

    console.log(`✅ Production now has ${finalProdMenus.rows[0].count} core menu items`);
    console.log(`✅ Production now has ${finalProdPerms.rows[0].count} core permissions`);

    console.log('\n🎉 Menu sync completed successfully!');
    console.log('\n📋 Next steps:');
    console.log('   1. Check https://workspace.ooak.photography/demo/sidebar');
    console.log('   2. Verify menu items appear correctly');
    console.log('   3. Test role switching functionality');

  } catch (error) {
    console.error('❌ Error syncing menus:', error);
  } finally {
    await productionPool.end();
    await localPool.end();
  }
}

syncProductionMenus(); 