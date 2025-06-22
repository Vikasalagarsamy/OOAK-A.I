const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const client = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: {
    rejectUnauthorized: false
  }
});

async function extractAndPopulateData() {
  try {
    console.log('🔍 Reading backup file...');
    const backupContent = fs.readFileSync('../OOAK-FUTURE/backup_20250621_072656.sql', 'utf8');
    
    console.log('📊 Searching for INSERT statements...');
    
    // Find all INSERT statements with VALUES
    const insertRegex = /INSERT INTO\s+"?(\w+)"?\s*(?:\([^)]+\))?\s*VALUES\s*\([^;]+\);/gi;
    const insertStatements = [];
    let match;
    
    while ((match = insertRegex.exec(backupContent)) !== null) {
      insertStatements.push({
        table: match[1],
        statement: match[0]
      });
    }
    
    console.log(`📈 Found ${insertStatements.length} INSERT statements`);
    
    if (insertStatements.length === 0) {
      console.log('❌ No INSERT statements found. Let me search for data in a different format...');
      
      // Search for COPY statements (another way PostgreSQL exports data)
      const copyRegex = /COPY\s+"?(\w+)"?\s*(?:\([^)]+\))?\s*FROM\s+stdin;([\s\S]*?)\\./gi;
      const copyStatements = [];
      
      while ((match = copyRegex.exec(backupContent)) !== null) {
        const tableName = match[1];
        const data = match[2].trim();
        if (data && data !== '') {
          copyStatements.push({
            table: tableName,
            data: data
          });
        }
      }
      
      console.log(`📋 Found ${copyStatements.length} COPY statements with data`);
      
      if (copyStatements.length > 0) {
        console.log('\n🗂️  Tables with data:');
        copyStatements.forEach(stmt => {
          const lines = stmt.data.split('\n').filter(line => line.trim() !== '');
          console.log(`  - ${stmt.table}: ${lines.length} rows`);
        });
        
        console.log('\n🔗 Connecting to production database...');
        await client.connect();
        
        // Process each COPY statement
        for (const stmt of copyStatements) {
          try {
            console.log(`\n📥 Processing ${stmt.table}...`);
            
            // Get column names for the table
            const columnsResult = await client.query(`
              SELECT column_name 
              FROM information_schema.columns 
              WHERE table_name = $1 
              ORDER BY ordinal_position
            `, [stmt.table]);
            
            const columns = columnsResult.rows.map(row => row.column_name);
            
            if (columns.length === 0) {
              console.log(`  ⚠️  Table ${stmt.table} not found in production database`);
              continue;
            }
            
            // Clear existing data
            await client.query(`DELETE FROM "${stmt.table}"`);
            
            // Parse and insert data
            const dataLines = stmt.data.split('\n').filter(line => line.trim() !== '');
            let insertedCount = 0;
            
            for (const line of dataLines) {
              try {
                // Parse tab-separated values
                const values = line.split('\t').map(val => {
                  if (val === '\\N') return null;
                  return val;
                });
                
                if (values.length === columns.length) {
                  const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');
                  const query = `INSERT INTO "${stmt.table}" (${columns.map(col => `"${col}"`).join(', ')}) VALUES (${placeholders})`;
                  
                  await client.query(query, values);
                  insertedCount++;
                }
              } catch (error) {
                console.log(`    ⚠️  Error inserting row: ${error.message}`);
              }
            }
            
            console.log(`  ✅ Inserted ${insertedCount} rows into ${stmt.table}`);
            
          } catch (error) {
            console.log(`  ❌ Error processing ${stmt.table}: ${error.message}`);
          }
        }
        
      } else {
        console.log('❌ No data found in backup file');
      }
    } else {
      console.log('\n🗂️  Tables with INSERT statements:');
      insertStatements.forEach(stmt => {
        console.log(`  - ${stmt.table}`);
      });
      
      console.log('\n🔗 Connecting to production database...');
      await client.connect();
      
      // Execute each INSERT statement
      for (const stmt of insertStatements) {
        try {
          console.log(`\n📥 Inserting data into ${stmt.table}...`);
          await client.query(stmt.statement);
          console.log(`  ✅ Successfully inserted data into ${stmt.table}`);
        } catch (error) {
          console.log(`  ❌ Error inserting into ${stmt.table}: ${error.message}`);
        }
      }
    }
    
    console.log('\n🎉 Data population completed!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await client.end();
  }
}

// Run the script
extractAndPopulateData(); 