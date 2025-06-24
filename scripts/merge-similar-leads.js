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

async function mergeSimilarLeads() {
  const client = await pool.connect();
  
  try {
    // Start transaction
    await client.query('BEGIN');

    console.log('Starting lead merge process...');

    // 1. Create a temporary table to store lead groups
    await client.query(`
      CREATE TEMP TABLE lead_groups AS
      WITH contact_groups AS (
        SELECT 
          COALESCE(phone, '') as phone,
          COALESCE(email, '') as email,
          COUNT(DISTINCT id) as unique_ids
        FROM leads
        WHERE phone IS NOT NULL OR email IS NOT NULL
        GROUP BY COALESCE(phone, ''), COALESCE(email, '')
        HAVING COUNT(DISTINCT id) > 1
      ),
      ranked_leads AS (
        SELECT 
          l.*,
          ROW_NUMBER() OVER (
            PARTITION BY COALESCE(l.phone, ''), COALESCE(l.email, '')
            ORDER BY 
              CASE l.status
                WHEN 'CONVERTED' THEN 1
                WHEN 'QUALIFIED' THEN 2
                WHEN 'CONTACTED' THEN 3
                WHEN 'ASSIGNED' THEN 4
                WHEN 'UNASSIGNED' THEN 5
                WHEN 'REJECTED' THEN 6
                ELSE 7
              END,
              l.created_at DESC,
              l.id
          ) as merge_priority
        FROM leads l
        INNER JOIN contact_groups cg 
          ON COALESCE(l.phone, '') = cg.phone 
          AND COALESCE(l.email, '') = cg.email
      )
      SELECT * FROM ranked_leads
    `);

    // 2. Create a table to store merged lead history
    await client.query(`
      CREATE TABLE IF NOT EXISTS lead_merge_history (
        id SERIAL PRIMARY KEY,
        primary_lead_id INTEGER NOT NULL,
        merged_lead_id INTEGER NOT NULL,
        merge_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        merge_reason TEXT,
        original_status VARCHAR(50),
        original_assigned_to INTEGER,
        original_lead_number VARCHAR(20)
      )
    `);

    // 3. Get leads to be merged
    const mergeGroups = await client.query(`
      SELECT 
        COALESCE(phone, '') as phone,
        COALESCE(email, '') as email,
        array_agg(id ORDER BY merge_priority) as lead_ids,
        array_agg(lead_number ORDER BY merge_priority) as lead_numbers,
        array_agg(status ORDER BY merge_priority) as statuses,
        array_agg(client_name ORDER BY merge_priority) as names
      FROM lead_groups
      GROUP BY COALESCE(phone, ''), COALESCE(email, '')
      ORDER BY MIN(merge_priority)
    `);

    let totalMerged = 0;

    // 4. Process each group
    for (const group of mergeGroups.rows) {
      const primaryId = group.lead_ids[0];
      const mergedIds = group.lead_ids.slice(1);
      
      console.log(`\nProcessing group with contact: ${group.phone || group.email}`);
      console.log(`Primary lead: #${group.lead_numbers[0]} (ID: ${primaryId})`);
      console.log(`Merging leads: ${mergedIds.map((id, i) => `#${group.lead_numbers[i+1]} (ID: ${id})`).join(', ')}`);

      // Store merge history
      for (let i = 0; i < mergedIds.length; i++) {
        await client.query(`
          INSERT INTO lead_merge_history (
            primary_lead_id, 
            merged_lead_id, 
            merge_reason,
            original_status,
            original_lead_number
          )
          SELECT 
            $1,
            $2,
            'Duplicate contact information - Automated merge',
            status,
            lead_number
          FROM leads
          WHERE id = $2
        `, [primaryId, mergedIds[i]]);
      }

      // Update the primary lead with the most complete information
      await client.query(`
        UPDATE leads
        SET
          notes = CASE 
            WHEN notes IS NULL OR notes = '' 
            THEN (
              SELECT string_agg(DISTINCT notes, E'\\n\\n')
              FROM leads
              WHERE id = ANY($2) AND notes IS NOT NULL AND notes != ''
            )
            ELSE notes || E'\\n\\n' || (
              SELECT string_agg(DISTINCT notes, E'\\n\\n')
              FROM leads
              WHERE id = ANY($2) AND notes IS NOT NULL AND notes != ''
            )
          END,
          bride_name = COALESCE(bride_name, (
            SELECT bride_name 
            FROM leads 
            WHERE id = ANY($2) AND bride_name IS NOT NULL 
            LIMIT 1
          )),
          groom_name = COALESCE(groom_name, (
            SELECT groom_name 
            FROM leads 
            WHERE id = ANY($2) AND groom_name IS NOT NULL 
            LIMIT 1
          )),
          wedding_date = COALESCE(wedding_date, (
            SELECT wedding_date 
            FROM leads 
            WHERE id = ANY($2) AND wedding_date IS NOT NULL 
            LIMIT 1
          )),
          venue_preference = COALESCE(venue_preference, (
            SELECT venue_preference 
            FROM leads 
            WHERE id = ANY($2) AND venue_preference IS NOT NULL 
            LIMIT 1
          )),
          guest_count = COALESCE(guest_count, (
            SELECT guest_count 
            FROM leads 
            WHERE id = ANY($2) AND guest_count IS NOT NULL 
            LIMIT 1
          )),
          budget_range = COALESCE(budget_range, (
            SELECT budget_range 
            FROM leads 
            WHERE id = ANY($2) AND budget_range IS NOT NULL 
            LIMIT 1
          )),
          expected_value = COALESCE(expected_value, (
            SELECT expected_value 
            FROM leads 
            WHERE id = ANY($2) AND expected_value IS NOT NULL 
            LIMIT 1
          )),
          description = CASE 
            WHEN description IS NULL OR description = '' 
            THEN (
              SELECT string_agg(DISTINCT description, E'\\n\\n')
              FROM leads
              WHERE id = ANY($2) AND description IS NOT NULL AND description != ''
            )
            ELSE description || E'\\n\\n' || (
              SELECT string_agg(DISTINCT description, E'\\n\\n')
              FROM leads
              WHERE id = ANY($2) AND description IS NOT NULL AND description != ''
            )
          END,
          updated_at = CURRENT_TIMESTAMP
        WHERE id = $1
      `, [primaryId, mergedIds]);

      // Move the merged leads to backup
      await client.query(`
        INSERT INTO deleted_leads_backup
        SELECT * FROM leads
        WHERE id = ANY($1)
      `, [mergedIds]);

      // Delete the merged leads
      await client.query(`
        DELETE FROM leads
        WHERE id = ANY($1)
      `, [mergedIds]);

      totalMerged += mergedIds.length;
    }

    // 5. Drop temporary table
    await client.query('DROP TABLE lead_groups');

    // Commit transaction
    await client.query('COMMIT');

    return {
      groupsProcessed: mergeGroups.rows.length,
      leadsRemoved: totalMerged
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
    console.log('Starting lead merge process...');
    
    // Get initial count
    const initialCount = await pool.query('SELECT COUNT(*) as count FROM leads');
    console.log(`Initial lead count: ${initialCount.rows[0].count}`);

    // Merge similar leads
    const result = await mergeSimilarLeads();
    console.log('\nMerge results:');
    console.log(`- Groups processed: ${result.groupsProcessed}`);
    console.log(`- Duplicate leads merged: ${result.leadsRemoved}`);

    // Get final count
    const finalCount = await pool.query('SELECT COUNT(*) as count FROM leads');
    console.log(`\nFinal lead count: ${finalCount.rows[0].count}`);

    // Verify no more duplicates
    const duplicateCheck = await pool.query(`
      SELECT COUNT(*) as count
      FROM (
        SELECT phone, email
        FROM leads
        WHERE phone IS NOT NULL OR email IS NOT NULL
        GROUP BY phone, email
        HAVING COUNT(*) > 1
      ) dups
    `);
    
    if (duplicateCheck.rows[0].count === 0) {
      console.log('\nSuccessfully merged all duplicate leads!');
    } else {
      console.log(`\nWarning: ${duplicateCheck.rows[0].count} contact groups still have multiple leads.`);
    }

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await pool.end();
  }
}

main(); 