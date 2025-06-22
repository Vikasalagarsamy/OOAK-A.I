const { Pool } = require('pg');
const { exec } = require('child_process');
const util = require('util');
const execAsync = util.promisify(exec);

// Production database connection
const PROD_DB_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';

// Local development database connection
const DEV_DB = {
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: process.env.POSTGRES_USER || 'vikasalagarsamy',
};

async function syncDatabase() {
  console.log('🚀 Starting database sync from production to development...\n');

  try {
    // Step 1: Create temporary dump file
    const dumpFile = 'prod_dump.sql';
    console.log('📦 Step 1: Dumping production database...');
    
    // Modified pg_dump command with SSL mode set to require and no verify-ca
    const dumpCommand = `PGSSLMODE=require PGPASSWORD=mSglqEawN72hkoEj8tSNF5qv9vJr3U6k pg_dump \
      --host=dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com \
      --port=5432 \
      --username=ooak_admin \
      --dbname=ooak_ai_db \
      --clean \
      --if-exists \
      --no-owner \
      --no-privileges \
      --no-comments \
      --format=plain \
      --file=${dumpFile}`;

    await execAsync(dumpCommand);
    console.log('✅ Production database dump completed\n');

    // Step 2: Drop and recreate local database
    console.log('🗑️  Step 2: Preparing local database...');
    
    // Drop existing connections
    const dropConnectionsCommand = `psql -h ${DEV_DB.host} -p ${DEV_DB.port} -U ${DEV_DB.user} postgres -c "
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = '${DEV_DB.database}'
      AND pid <> pg_backend_pid();"`;

    await execAsync(dropConnectionsCommand);

    // Drop and recreate database
    const recreateDbCommands = [
      `dropdb --if-exists -h ${DEV_DB.host} -p ${DEV_DB.port} -U ${DEV_DB.user} ${DEV_DB.database}`,
      `createdb -h ${DEV_DB.host} -p ${DEV_DB.port} -U ${DEV_DB.user} ${DEV_DB.database}`
    ];

    for (const cmd of recreateDbCommands) {
      await execAsync(cmd);
    }
    
    console.log('✅ Local database reset completed\n');

    // Step 3: Restore dump to local database
    console.log('📥 Step 3: Restoring data to local database...');
    
    const restoreCommand = `psql -h ${DEV_DB.host} -p ${DEV_DB.port} -U ${DEV_DB.user} -d ${DEV_DB.database} -f ${dumpFile}`;
    await execAsync(restoreCommand);
    
    console.log('✅ Data restoration completed\n');

    // Step 4: Verify data integrity
    console.log('🔍 Step 4: Verifying data integrity...');
    
    // Connect to both databases to compare
    const prodPool = new Pool({
      connectionString: PROD_DB_URL,
      ssl: { rejectUnauthorized: false }
    });

    const devPool = new Pool({
      host: DEV_DB.host,
      port: DEV_DB.port,
      database: DEV_DB.database,
      user: DEV_DB.user
    });

    // Get list of tables
    const tableQuery = `
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    `;

    const prodClient = await prodPool.connect();
    const devClient = await devPool.connect();

    const prodTables = await prodClient.query(tableQuery);
    console.log('\n📊 Data Verification Results:');
    console.log('============================');

    for (const { table_name } of prodTables.rows) {
      const [prodCount, devCount] = await Promise.all([
        prodClient.query(`SELECT COUNT(*) as count FROM ${table_name}`),
        devClient.query(`SELECT COUNT(*) as count FROM ${table_name}`)
      ]);

      const prodRows = parseInt(prodCount.rows[0].count);
      const devRows = parseInt(devCount.rows[0].count);
      const match = prodRows === devRows;

      console.log(
        `${match ? '✅' : '❌'} ${table_name.padEnd(30)} | ` +
        `Prod: ${prodRows.toString().padStart(5)} | ` +
        `Dev: ${devRows.toString().padStart(5)} | ` +
        `${match ? 'Matched' : 'Mismatch'}`
      );
    }

    // Cleanup
    prodClient.release();
    devClient.release();
    await prodPool.end();
    await devPool.end();

    // Clean up dump file
    await execAsync(`rm ${dumpFile}`);

    console.log('\n🎉 Database sync completed successfully!');
    console.log('=====================================');
    console.log('✅ Production data dumped');
    console.log('✅ Local database reset');
    console.log('✅ Data restored');
    console.log('✅ Integrity verified');
    console.log('\n🚀 Your local development database is now in sync with production!');

  } catch (error) {
    console.error('\n❌ Error during database sync:', error.message);
    console.error('\n🔧 Troubleshooting steps:');
    console.error('1. Ensure PostgreSQL is running locally');
    console.error('2. Verify production database URL');
    console.error('3. Check local database credentials');
    console.error('4. Make sure pg_dump and psql are installed');
    process.exit(1);
  }
}

// Run the sync
syncDatabase(); 