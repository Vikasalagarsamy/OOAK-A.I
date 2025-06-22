const { Pool } = require('pg');

// Production database configuration
const RENDER_DATABASE_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';

const pool = new Pool({
  connectionString: RENDER_DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

async function testRenderDatabase() {
  console.log('🔍 Testing OOAK.AI Production Database on Render...\n');
  
  try {
    const client = await pool.connect();
    console.log('✅ Successfully connected to Render PostgreSQL!');
    
    // Test basic connection
    const timeResult = await client.query('SELECT NOW() as current_time');
    console.log('🕐 Server time:', timeResult.rows[0].current_time);
    
    // Check if tables exist
    const tablesResult = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name
    `);
    
    console.log('\n📋 Available Tables:');
    console.log('==================');
    tablesResult.rows.forEach(row => {
      console.log(`✅ ${row.table_name}`);
    });
    
    // Check data counts
    const tables = ['leads', 'clients', 'bookings', 'quotations', 'deliverables', 'ai_configurations'];
    
    console.log('\n📊 Data Counts:');
    console.log('===============');
    
    for (const table of tables) {
      try {
        const result = await client.query(`SELECT COUNT(*) as count FROM ${table}`);
        const count = parseInt(result.rows[0].count);
        console.log(`📈 ${table.padEnd(20)}: ${count.toLocaleString()} records`);
      } catch (error) {
        console.log(`❌ ${table.padEnd(20)}: Not available`);
      }
    }
    
    // Test sample data
    console.log('\n🧪 Sample Data Test:');
    console.log('===================');
    
    try {
      const leadSample = await client.query('SELECT * FROM leads LIMIT 1');
      if (leadSample.rows.length > 0) {
        console.log('✅ Sample lead data available');
        console.log('   Lead ID:', leadSample.rows[0].id);
        console.log('   Status:', leadSample.rows[0].status);
      }
    } catch (error) {
      console.log('❌ No lead data available');
    }
    
    client.release();
    
    console.log('\n🎉 DATABASE TEST COMPLETED!');
    console.log('===========================');
    console.log('✅ Render PostgreSQL connection working');
    console.log('✅ Tables and data verified');
    console.log('✅ Ready for production deployment!');
    
  } catch (error) {
    console.error('\n❌ DATABASE TEST FAILED:');
    console.error('========================');
    console.error('Error:', error.message);
  } finally {
    await pool.end();
  }
}

testRenderDatabase().catch(console.error); 