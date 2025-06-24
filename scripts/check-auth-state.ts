import db from '../lib/db';

async function checkAuthState() {
  try {
    console.log('🔍 Checking authentication state...\n');

    // Check users table structure
    const tableCheck = await db.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'users'
    `);

    console.log('Users Table Structure:');
    if (tableCheck.success && tableCheck.data && tableCheck.data.length > 0) {
      tableCheck.data.forEach((col: any) => {
        console.log(`  - ${col.column_name}: ${col.data_type}`);
      });
    } else {
      console.log('No columns found or table does not exist');
    }

    // Check if any users exist
    const userCount = await db.query('SELECT COUNT(*) as count FROM users');
    
    if (userCount.success && userCount.data) {
      console.log(`\nTotal Users: ${userCount.data[0].count}`);
    } else {
      console.log('\nFailed to get user count');
    }

    // Check user roles
    const roleCheck = await db.query('SELECT DISTINCT role FROM users');
    
    if (roleCheck.success && roleCheck.data && roleCheck.data.length > 0) {
      console.log('\nUser Roles:');
      roleCheck.data.forEach((role: any) => {
        console.log(`  - ${role.role}`);
      });
    } else {
      console.log('\nNo roles found');
    }

  } catch (error) {
    console.error('Error checking auth state:', error);
  }
}

checkAuthState().catch(console.error); 