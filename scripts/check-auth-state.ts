import db from '../lib/db';

async function checkAuthState() {
  try {
    console.log('🔍 Checking authentication state...\n');

    // 1. Check users table
    const tableCheck = await db.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'users';
    `);

    console.log('Users Table Structure:');
    if (tableCheck.rows.length > 0) {
      tableCheck.rows.forEach((col: any) => {
        console.log(`  - ${col.column_name}: ${col.data_type}`);
      });
    } else {
      console.log('❌ Users table does not exist');
    }

    // 2. Check test user
    const userCheck = await db.query(
      'SELECT id, employee_id, role FROM users WHERE employee_id = $1',
      ['EMP-25-0001']
    );

    console.log('\nTest User:');
    if (userCheck.rows.length > 0) {
      const user = userCheck.rows[0];
      console.log('✅ Test user exists:');
      console.log(`  - ID: ${user.id}`);
      console.log(`  - Employee ID: ${user.employee_id}`);
      console.log(`  - Role: ${user.role}`);
    } else {
      console.log('❌ Test user not found');
    }

  } catch (error) {
    console.error('\n❌ Error:', error);
  }
}

checkAuthState(); 