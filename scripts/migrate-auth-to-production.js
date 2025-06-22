const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

// Production database connection
const productionPool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: {
    rejectUnauthorized: false
  }
});

async function migrateAuthenticationSchema() {
  console.log('🔐 Starting Authentication Schema Migration to Production...\n');
  
  try {
    // 1. Add password_hash column if it doesn't exist
    console.log('1️⃣ Adding password_hash column to employees table...');
    await productionPool.query(`
      ALTER TABLE employees 
      ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255);
    `);
    console.log('✅ password_hash column added/verified\n');

    // 2. Update employee status to 'active' for null values
    console.log('2️⃣ Setting employee status to active...');
    const statusResult = await productionPool.query(`
      UPDATE employees 
      SET status = 'active' 
      WHERE status IS NULL OR status = '';
    `);
    console.log(`✅ Updated ${statusResult.rowCount} employee status records\n`);

    // 3. Check existing employees
    console.log('3️⃣ Checking existing employees...');
    const employeesResult = await productionPool.query(`
      SELECT employee_id, first_name, last_name, status, 
             password_hash IS NOT NULL as has_password
      FROM employees 
      ORDER BY employee_id 
      LIMIT 10;
    `);
    
    console.log(`Found ${employeesResult.rows.length} employees:`);
    employeesResult.rows.forEach(emp => {
      console.log(`  ${emp.employee_id}: ${emp.first_name} ${emp.last_name} (Status: ${emp.status}, Password: ${emp.has_password ? 'Yes' : 'No'})`);
    });
    console.log('');

    // 4. Set up test passwords for authentication testing
    console.log('4️⃣ Setting up test passwords...');
    const testEmployees = [
      'EMP-25-0008', // Accounts Manager
      'EMP-25-0027', // Sales Head  
      'EMP-25-0039'  // Sales Executive
    ];

    const defaultPassword = 'password123';
    const hashedPassword = await bcrypt.hash(defaultPassword, 12);

    let passwordsSet = 0;
    for (const employeeId of testEmployees) {
      const result = await productionPool.query(`
        UPDATE employees 
        SET password_hash = $1 
        WHERE employee_id = $2
        RETURNING employee_id, first_name, last_name;
      `, [hashedPassword, employeeId]);

      if (result.rows.length > 0) {
        const emp = result.rows[0];
        console.log(`✅ Set password for ${emp.employee_id}: ${emp.first_name} ${emp.last_name}`);
        passwordsSet++;
      } else {
        console.log(`⚠️  Employee ${employeeId} not found`);
      }
    }
    console.log(`\n✅ Set passwords for ${passwordsSet} test employees\n`);

    // 5. Verify designations exist
    console.log('5️⃣ Verifying designations...');
    const designationsResult = await productionPool.query(`
      SELECT d.name, COUNT(e.id) as employee_count
      FROM designations d
      LEFT JOIN employees e ON d.id = e.designation_id
      WHERE d.name IN ('SALES HEAD', 'SALES EXECUTIVE', 'ACCOUNTS MANAGER', 'ADMIN MANAGER')
      GROUP BY d.id, d.name
      ORDER BY employee_count DESC;
    `);

    console.log('Key designations:');
    designationsResult.rows.forEach(des => {
      console.log(`  ${des.name}: ${des.employee_count} employees`);
    });
    console.log('');

    // 6. Final verification
    console.log('6️⃣ Final verification...');
    const verificationResult = await productionPool.query(`
      SELECT 
        COUNT(*) as total_employees,
        COUNT(CASE WHEN password_hash IS NOT NULL THEN 1 END) as employees_with_passwords,
        COUNT(CASE WHEN status = 'active' THEN 1 END) as active_employees
      FROM employees;
    `);

    const stats = verificationResult.rows[0];
    console.log('📊 Production Database Stats:');
    console.log(`  Total Employees: ${stats.total_employees}`);
    console.log(`  With Passwords: ${stats.employees_with_passwords}`);
    console.log(`  Active Status: ${stats.active_employees}`);
    console.log('');

    console.log('🎉 Authentication Schema Migration Completed Successfully!\n');
    
    console.log('🧪 Test Credentials for Production:');
    console.log('===================================');
    console.log('Employee ID: EMP-25-0008 (Accounts Manager)');
    console.log('Employee ID: EMP-25-0027 (Sales Head)');
    console.log('Employee ID: EMP-25-0039 (Sales Executive)');
    console.log('Password: password123 (for all test accounts)');
    console.log('');
    
    console.log('🚀 Ready to test authentication on production!');
    console.log('Visit your Render app URL and try logging in.');

  } catch (error) {
    console.error('❌ Migration failed:', error);
    console.error('Error details:', error.message);
  } finally {
    await productionPool.end();
    process.exit(0);
  }
}

// Run migration
migrateAuthenticationSchema(); 