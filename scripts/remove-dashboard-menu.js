const { getDbPool } = require('@/lib/db');

async function removeDashboardMenu() {
  try {
    const pool = getDbPool();

    // Delete the Dashboard menu item and its permissions
    const result = await pool.query(`
      -- First delete permissions
      DELETE FROM designation_menu_permissions
      WHERE menu_item_id IN (SELECT id FROM menu_items WHERE name = 'Dashboard');
      
      -- Then delete the menu item
      DELETE FROM menu_items 
      WHERE name = 'Dashboard';

      -- Finally update sort orders
      WITH dashboard_order AS (
        SELECT sort_order 
        FROM menu_items 
        WHERE name = 'Dashboard'
      )
      UPDATE menu_items 
      SET sort_order = sort_order - 1 
      WHERE sort_order > (SELECT sort_order FROM dashboard_order);
    `);

    console.log('✅ Dashboard menu item removed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error removing dashboard menu:', error);
    process.exit(1);
  }
}

removeDashboardMenu(); 