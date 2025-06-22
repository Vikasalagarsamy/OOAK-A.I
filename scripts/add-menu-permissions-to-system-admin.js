const { getDbPool } = require('../lib/db');

async function addMenuPermissionsToSystemAdmin() {
  const pool = getDbPool();
  
  try {
    // Start transaction
    await pool.query('BEGIN');

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

    // Commit transaction
    await pool.query('COMMIT');
    
    console.log('✅ Successfully added Menu Permissions to System Administration');
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