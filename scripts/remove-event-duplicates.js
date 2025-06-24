const { Pool } = require('pg');
const config = require('./config');

async function removeDuplicateEvents() {
  const devPool = new Pool(config.development.database);

  try {
    console.log('Starting to remove duplicate events...');
    
    // Begin transaction
    await devPool.query('BEGIN');

    // Get current count
    const beforeCount = await devPool.query('SELECT COUNT(*) FROM events');
    console.log(`Total events before: ${beforeCount.rows[0].count}`);

    // Create temporary table with unique events to keep
    await devPool.query(`
      CREATE TEMP TABLE events_to_keep AS
      WITH ranked_events AS (
        SELECT id,
               event_id,
               name,
               created_at,
               updated_at,
               is_active,
               ROW_NUMBER() OVER (
                 PARTITION BY event_id, name
                 ORDER BY updated_at DESC, created_at DESC, id
               ) as rn
        FROM events
      )
      SELECT id, event_id, name, created_at, updated_at, is_active
      FROM ranked_events
      WHERE rn = 1
    `);

    // Delete all events
    await devPool.query('DELETE FROM events');

    // Reinsert unique events
    await devPool.query(`
      INSERT INTO events (id, event_id, name, created_at, updated_at, is_active)
      SELECT id, event_id, name, created_at, updated_at, is_active
      FROM events_to_keep
    `);

    // Get final count
    const afterCount = await devPool.query('SELECT COUNT(*) FROM events');
    
    // Drop temporary table
    await devPool.query('DROP TABLE events_to_keep');

    // Commit transaction
    await devPool.query('COMMIT');

    const removedCount = beforeCount.rows[0].count - afterCount.rows[0].count;
    console.log(`Removed ${removedCount} duplicate events`);
    console.log(`Total events after: ${afterCount.rows[0].count}`);

    // Get remaining events grouped by name
    const remainingEvents = await devPool.query(`
      SELECT name, COUNT(*) 
      FROM events 
      GROUP BY name 
      ORDER BY name
    `);

    console.log('\nRemaining unique events:');
    remainingEvents.rows.forEach(row => {
      console.log(`${row.name}: ${row.count} record(s)`);
    });

  } catch (error) {
    // Rollback on error
    await devPool.query('ROLLBACK');
    console.error('Error removing duplicates:', error.message);
    throw error;
  } finally {
    await devPool.end();
  }
}

// Run the duplicate removal
removeDuplicateEvents().catch(console.error); 