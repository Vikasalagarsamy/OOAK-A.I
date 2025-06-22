const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

// Database connection
const pool = new Pool({
  user: process.env.DB_USER || 'vikasalagarsamy',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'ooak_ai_dev',
  password: process.env.DB_PASSWORD || '',
  port: process.env.DB_PORT || 5432,
});

async function setupTestPasswords() {
  try {
    console.log('🔐 Setting up test passwords for employees...');
    
    // Get all employees
    const employees = await pool.query('SELECT employee_id, first_name, last_name FROM employees LIMIT 10');
    
    console.log(`Found ${employees.rows.length} employees to setup`);
    
    // Default password for testing
    const defaultPassword = 'password123';
    const hashedPassword = await bcrypt.hash(defaultPassword, 12);
    
    // Update employees with hashed password
    for (const employee of employees.rows) {
      await pool.query(`
        UPDATE employees 
        SET password_hash = $1 
        WHERE employee_id = $2
      `, [hashedPassword, employee.employee_id]);
      
      console.log(`✅ Set password for ${employee.employee_id} (${employee.first_name} ${employee.last_name})`);
    }
    
    console.log('\n🎉 Test data setup complete!');
    console.log('\nTest Login Credentials:');
    console.log('=======================');
    
    for (const employee of employees.rows) {
      console.log(`Employee ID: ${employee.employee_id}`);
      console.log(`Password: ${defaultPassword}`);
      console.log(`Name: ${employee.first_name} ${employee.last_name}`);
      console.log('---');
    }
    
    console.log('\n🚀 You can now test the authentication system!');
    console.log('Visit: http://localhost:3004/login');
    
  } catch (error) {
    console.error('❌ Error setting up test data:', error);
  } finally {
    process.exit(0);
  }
}

setupTestPasswords(); 