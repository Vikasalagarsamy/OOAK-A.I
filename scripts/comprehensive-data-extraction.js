const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const client = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: {
    rejectUnauthorized: false
  }
});

async function comprehensiveDataExtraction() {
  try {
    console.log('🔍 Reading entire backup file thoroughly...');
    const backupContent = fs.readFileSync('../OOAK-FUTURE/backup_20250621_072656.sql', 'utf8');
    
    console.log(`📄 Backup file size: ${(backupContent.length / 1024 / 1024).toFixed(2)} MB`);
    console.log('🔍 Performing comprehensive analysis...\n');
    
    // More comprehensive regex to catch all COPY statements
    const copyRegex = /COPY\s+(?:(?:public|master_data|auth)\.)?([a-zA-Z_][a-zA-Z0-9_]*)\s*\([^)]+\)\s*FROM\s+stdin;\s*([\s\S]*?)\\\./gi;
    const allTablesWithData = new Map();
    let match;
    
    console.log('📊 Scanning for ALL COPY statements...');
    
    while ((match = copyRegex.exec(backupContent)) !== null) {
      const tableName = match[1];
      const data = match[2].trim();
      
      // Split data into lines and filter out empty lines and the terminator
      const dataLines = data.split('\n')
        .map(line => line.trim())
        .filter(line => line !== '' && line !== '\\.' && line !== '\t' && !line.startsWith('--'));
      
      if (dataLines.length > 0) {
        // Check if lines actually contain data (not just whitespace or comments)
        const realDataLines = dataLines.filter(line => {
          return line.length > 0 && 
                 !line.startsWith('--') && 
                 line !== '\\N' && 
                 line.split('\t').some(field => field.trim() !== '' && field !== '\\N');
        });
        
        if (realDataLines.length > 0) {
          allTablesWithData.set(tableName, realDataLines);
        }
      }
    }
    
    console.log(`📈 Found ${allTablesWithData.size} tables with actual data:\n`);
    
    // Sort tables by data volume for better overview
    const sortedTables = Array.from(allTablesWithData.entries())
      .sort((a, b) => b[1].length - a[1].length);
    
    let totalRows = 0;
    sortedTables.forEach(([tableName, dataLines]) => {
      console.log(`  📋 ${tableName.padEnd(30)} : ${dataLines.length.toString().padStart(4)} rows`);
      totalRows += dataLines.length;
    });
    
    console.log(`\n📊 Total data rows found: ${totalRows}`);
    
    if (allTablesWithData.size === 0) {
      console.log('❌ No tables with data found');
      return;
    }
    
    console.log('\n🔗 Connecting to production database...');
    await client.connect();
    
    // Get all existing tables in production database
    const existingTablesResult = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name
    `);
    
    const existingTables = new Set(existingTablesResult.rows.map(row => row.table_name));
    console.log(`🗄️  Production database has ${existingTables.size} tables`);
    
    // Define dependency order for core tables
    const dependencyOrder = [
      'roles', 'companies', 'branches', 'departments', 'designations', 
      'employees', 'employee_companies', 'user_accounts', 'lead_sources',
      'leads', 'clients', 'services', 'quotations', 'quotation_events',
      'deliverables', 'payments', 'ai_configurations', 'notifications'
    ];
    
    // Process tables in dependency order first
    console.log('\n🔄 Processing core tables in dependency order...');
    const processedTables = new Set();
    
    for (const tableName of dependencyOrder) {
      if (allTablesWithData.has(tableName) && existingTables.has(tableName)) {
        await processTable(tableName, allTablesWithData.get(tableName), existingTables);
        processedTables.add(tableName);
      }
    }
    
    // Process remaining tables
    console.log('\n🔄 Processing remaining tables...');
    for (const [tableName, dataLines] of allTablesWithData) {
      if (!processedTables.has(tableName) && existingTables.has(tableName)) {
        await processTable(tableName, dataLines, existingTables);
        processedTables.add(tableName);
      }
    }
    
    // Report tables that exist in backup but not in production
    console.log('\n⚠️  Tables in backup but not in production database:');
    for (const [tableName] of allTablesWithData) {
      if (!existingTables.has(tableName)) {
        console.log(`  - ${tableName} (${allTablesWithData.get(tableName).length} rows)`);
      }
    }
    
    console.log('\n🎉 Comprehensive data extraction completed!');
    console.log('\n📊 Final verification - Row counts in production:');
    
    // Verify all data
    const verificationTables = Array.from(processedTables).sort();
    for (const tableName of verificationTables) {
      try {
        const result = await client.query(`SELECT COUNT(*) as count FROM "${tableName}"`);
        const count = result.rows[0].count;
        const originalCount = allTablesWithData.get(tableName)?.length || 0;
        const status = count == originalCount ? '✅' : count > 0 ? '⚠️ ' : '❌';
        console.log(`  ${status} ${tableName.padEnd(30)} : ${count.toString().padStart(4)} / ${originalCount.toString().padStart(4)} rows`);
      } catch (error) {
        console.log(`  ❌ ${tableName.padEnd(30)} : Error counting rows`);
      }
    }
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    console.error(error.stack);
  } finally {
    await client.end();
  }
}

async function processTable(tableName, dataLines, existingTables) {
  try {
    console.log(`\n📥 Processing ${tableName} (${dataLines.length} rows)...`);
    
    // Get column information
    const columnsResult = await client.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = $1 AND table_schema = 'public'
      ORDER BY ordinal_position
    `, [tableName]);
    
    if (columnsResult.rows.length === 0) {
      console.log(`  ⚠️  Table ${tableName} not found in production database`);
      return;
    }
    
    const columns = columnsResult.rows.map(row => ({
      name: row.column_name,
      type: row.data_type,
      nullable: row.is_nullable === 'YES',
      hasDefault: row.column_default !== null
    }));
    
    // Clear existing data
    await client.query(`DELETE FROM "${tableName}"`);
    console.log(`  🗑️  Cleared existing data`);
    
    let insertedCount = 0;
    let errorCount = 0;
    const errors = [];
    
    for (let i = 0; i < dataLines.length; i++) {
      const line = dataLines[i];
      try {
        // Handle PostgreSQL COPY format
        const values = line.split('\t').map(val => {
          if (val === '\\N') return null;
          if (val === '') return null;
          // Handle escaped characters
          return val
            .replace(/\\r/g, '\r')
            .replace(/\\n/g, '\n')
            .replace(/\\t/g, '\t')
            .replace(/\\\\/g, '\\');
        });
        
        // Adjust for column count mismatch
        while (values.length < columns.length) {
          values.push(null);
        }
        if (values.length > columns.length) {
          values.splice(columns.length);
        }
        
        // Create parameterized query
        const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');
        const columnNames = columns.map(col => `"${col.name}"`).join(', ');
        const query = `INSERT INTO "${tableName}" (${columnNames}) VALUES (${placeholders})`;
        
        await client.query(query, values);
        insertedCount++;
        
      } catch (error) {
        errorCount++;
        if (errors.length < 5) { // Keep first 5 errors for analysis
          errors.push({
            row: i + 1,
            error: error.message,
            data: line.substring(0, 100) + (line.length > 100 ? '...' : '')
          });
        }
      }
    }
    
    console.log(`  ✅ Successfully inserted ${insertedCount} rows`);
    if (errorCount > 0) {
      console.log(`  ⚠️  ${errorCount} rows failed to insert`);
      if (errors.length > 0) {
        console.log(`  📝 Sample errors:`);
        errors.forEach(err => {
          console.log(`    Row ${err.row}: ${err.error}`);
        });
      }
    }
    
    // Reset sequence if table has an id column
    const hasIdColumn = columns.some(col => col.name === 'id');
    if (hasIdColumn && insertedCount > 0) {
      try {
        await client.query(`SELECT setval(pg_get_serial_sequence('${tableName}', 'id'), COALESCE(MAX(id), 1)) FROM "${tableName}"`);
        console.log(`  🔄 Reset sequence for ${tableName}`);
      } catch (error) {
        // Sequence reset is not critical
      }
    }
    
  } catch (error) {
    console.log(`  ❌ Error processing ${tableName}: ${error.message}`);
  }
}

// Run the comprehensive extraction
comprehensiveDataExtraction(); 