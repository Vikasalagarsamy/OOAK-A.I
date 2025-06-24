const { Pool } = require('pg');

// Database configuration
const dbConfig = {
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: 'vikasalagarsamy',
  password: ''
};

const pool = new Pool(dbConfig);

async function cleanupDuplicateLeads() {
  const client = await pool.connect();
  
  try {
    // Start transaction
    await client.query('BEGIN');

    console.log('Starting duplicate cleanup process...');

    // 1. Create a temporary table to store unique leads
    await client.query(`
      CREATE TEMP TABLE unique_leads AS
      WITH ranked_duplicates AS (
        SELECT 
          *,
          ROW_NUMBER() OVER (
            PARTITION BY lead_number, client_name, status
            ORDER BY id ASC
          ) as rn
        FROM leads
      )
      SELECT * FROM ranked_duplicates WHERE rn = 1
    `);

    // 2. Get count of duplicates to be removed
    const duplicateCount = await client.query(`
      SELECT COUNT(*) as count 
      FROM leads l 
      WHERE NOT EXISTS (
        SELECT 1 FROM unique_leads ul 
        WHERE ul.id = l.id
      )
    `);

    console.log(`Found ${duplicateCount.rows[0].count} exact duplicate leads to remove`);

    // 3. Create backup of leads to be deleted
    await client.query(`
      INSERT INTO deleted_leads_backup
      SELECT l.* 
      FROM leads l 
      WHERE NOT EXISTS (
        SELECT 1 FROM unique_leads ul 
        WHERE ul.id = l.id
      )
    `);

    // 4. Delete duplicates
    const deleteResult = await client.query(`
      DELETE FROM leads l 
      WHERE NOT EXISTS (
        SELECT 1 FROM unique_leads ul 
        WHERE ul.id = l.id
      )
      RETURNING id
    `);

    console.log(`Successfully removed ${deleteResult.rowCount} exact duplicate leads`);
    
    // 5. Drop temporary table
    await client.query('DROP TABLE unique_leads');

    // Commit transaction
    await client.query('COMMIT');

    return {
      exactDuplicatesFound: duplicateCount.rows[0].count,
      exactDuplicatesRemoved: deleteResult.rowCount
    };

  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    console.log('Starting lead deduplication process...');
    
    // Get initial count
    const initialCount = await pool.query('SELECT COUNT(*) as count FROM leads');
    console.log(`Initial lead count: ${initialCount.rows[0].count}`);

    // Clean up duplicates
    const result = await cleanupDuplicateLeads();
    console.log('\nDeduplication results:');
    console.log(`- Exact duplicates found and removed: ${result.exactDuplicatesRemoved}`);

    // Get final count
    const finalCount = await pool.query('SELECT COUNT(*) as count FROM leads');
    console.log(`\nFinal lead count: ${finalCount.rows[0].count}`);

    // Verify no more duplicates
    const duplicateCheck = await pool.query(`
      SELECT 
        lead_number,
        client_name,
        status,
        COUNT(*) as count
      FROM leads
      GROUP BY lead_number, client_name, status
      HAVING COUNT(*) > 1
      ORDER BY count DESC
    `);
    
    if (duplicateCheck.rows.length === 0) {
      console.log('\nSuccessfully removed all exact duplicates!');
    } else {
      console.log(`\nWarning: Found ${duplicateCheck.rows.length} leads that still have exact duplicates:`);
      duplicateCheck.rows.forEach(dup => {
        console.log(`- Lead #${dup.lead_number} (${dup.client_name}) - Status: ${dup.status} - ${dup.count} copies`);
      });
    }

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await pool.end();
  }
}

main(); 