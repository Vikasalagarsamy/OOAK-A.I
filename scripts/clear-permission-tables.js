const { Pool } = require('pg');
const config = require('./config');

async function clearTables() {
  const devPool = new Pool(config.development.database);

  try {
    console.log('Starting to clear permission tables...');

    // Begin transaction
    await devPool.query('BEGIN');

    // Clear role_menu_permissions
    console.log('Clearing role_menu_permissions table...');
    const permResult = await devPool.query('DELETE FROM role_menu_permissions');
    console.log(`Deleted ${permResult.rowCount} rows from role_menu_permissions`);

    // Clear role_menu_access
    console.log('Clearing role_menu_access table...');
    const accessResult = await devPool.query('DELETE FROM role_menu_access');
    console.log(`Deleted ${accessResult.rowCount} rows from role_menu_access`);

    // Commit transaction
    await devPool.query('COMMIT');
    console.log('Successfully cleared both tables!');

  } catch (error) {
    // Rollback on error
    await devPool.query('ROLLBACK');
    console.error('Error clearing tables:', error.message);
    throw error;
  } finally {
    await devPool.end();
  }
}

// Run the clear operation
clearTables().catch(console.error); 