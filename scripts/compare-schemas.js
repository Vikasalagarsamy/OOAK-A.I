const { Pool } = require('pg');

// Database connection URLs
const DEV_DB_URL = 'postgresql://localhost:5432/ooak_ai_dev';
const PROD_DB_URL = process.env.DATABASE_URL;

// Create connection pools
const devPool = new Pool({
  connectionString: DEV_DB_URL,
  ssl: false
});

const prodPool = new Pool({
  connectionString: PROD_DB_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

async function getTables(client, dbName) {
  const result = await client.query(`
    SELECT 
      table_name,
      table_type
    FROM information_schema.tables 
    WHERE table_schema = 'public'
    ORDER BY table_name;
  `);
  
  return result.rows;
}

async function compareSchemas() {
  console.log('🔍 Comparing Development and Production Schemas...\n');
  
  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    // Get tables from both databases
    const devTables = await getTables(devClient, 'Development');
    const prodTables = await getTables(prodClient, 'Production');
    
    // Create sets for easy comparison
    const devTableSet = new Set(devTables.map(t => t.table_name));
    const prodTableSet = new Set(prodTables.map(t => t.table_name));
    
    // Find tables unique to each database
    const onlyInDev = [...devTableSet].filter(t => !prodTableSet.has(t));
    const onlyInProd = [...prodTableSet].filter(t => !devTableSet.has(t));
    const inBoth = [...devTableSet].filter(t => prodTableSet.has(t));
    
    // Print results
    console.log('📊 Summary:');
    console.log(`Development tables: ${devTables.length}`);
    console.log(`Production tables: ${prodTables.length}\n`);
    
    if (onlyInDev.length > 0) {
      console.log('🟡 Tables only in Development:');
      onlyInDev.forEach(t => console.log(`  - ${t}`));
      console.log();
    }
    
    if (onlyInProd.length > 0) {
      console.log('🟡 Tables only in Production:');
      onlyInProd.forEach(t => console.log(`  - ${t}`));
      console.log();
    }
    
    console.log('✅ Tables in both databases:');
    inBoth.forEach(t => console.log(`  - ${t}`));
    
  } catch (error) {
    console.error('\n❌ Error comparing schemas:', error.message);
  } finally {
    devClient.release();
    prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

// Run the comparison
compareSchemas().catch(console.error); 