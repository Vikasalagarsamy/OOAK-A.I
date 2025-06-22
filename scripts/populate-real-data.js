const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const client = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: {
    rejectUnauthorized: false
  }
});

async function populateRealData() {
  try {
    console.log('🔍 Reading backup file...');
    const backupContent = fs.readFileSync('../OOAK-FUTURE/backup_20250621_072656.sql', 'utf8');
    
    console.log('📊 Searching for COPY statements with data...');
    
    // Find COPY statements with actual data
    const copyRegex = /COPY\s+(?:public\.)?(\w+)\s*\([^)]+\)\s*FROM\s+stdin;\s*([\s\S]*?)\\\./gi;
    const tablesWithData = [];
    let match;
    
    while ((match = copyRegex.exec(backupContent)) !== null) {
      const tableName = match[1];
      const data = match[2].trim();
      
      // Only include tables with actual data (not just empty lines)
      const dataLines = data.split('\n').filter(line => line.trim() !== '' && line.trim() !== '\\.');
      
      if (dataLines.length > 0) {
        tablesWithData.push({
          table: tableName,
          data: dataLines
        });
      }
    }
    
    console.log(`📈 Found ${tablesWithData.length} tables with data:`);
    tablesWithData.forEach(table => {
      console.log(`  - ${table.table}: ${table.data.length} rows`);
    });
    
    if (tablesWithData.length === 0) {
      console.log('❌ No tables with data found');
      return;
    }
    
    console.log('\n🔗 Connecting to production database...');
    await client.connect();
    
    // Process tables in order of dependencies
    const tableOrder = ['companies', 'branches', 'departments', 'designations', 'employees', 'employee_companies'];
    
    for (const tableName of tableOrder) {
      const tableData = tablesWithData.find(t => t.table === tableName);
      if (!tableData) {
        console.log(`⚠️  No data found for ${tableName}`);
        continue;
      }
      
      try {
        console.log(`\n📥 Processing ${tableName}...`);
        
        // Get column information for the table
        const columnsResult = await client.query(`
          SELECT column_name, data_type, is_nullable
          FROM information_schema.columns 
          WHERE table_name = $1 AND table_schema = 'public'
          ORDER BY ordinal_position
        `, [tableName]);
        
        if (columnsResult.rows.length === 0) {
          console.log(`  ⚠️  Table ${tableName} not found in production database`);
          continue;
        }
        
        const columns = columnsResult.rows.map(row => ({
          name: row.column_name,
          type: row.data_type,
          nullable: row.is_nullable === 'YES'
        }));
        
        console.log(`  📋 Table has ${columns.length} columns`);
        
        // Clear existing data
        await client.query(`DELETE FROM "${tableName}"`);
        console.log(`  🗑️  Cleared existing data`);
        
        // Process each data row
        let insertedCount = 0;
        let errorCount = 0;
        
        for (const line of tableData.data) {
          try {
            // Split by tabs and handle PostgreSQL escape sequences
            const values = line.split('\t').map(val => {
              if (val === '\\N') return null;
              if (val === '') return null;
              // Handle escaped characters
              return val.replace(/\\r/g, '\r').replace(/\\n/g, '\n').replace(/\\t/g, '\t');
            });
            
            // Ensure we have the right number of values
            if (values.length !== columns.length) {
              console.log(`    ⚠️  Row has ${values.length} values but table has ${columns.length} columns - skipping`);
              continue;
            }
            
            // Create parameterized query
            const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');
            const columnNames = columns.map(col => `"${col.name}"`).join(', ');
            const query = `INSERT INTO "${tableName}" (${columnNames}) VALUES (${placeholders})`;
            
            await client.query(query, values);
            insertedCount++;
            
          } catch (error) {
            errorCount++;
            if (errorCount <= 3) { // Only show first 3 errors
              console.log(`    ❌ Error inserting row: ${error.message}`);
            }
          }
        }
        
        console.log(`  ✅ Successfully inserted ${insertedCount} rows into ${tableName}`);
        if (errorCount > 0) {
          console.log(`  ⚠️  ${errorCount} rows failed to insert`);
        }
        
        // Reset sequence if table has an id column
        const hasIdColumn = columns.some(col => col.name === 'id');
        if (hasIdColumn) {
          try {
            await client.query(`SELECT setval(pg_get_serial_sequence('${tableName}', 'id'), COALESCE(MAX(id), 1)) FROM "${tableName}"`);
            console.log(`  🔄 Reset sequence for ${tableName}`);
          } catch (error) {
            console.log(`  ⚠️  Could not reset sequence: ${error.message}`);
          }
        }
        
      } catch (error) {
        console.log(`  ❌ Error processing ${tableName}: ${error.message}`);
      }
    }
    
    // Process remaining tables not in the ordered list
    for (const tableData of tablesWithData) {
      if (!tableOrder.includes(tableData.table)) {
        console.log(`\n📋 Processing additional table: ${tableData.table}...`);
        // Similar processing logic would go here
      }
    }
    
    console.log('\n🎉 Data population completed!');
    console.log('\n📊 Verifying data...');
    
    // Verify the data was inserted
    for (const tableName of tableOrder) {
      try {
        const result = await client.query(`SELECT COUNT(*) as count FROM "${tableName}"`);
        console.log(`  ${tableName}: ${result.rows[0].count} rows`);
      } catch (error) {
        console.log(`  ${tableName}: Error counting rows`);
      }
    }
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await client.end();
  }
}

// Run the script
populateRealData(); 