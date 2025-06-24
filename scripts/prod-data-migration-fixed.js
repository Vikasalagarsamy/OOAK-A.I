const { Pool } = require('pg');
const fs = require('fs/promises');
const path = require('path');

// Production database configuration
const PRODUCTION_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create production pool
const pool = new Pool(PRODUCTION_CONFIG);

async function addConstraintIfNotExists(client, table, constraint, sql) {
  try {
    await client.query(sql);
    console.log(`✅ Added constraint to ${table}`);
    return true;
  } catch (error) {
    if (error.code === '42P16' || error.message.includes('already exists')) {
      console.log(`ℹ️  Constraint already exists on ${table}`);
      return true;
    }
    console.error(`❌ Error adding constraint to ${table}:`, error.message);
    return false;
  }
}

async function runDataMigration() {
  const client = await pool.connect();
  
  try {
    // 1. Add unique constraints
    console.log('🔒 Adding constraints...');
    
    await addConstraintIfNotExists(
      client,
      'designations',
      'designations_name_key',
      'ALTER TABLE designations ADD CONSTRAINT designations_name_key UNIQUE (name)'
    );

    await addConstraintIfNotExists(
      client,
      'menu_items',
      'menu_items_string_id_key',
      'ALTER TABLE menu_items ADD CONSTRAINT menu_items_string_id_key UNIQUE (string_id)'
    );

    await addConstraintIfNotExists(
      client,
      'designation_menu_permissions',
      'designation_menu_permissions_pkey',
      'ALTER TABLE designation_menu_permissions ADD PRIMARY KEY (designation_id, menu_item_id)'
    );

    // 2. Insert MANAGING DIRECTOR designation
    console.log('📝 Adding MANAGING DIRECTOR designation...');
    const mdResult = await client.query(`
      INSERT INTO designations (name, description)
      VALUES ('MANAGING DIRECTOR', 'Managing Director of OOAK.AI')
      ON CONFLICT (name) DO NOTHING
      RETURNING id;
    `);

    // Get MD id (either from insert or existing)
    const mdIdResult = await client.query('SELECT id FROM designations WHERE name = $1', ['MANAGING DIRECTOR']);
    const mdId = mdResult.rows.length > 0 ? mdResult.rows[0].id : mdIdResult.rows[0].id;

    // 3. Insert System Administration menu item
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
        is_visible,
        created_at,
        updated_at
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
        true,
        NOW(),
        NOW()
      )
      ON CONFLICT (string_id) DO NOTHING
      RETURNING id;
    `);

    // Get System Admin id (either from insert or existing)
    const sysAdminIdResult = await client.query('SELECT id FROM menu_items WHERE string_id = $1', ['system-administration']);
    const sysAdminId = sysAdminResult.rows.length > 0 ? sysAdminResult.rows[0].id : sysAdminIdResult.rows[0].id;

    // 4. Insert Menu Permissions under System Administration
    console.log('📝 Adding Menu Permissions menu item...');
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
        is_visible,
        created_at,
        updated_at
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
        true,
        NOW(),
        NOW()
      )
      ON CONFLICT (string_id) DO NOTHING
      RETURNING id;
    `, [sysAdminId]);

    // Get Menu Permissions id (either from insert or existing)
    const menuPermIdResult = await client.query('SELECT id FROM menu_items WHERE string_id = $1', ['menu-permissions']);
    const menuPermId = menuPermResult.rows.length > 0 ? menuPermResult.rows[0].id : menuPermIdResult.rows[0].id;

    // 5. Set permissions for MANAGING DIRECTOR
    console.log('📝 Setting up permissions for MANAGING DIRECTOR...');
    await client.query(`
      INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
      VALUES ($1, $2, true)
      ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
    `, [mdId, menuPermId]);

    // 6. Verify the data
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

    console.log('\n✅ Data migration completed successfully');

  } catch (error) {
    console.error('❌ Data migration failed:', error.message);
    process.exit(1);
  } finally {
    await client.release();
    await pool.end();
  }
}

