const { Pool } = require('pg');

// Production database connection
const pool = new Pool({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: {
    rejectUnauthorized: false
  }
});

async function checkTableSchema() {
  const client = await pool.connect();
  
  try {
    // List of tables that had ARRAY type issues
    const tablesToCheck = [
      'leads',
      'roles',
      'email_notification_templates',
      'message_analysis',
      'notification_patterns',
      'notification_rules',
      'personalization_learning',
      'quotation_business_lifecycle',
      'user_behavior_analytics',
      'user_engagement_summary',
      'user_preferences'
    ];
    
    console.log('🔍 Checking Production Database Schema\n');
    
    for (const tableName of tablesToCheck) {
      console.log(`\n📋 Table: ${tableName}`);
      console.log('='.repeat(tableName.length + 8));
      
      try {
        // Get column information
        const result = await client.query(`
          SELECT 
            column_name,
            data_type,
            udt_name,
            character_maximum_length,
            is_nullable
          FROM information_schema.columns 
          WHERE table_name = $1 
          ORDER BY ordinal_position;
        `, [tableName]);
        
        if (result.rows.length === 0) {
          console.log('❌ Table does not exist in production\n');
          continue;
        }
        
        // Display column information
        result.rows.forEach(col => {
          const dataType = col.data_type === 'ARRAY' 
            ? `${col.udt_name.replace(/_/g, '')}[]`
            : col.data_type + (col.character_maximum_length ? `(${col.character_maximum_length})` : '');
          
          console.log(`🔸 ${col.column_name.padEnd(30)} | ${dataType.padEnd(20)} | ${col.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'}`);
        });
        
        // Get row count
        const countResult = await client.query(`SELECT COUNT(*) FROM ${tableName}`);
        console.log(`\n📊 Row count: ${countResult.rows[0].count}`);
        
      } catch (error) {
        console.log(`❌ Error checking table: ${error.message}\n`);
      }
    }
    
  } finally {
    client.release();
    await pool.end();
  }
}

checkTableSchema().catch(console.error); 