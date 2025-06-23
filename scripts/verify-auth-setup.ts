import db from '../lib/db';
import bcrypt from 'bcryptjs';

async function verifyAuthSetup() {
  try {
    console.log('🔍 Verifying database connection and auth setup...');

    // Check if we can connect to the database
    const testConnection = await db.query('SELECT NOW()');
    console.log('✅ Database connection successful');

    // Check if users table exists
    const tableCheck = await db.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_name = 'users'
      );
    `);

    if (!tableCheck.rows[0].exists) {
      console.log('❌ Users table does not exist');
      console.log('Creating users table...');
      
      await db.query(`
        CREATE TABLE users (
          id SERIAL PRIMARY KEY,
          employee_id VARCHAR(20) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          role VARCHAR(50) NOT NULL DEFAULT 'employee',
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
      `);
      
      console.log('✅ Users table created successfully');

      // Create test user
      const testPassword = 'password123';
      const hashedPassword = await bcrypt.hash(testPassword, 10);
      
      await db.query(`
        INSERT INTO users (employee_id, password_hash, role)
        VALUES ($1, $2, $3)
        ON CONFLICT (employee_id) DO NOTHING;
      `, ['EMP-25-0001', hashedPassword, 'admin']);
      
      console.log('✅ Test user created:');
      console.log('   Employee ID: EMP-25-0001');
      console.log('   Password: password123');
      console.log('   Role: admin');
    } else {
      console.log('✅ Users table exists');
      
      // Check if test user exists
      const userCheck = await db.query('SELECT * FROM users WHERE employee_id = $1', ['EMP-25-0001']);
      
      if (userCheck.rows.length === 0) {
        console.log('Creating test user...');
        const testPassword = 'password123';
        const hashedPassword = await bcrypt.hash(testPassword, 10);
        
        await db.query(`
          INSERT INTO users (employee_id, password_hash, role)
          VALUES ($1, $2, $3);
        `, ['EMP-25-0001', hashedPassword, 'admin']);
        
        console.log('✅ Test user created:');
        console.log('   Employee ID: EMP-25-0001');
        console.log('   Password: password123');
        console.log('   Role: admin');
      } else {
        console.log('✅ Test user exists');
      }
    }

    console.log('\n🎉 Auth setup verification complete!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during verification:', error);
    process.exit(1);
  }
}

verifyAuthSetup(); 