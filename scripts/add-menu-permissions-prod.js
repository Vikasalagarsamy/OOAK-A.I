const { Pool } = require('pg');

// Production database configuration
const RENDER_DATABASE_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';

const pool = new Pool({
  connectionString: RENDER_DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

async function addMenuPermissionsToProd() {
  console.log('🚀 Adding Menu Permissions to Production...\n');
  
  try {
    const client = await pool.connect();
    console.log('✅ Connected to production database');

    // 1. Add Menu Permissions under System Administration
    const result = await client.query(`
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

    if (result.rows.length > 0) {
      console.log('✅ Menu item added successfully');
      
      // 2. Add permissions for MANAGING DIRECTOR
      await client.query(`
        INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
        SELECT 
          d.id,
          $1,
          true
        FROM designations d
        WHERE d.name = 'MANAGING DIRECTOR'
        ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
      `, [result.rows[0].id]);
      
      console.log('✅ Permissions set for MANAGING DIRECTOR');
    } else {
      console.log('ℹ️ Menu item already exists');
    }

    // Verify the setup
    const verification = await client.query(`
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

    console.log('\n📋 Verification Results:');
    console.table(verification.rows);
    
    client.release();
    console.log('\n✅ Process completed successfully!');
    
  } catch (error) {
    console.error('\n❌ Error:', error.message);
  } finally {
    await pool.end();
  }
}

addMenuPermissionsToProd().catch(console.error); 