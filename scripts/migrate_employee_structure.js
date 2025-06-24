const { Pool } = require('pg');
const fs = require('fs').promises;
const path = require('path');

// Database configuration
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak_ai_dev'
});

async function executeMigration() {
  const client = await pool.connect();
  
  try {
    console.log('Starting employee structure migration...');
    
    // Begin transaction
    await client.query('BEGIN');
    
    // Read and execute the SQL migration file
    const sqlPath = path.join(__dirname, 'migrate_employee_assignments.sql');
    const sqlContent = await fs.readFile(sqlPath, 'utf8');
    
    // Execute migration SQL
    await client.query(sqlContent);
    
    // Verify data migration
    const { rows: assignmentCount } = await client.query(
      'SELECT COUNT(*) FROM employee_assignments'
    );
    console.log(`Migrated ${assignmentCount[0].count} employee assignments`);
    
    // Verify all employees have new company_id and branch_id
    const { rows: unmappedEmployees } = await client.query(`
      SELECT id, employee_id, first_name, last_name 
      FROM employees 
      WHERE (company_id IS NULL AND primary_company_id IS NOT NULL) 
         OR (branch_id IS NULL AND home_branch_id IS NOT NULL)
    `);
    
    if (unmappedEmployees.length > 0) {
      console.warn('Warning: Some employees were not mapped:');
      console.warn(unmappedEmployees);
    }
    
    // Commit transaction
    await client.query('COMMIT');
    console.log('Migration completed successfully');
    
    // Output next steps
    console.log('\nNext steps:');
    console.log('1. Update API endpoints to use new company_id and branch_id');
    console.log('2. Update frontend components to use new structure');
    console.log('3. After verification, remove primary_company_id and home_branch_id columns');
    
  } catch (error) {
    // Rollback on error
    await client.query('ROLLBACK');
    console.error('Migration failed:', error);
    throw error;
  } finally {
    client.release();
  }
}

// Run migration
executeMigration()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Migration failed:', error);
    process.exit(1);
  }); 