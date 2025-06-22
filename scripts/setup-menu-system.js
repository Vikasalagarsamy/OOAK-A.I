const { Pool } = require('pg');

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak_ai_dev',
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function setupMenuSystem() {
  console.log('🚀 Setting up OOAK.AI Menu System...\n');

  try {
    // Check existing menu items
    console.log('📋 Checking existing menu items...');
    const menuResult = await pool.query(`
      SELECT id, name, path, icon, parent_id, sort_order, is_visible, string_id 
      FROM menu_items 
      ORDER BY sort_order ASC
      LIMIT 10
    `);
    
    console.log(`✅ Found ${menuResult.rowCount} menu items (showing first 10):`);
    menuResult.rows.forEach(item => {
      console.log(`   ${item.sort_order}. ${item.name} (${item.path}) - ${item.string_id}`);
    });

    // Check role permissions
    console.log('\n🔐 Checking role permissions...');
    const permResult = await pool.query(`
      SELECT rmp.role_id, COUNT(*) as permission_count
      FROM role_menu_permissions rmp
      GROUP BY rmp.role_id
      ORDER BY rmp.role_id
    `);
    
    console.log('✅ Role permissions summary:');
    permResult.rows.forEach(role => {
      console.log(`   Role ${role.role_id}: ${role.permission_count} permissions`);
    });

    // Check employees and departments
    console.log('\n👥 Checking employees and departments...');
    const empResult = await pool.query(`
      SELECT e.id, e.first_name, e.last_name, d.name as department
      FROM employees e
      LEFT JOIN departments d ON e.department_id = d.id
      WHERE e.id <= 5
      ORDER BY e.id
    `);
    
    console.log('✅ Sample employees:');
    empResult.rows.forEach(emp => {
      console.log(`   ${emp.id}. ${emp.first_name} ${emp.last_name} (${emp.department})`);
    });

    // Insert sample menu items if needed
    console.log('\n🔧 Setting up core menu items...');
    
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

    for (const menu of coreMenus) {
      // Check if menu exists
      const existing = await pool.query(
        'SELECT id FROM menu_items WHERE string_id = $1',
        [menu.string_id]
      );

      if (existing.rowCount === 0) {
        // Get parent_id if parent_string_id is provided
        let parent_id = null;
        if (menu.parent_string_id) {
          const parentResult = await pool.query(
            'SELECT id FROM menu_items WHERE string_id = $1',
            [menu.parent_string_id]
          );
          if (parentResult.rowCount > 0) {
            parent_id = parentResult.rows[0].id;
          }
        }

        // Get next ID
        const maxIdResult = await pool.query('SELECT COALESCE(MAX(id), 0) + 1 as next_id FROM menu_items');
        const nextId = maxIdResult.rows[0].next_id;

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

    // Set up basic role permissions for Sales role (role_id = 2)
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
        // Get next ID for role_menu_permissions
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

    // Set up admin permissions for Management role (role_id = 1)
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
        // Get next ID for role_menu_permissions
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

    console.log('\n🎉 Menu system setup completed successfully!');
    console.log('\n📋 Test the system:');
    console.log('   1. Visit http://localhost:3001/admin/permissions');
    console.log('   2. Test dynamic sidebar with employee ID 1 (Management)');
    console.log('   3. Test dynamic sidebar with employee ID 2 (Sales)');

  } catch (error) {
    console.error('❌ Error setting up menu system:', error);
  } finally {
    await pool.end();
  }
}

setupMenuSystem(); 