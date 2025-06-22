const { Pool } = require('pg');

// Use production database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function addProductionMenus() {
  console.log('🚀 Adding Missing Menu Items to Production...\n');

  try {
    // Core menu items to add
    const coreMenus = [
      {
        name: 'Dashboard',
        string_id: 'dashboard',
        path: '/dashboard',
        icon: 'Home',
        sort_order: 1,
        description: 'Main dashboard with AI metrics'
      },
      {
        name: 'Leads Management',
        string_id: 'leads',
        path: '/leads',
        icon: 'Users',
        sort_order: 2,
        description: 'Manage leads and conversions'
      },
      {
        name: 'Admin',
        string_id: 'admin',
        path: '/admin',
        icon: 'Settings',
        sort_order: 10,
        description: 'Administration panel'
      },
      {
        name: 'Role Permissions',
        string_id: 'admin_permissions',
        path: '/admin/permissions',
        icon: 'Shield',
        sort_order: 11,
        description: 'Manage role-based permissions',
        parent_string_id: 'admin'
      }
    ];

    // Check existing menu items
    console.log('📋 Checking existing menu items...');
    const existingMenus = await pool.query(`
      SELECT string_id FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);
    
    const existingStringIds = new Set(existingMenus.rows.map(row => row.string_id));
    console.log(`✅ Found ${existingMenus.rowCount} existing menu items in production`);

    // Add missing menu items
    console.log('\n🔧 Adding missing menu items...');
    
    for (const menu of coreMenus) {
      if (!existingStringIds.has(menu.string_id)) {
        // Get next available ID
        const maxIdResult = await pool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM menu_items');
        const nextId = maxIdResult.rows[0].next_id;

        // Handle parent_id for hierarchical items
        let parent_id = null;
        if (menu.parent_string_id) {
          const parentResult = await pool.query('SELECT id FROM menu_items WHERE string_id = $1', [menu.parent_string_id]);
          if (parentResult.rowCount > 0) {
            parent_id = parentResult.rows[0].id;
          }
        }

        await pool.query(`
          INSERT INTO menu_items (
            id, name, string_id, path, icon, sort_order, description,
            parent_id, is_visible, is_admin_only, badge_variant, 
            is_new, category, created_at, updated_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, true, $9, 'default', false, 'core', NOW(), NOW())
        `, [
          nextId,
          menu.name,
          menu.string_id,
          menu.path,
          menu.icon,
          menu.sort_order,
          menu.description,
          parent_id,
          menu.string_id.includes('admin')
        ]);
        
        console.log(`   ✅ Added menu: ${menu.name}`);
      } else {
        console.log(`   ⏭️  Menu exists: ${menu.name}`);
      }
    }

    // Add role permissions for Management role (role_id = 1)
    console.log('\n🔐 Setting up admin permissions for Management role...');
    
    const adminPermissions = [
      { menu_string_id: 'dashboard', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'leads', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'admin', can_view: true, can_add: true, can_edit: true, can_delete: true },
      { menu_string_id: 'admin_permissions', can_view: true, can_add: true, can_edit: true, can_delete: true },
    ];

    for (const perm of adminPermissions) {
      const existing = await pool.query(
        'SELECT id FROM role_menu_permissions WHERE role_id = $1 AND menu_string_id = $2',
        [1, perm.menu_string_id]
      );

      if (existing.rowCount === 0) {
        const maxPermIdResult = await pool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM role_menu_permissions');
        const nextPermId = maxPermIdResult.rows[0].next_id;

        await pool.query(`
          INSERT INTO role_menu_permissions (
            id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete,
            created_at, updated_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
        `, [nextPermId, 1, perm.menu_string_id, perm.can_view, perm.can_add, perm.can_edit, perm.can_delete]);
        
        console.log(`   ✅ Added permission: Management -> ${perm.menu_string_id}`);
      } else {
        console.log(`   ⏭️  Permission exists: Management -> ${perm.menu_string_id}`);
      }
    }

    // Add basic permissions for Sales role (role_id = 2)
    console.log('\n🔐 Setting up basic permissions for Sales role...');
    
    const salesPermissions = [
      { menu_string_id: 'dashboard', can_view: true, can_add: false, can_edit: false, can_delete: false },
      { menu_string_id: 'leads', can_view: true, can_add: true, can_edit: true, can_delete: false },
    ];

    for (const perm of salesPermissions) {
      const existing = await pool.query(
        'SELECT id FROM role_menu_permissions WHERE role_id = $1 AND menu_string_id = $2',
        [2, perm.menu_string_id]
      );

      if (existing.rowCount === 0) {
        const maxPermIdResult = await pool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM role_menu_permissions');
        const nextPermId = maxPermIdResult.rows[0].next_id;

        await pool.query(`
          INSERT INTO role_menu_permissions (
            id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete,
            created_at, updated_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
        `, [nextPermId, 2, perm.menu_string_id, perm.can_view, perm.can_add, perm.can_edit, perm.can_delete]);
        
        console.log(`   ✅ Added permission: Sales -> ${perm.menu_string_id}`);
      } else {
        console.log(`   ⏭️  Permission exists: Sales -> ${perm.menu_string_id}`);
      }
    }

    // Verify final state
    console.log('\n📊 Verifying menu setup...');
    const finalMenus = await pool.query(`
      SELECT COUNT(*) as count FROM menu_items 
      WHERE string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);
    
    const finalPerms = await pool.query(`
      SELECT COUNT(*) as count FROM role_menu_permissions 
      WHERE menu_string_id IN ('dashboard', 'leads', 'admin', 'admin_permissions')
    `);

    console.log(`✅ Production now has ${finalMenus.rows[0].count}/4 core menu items`);
    console.log(`✅ Production now has ${finalPerms.rows[0].count} core permissions`);

    console.log('\n🎉 Production menu setup completed successfully!');
    console.log('\n📋 Next steps:');
    console.log('   1. Check https://workspace.ooak.photography/demo/sidebar');
    console.log('   2. Verify all 13 menu items appear correctly');
    console.log('   3. Test role switching functionality');

  } catch (error) {
    console.error('❌ Error setting up production menus:', error);
  } finally {
    await pool.end();
  }
}

addProductionMenus(); 