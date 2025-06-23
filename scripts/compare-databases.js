const { Pool } = require('pg');

// Development database configuration
const devPool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: 'vikasalagarsamy',
  password: '',
  ssl: false
});

// Production database configuration
const prodPool = new Pool({
  user: 'ooak_admin',
  host: 'dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com',
  database: 'ooak_ai_db',
  password: 'mSglqEawN72hkoEj8tSNF5qv9vJr3U6k',
  port: 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

async function listTables(pool) {
  const result = await pool.query(`
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    ORDER BY table_name;
  `);
  return result.rows.map(row => row.table_name);
}

async function compareDesignations() {
  console.log('\n🔍 Comparing Designations:');
  console.log('========================');
  
  const devDesignations = await devPool.query('SELECT * FROM designations ORDER BY id');
  const prodDesignations = await prodPool.query('SELECT * FROM designations ORDER BY id');
  
  console.log(`Development: ${devDesignations.rows.length} designations`);
  console.log(`Production: ${prodDesignations.rows.length} designations`);
  
  // Compare MANAGING DIRECTOR specifically
  const devMD = devDesignations.rows.find(d => d.name === 'MANAGING DIRECTOR');
  const prodMD = prodDesignations.rows.find(d => d.name === 'MANAGING DIRECTOR');
  
  console.log('\nMANAGING DIRECTOR status:');
  console.log('Dev:', devMD ? '✅ Present' : '❌ Missing');
  console.log('Prod:', prodMD ? '✅ Present' : '❌ Missing');
}

async function compareMenuItems() {
  console.log('\n🔍 Comparing Menu Items:');
  console.log('=====================');
  
  const devMenus = await devPool.query(`
    SELECT id, name, path, parent_id 
    FROM menu_items 
    WHERE path IN ('/admin', '/admin/menu-permissions')
    ORDER BY id
  `);
  
  const prodMenus = await prodPool.query(`
    SELECT id, name, path, parent_id 
    FROM menu_items 
    WHERE path IN ('/admin', '/admin/menu-permissions')
    ORDER BY id
  `);
  
  console.log(`\nSystem Administration & Menu Permissions in Development:`);
  devMenus.rows.forEach(menu => {
    console.log(`- ${menu.name} (${menu.path})`);
  });
  
  console.log(`\nSystem Administration & Menu Permissions in Production:`);
  prodMenus.rows.forEach(menu => {
    console.log(`- ${menu.name} (${menu.path})`);
  });
}

async function compareMenuPermissions() {
  console.log('\n🔍 Comparing Designation Menu Permissions:');
  console.log('=====================================');
  
  // First, let's check the table structure in both databases
  console.log('\nTable Structure in Development:');
  const devStructure = await devPool.query(`
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name = 'designation_menu_permissions'
    ORDER BY column_name
  `);
  devStructure.rows.forEach(col => {
    console.log(`${col.column_name}: ${col.data_type}`);
  });
  
  console.log('\nTable Structure in Production:');
  const prodStructure = await prodPool.query(`
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name = 'designation_menu_permissions'
    ORDER BY column_name
  `);
  prodStructure.rows.forEach(col => {
    console.log(`${col.column_name}: ${col.data_type}`);
  });
  
  // Get menu item IDs for System Administration and Menu Permissions
  const menuQuery = `
    SELECT id, name, path
    FROM menu_items 
    WHERE path IN ('/admin', '/admin/menu-permissions')
  `;
  
  const devMenus = await devPool.query(menuQuery);
  const prodMenus = await prodPool.query(menuQuery);
  
  // Get MANAGING DIRECTOR permissions
  const devPerms = await devPool.query(`
    SELECT dmp.*, d.name as designation_name, mi.name as menu_name, mi.path
    FROM designation_menu_permissions dmp
    JOIN designations d ON d.id = dmp.designation_id
    JOIN menu_items mi ON mi.id = dmp.menu_item_id
    WHERE d.name = 'MANAGING DIRECTOR'
    AND mi.path IN ('/admin', '/admin/menu-permissions')
    ORDER BY mi.path
  `);
  
  const prodPerms = await prodPool.query(`
    SELECT dmp.*, d.name as designation_name, mi.name as menu_name, mi.path
    FROM designation_menu_permissions dmp
    JOIN designations d ON d.id = dmp.designation_id
    JOIN menu_items mi ON mi.id = dmp.menu_item_id
    WHERE d.name = 'MANAGING DIRECTOR'
    AND mi.path IN ('/admin', '/admin/menu-permissions')
    ORDER BY mi.path
  `);
  
  console.log('\nMANAGING DIRECTOR menu permissions:');
  console.log('Dev Menus:', devMenus.rows.length, 'found');
  devPerms.rows.forEach(perm => {
    console.log(`- ${perm.menu_name} (${perm.path}): ${perm.can_view ? '✅ Can View' : '❌ No View'}`);
  });
  
  console.log('\nProd Menus:', prodMenus.rows.length, 'found');
  prodPerms.rows.forEach(perm => {
    console.log(`- ${perm.menu_name} (${perm.path}): ${perm.can_view ? '✅ Can View' : '❌ No View'}`);
  });
}

async function compareDatabaseStructure() {
  console.log('\n🔍 Comparing Database Structure:');
  console.log('============================');
  
  const devTables = await listTables(devPool);
  const prodTables = await listTables(prodPool);
  
  console.log(`Development: ${devTables.length} tables`);
  console.log(`Production: ${prodTables.length} tables`);
  
  const missingInProd = devTables.filter(t => !prodTables.includes(t));
  const missingInDev = prodTables.filter(t => !devTables.includes(t));
  
  if (missingInProd.length > 0) {
    console.log('\nTables missing in Production:', missingInProd.join(', '));
  }
  
  if (missingInDev.length > 0) {
    console.log('\nTables missing in Development:', missingInDev.join(', '));
  }
}

async function main() {
  try {
    console.log('🚀 Starting Database Comparison...\n');
    
    await compareDatabaseStructure();
    await compareDesignations();
    await compareMenuItems();
    await compareMenuPermissions();
    
    console.log('\n✅ Comparison completed!');
  } catch (error) {
    console.error('❌ Error during comparison:', error);
  } finally {
    devPool.end();
    prodPool.end();
  }
}

main(); 