console.log('🚀 Starting Production Data Migration...\n');
runDataMigration(); 
 
const fs = require('fs/promises');
const path = require('path');

// Production database configuration
const PRODUCTION_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create production pool
const pool = new Pool(PRODUCTION_CONFIG);

async function addConstraintIfNotExists(client, table, constraint, sql) {
  try {
    await client.query(sql);
    console.log(`✅ Added constraint to ${table}`);
    return true;
  } catch (error) {
    if (error.code === '42P16' || error.message.includes('already exists')) {
      console.log(`ℹ️  Constraint already exists on ${table}`);
      return true;
    }
    console.error(`❌ Error adding constraint to ${table}:`, error.message);
    return false;
  }
}

async function runDataMigration() {
  const client = await pool.connect();
  
  try {
    // 1. Add unique constraints
    console.log('🔒 Adding constraints...');
    
    await addConstraintIfNotExists(
      client,
      'designations',
      'designations_name_key',
      'ALTER TABLE designations ADD CONSTRAINT designations_name_key UNIQUE (name)'
    );

    await addConstraintIfNotExists(
      client,
      'menu_items',
      'menu_items_string_id_key',
      'ALTER TABLE menu_items ADD CONSTRAINT menu_items_string_id_key UNIQUE (string_id)'
    );

    await addConstraintIfNotExists(
      client,
      'designation_menu_permissions',
      'designation_menu_permissions_pkey',
      'ALTER TABLE designation_menu_permissions ADD PRIMARY KEY (designation_id, menu_item_id)'
    );

    // 2. Insert MANAGING DIRECTOR designation
    console.log('📝 Adding MANAGING DIRECTOR designation...');
    const mdResult = await client.query(`
      INSERT INTO designations (name, description)
      VALUES ('MANAGING DIRECTOR', 'Managing Director of OOAK.AI')
      ON CONFLICT (name) DO NOTHING
      RETURNING id;
    `);

    // Get MD id (either from insert or existing)
    const mdIdResult = await client.query('SELECT id FROM designations WHERE name = $1', ['MANAGING DIRECTOR']);
    const mdId = mdResult.rows.length > 0 ? mdResult.rows[0].id : mdIdResult.rows[0].id;

    // 3. Insert System Administration menu item
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
        is_visible,
        created_at,
        updated_at
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
        true,
        NOW(),
        NOW()
      )
      ON CONFLICT (string_id) DO NOTHING
      RETURNING id;
    `);

    // Get System Admin id (either from insert or existing)
    const sysAdminIdResult = await client.query('SELECT id FROM menu_items WHERE string_id = $1', ['system-administration']);
    const sysAdminId = sysAdminResult.rows.length > 0 ? sysAdminResult.rows[0].id : sysAdminIdResult.rows[0].id;

    // 4. Insert Menu Permissions under System Administration
    console.log('📝 Adding Menu Permissions menu item...');
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
        is_visible,
        created_at,
        updated_at
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
        true,
        NOW(),
        NOW()
      )
      ON CONFLICT (string_id) DO NOTHING
      RETURNING id;
    `, [sysAdminId]);

    // Get Menu Permissions id (either from insert or existing)
    const menuPermIdResult = await client.query('SELECT id FROM menu_items WHERE string_id = $1', ['menu-permissions']);
    const menuPermId = menuPermResult.rows.length > 0 ? menuPermResult.rows[0].id : menuPermIdResult.rows[0].id;

    // 5. Set permissions for MANAGING DIRECTOR
    console.log('📝 Setting up permissions for MANAGING DIRECTOR...');
    await client.query(`
      INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
      VALUES ($1, $2, true)
      ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
    `, [mdId, menuPermId]);

    // 6. Verify the data
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

    console.log('\n✅ Data migration completed successfully');

  } catch (error) {
    console.error('❌ Data migration failed:', error.message);
    process.exit(1);
  } finally {
    await client.release();
    await pool.end();
  }
}

console.log('🚀 Starting Production Data Migration...\n');
runDataMigration(); 