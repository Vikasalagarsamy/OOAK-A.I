const { query } = require('../lib/db');
const fs = require('fs');
const path = require('path');

async function applyMigration() {
  try {
    console.log('Starting lead assignment migration...');
    
    // Read the SQL file
    const sqlPath = path.join(__dirname, 'add_lead_assignment_columns.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    // Execute the SQL
    const result = await query(sql);
    
    if (result.success) {
      console.log('Successfully added lead assignment columns');
    } else {
      console.error('Error applying migration:', result.error);
      process.exit(1);
    }
    
    // Verify the columns were added
    const verifyResult = await query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'leads' 
      AND column_name IN ('assigned_to', 'assigned_by', 'assigned_at', 'status');
    `);
    
    if (verifyResult.success && verifyResult.data) {
      console.log('Verified columns:', verifyResult.data);
    } else {
      console.error('Error verifying columns:', verifyResult.error);
      process.exit(1);
    }
    
    console.log('Migration completed successfully');
    process.exit(0);
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  }
}

applyMigration(); 