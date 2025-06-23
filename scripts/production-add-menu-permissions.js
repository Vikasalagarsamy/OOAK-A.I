const { getDbPool } = require('../lib/db-production');

async function addMenuPermissionsToSystemAdmin() {
  console.log('🚀 Starting menu permissions migration in PRODUCTION...');
  const pool = getDbPool();
  
  try {
    // Start transaction
    await pool.query('BEGIN');

    console.log('👉 Adding Menu Permissions under System Administration...');
    
    // 1. Add Menu Permissions under System Administration
    const result = await pool.query(`
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
        (SELECT id FROM menu_items WHERE string_id = 'system-administration'),
        'menu-permissions',
        'Configuration',
        true,
        10,
        true
      )
      ON CONFLICT (string_id) DO NOTHING
      RETURNING id;
    `);

    console.log('👉 Setting up permissions for MANAGING DIRECTOR...');
    
    // 2. Add permissions for MANAGING DIRECTOR
    if (result.rows.length > 0) {
      await pool.query(`
        INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
        SELECT 
          d.id,
          $1,
          true
        FROM designations d
        WHERE d.name = 'MANAGING DIRECTOR'
        ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
      `, [result.rows[0].id]);
    }

    // Verify the setup
    const verification = await pool.query(`
      SELECT 
        mi.name as menu_item,
        mi.path,
        mi.section_name,
        d.name as designation,
        dmp.can_view
      FROM menu_items mi
      LEFT JOIN designation_menu_permissions dmp ON dmp.menu_item_id = mi.id
      LEFT JOIN designations d ON d.id = dmp.designation_id
      WHERE mi.string_id = 'menu-permissions';
    `);

    console.log('\n✅ Verification Results:');
    console.table(verification.rows);

    // Commit transaction
    await pool.query('COMMIT');
    
    console.log('\n✅ Successfully added Menu Permissions to System Administration in PRODUCTION');
  } catch (error) {
    // Rollback on error
    await pool.query('ROLLBACK');
    console.error('❌ Error:', error);
    throw error;
  } finally {
    // Close pool
    await pool.end();
  }
}

// Run the migration
addMenuPermissionsToSystemAdmin().catch(console.error); 