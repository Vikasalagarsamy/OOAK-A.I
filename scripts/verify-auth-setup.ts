import db from '../lib/db';
import { AuthService } from '../lib/auth';

async function verifyAuthSetup() {
  try {
    console.log('🔍 Verifying authentication setup...\n');

    // Check if users table exists
    const tableCheck = await db.query<{ exists: boolean }>(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'users'
      )
    `);

    if (!tableCheck.success || !tableCheck.data || !tableCheck.data[0].exists) {
      console.log('❌ Users table does not exist');
      console.log('Creating users table...');
      
      await db.query(`
        CREATE TABLE users (
          id SERIAL PRIMARY KEY,
          employee_id VARCHAR(50) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          role VARCHAR(50) NOT NULL DEFAULT 'user',
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )
      `);
      
      console.log('✅ Users table created successfully');
    } else {
      console.log('✅ Users table exists');
    }

    // Check if test user exists
    const userCheck = await db.query<{ count: string }>(
      'SELECT COUNT(*) as count FROM users WHERE employee_id = $1',
      ['EMP-25-0001']
    );

    if (!userCheck.success || !userCheck.data || parseInt(userCheck.data[0].count) === 0) {
      console.log('\n❌ Test user does not exist');
      console.log('Creating test user...');

      const password = 'test123';
      const passwordHash = await AuthService.hashPassword(password);

      const createUser = await db.query(`
        INSERT INTO users (employee_id, password_hash, role)
        VALUES ($1, $2, $3)
        RETURNING id, employee_id, role
      `, ['EMP-25-0001', passwordHash, 'admin']);

      if (createUser.success && createUser.data && createUser.data.length > 0) {
        console.log('✅ Test user created successfully:');
        console.log(`  - ID: ${createUser.data[0].id}`);
        console.log(`  - Employee ID: ${createUser.data[0].employee_id}`);
        console.log(`  - Role: ${createUser.data[0].role}`);
        console.log(`  - Password: ${password}`);
      } else {
        throw new Error('Failed to create test user');
      }
    } else {
      console.log('\n✅ Test user exists');
    }

    console.log('\n✅ Authentication setup verified successfully');
  } catch (error) {
    console.error('\n❌ Error:', error);
    process.exit(1);
  }
}

verifyAuthSetup().catch(console.error); 