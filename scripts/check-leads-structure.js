const { Pool } = require('pg');

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: 'vikasalagarsamy',
  password: '',
  ssl: false
});

async function getLeadsStructure() {
  try {
    const result = await pool.query(`
      SELECT 
        column_name, 
        data_type,
        character_maximum_length,
        column_default,
        is_nullable
      FROM information_schema.columns 
      WHERE table_name = 'leads'
      ORDER BY ordinal_position;
    `);

    console.log('\nLeads Table Structure:');
    console.log('=====================');
    result.rows.forEach(col => {
      console.log(`${col.column_name}:`);
      console.log(`  Type: ${col.data_type}`);
      console.log(`  Max Length: ${col.character_maximum_length || 'N/A'}`);
      console.log(`  Default: ${col.column_default || 'None'}`);
      console.log(`  Nullable: ${col.is_nullable}`);
      console.log('---------------------');
    });
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await pool.end();
  }
}

getLeadsStructure(); 