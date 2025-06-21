const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

async function restoreDatabase() {
  console.log('🔄 Starting OOAK.AI Database Restoration...');
  
  // Configuration
  const backupFile = path.join(__dirname, '../../OOAK-FUTURE/backup_20250621_072656.sql');
  const dbName = process.env.POSTGRES_DB || 'ooak_ai_db';
  const dbUser = process.env.POSTGRES_USER || 'vikasalagarsamy';
  const dbHost = process.env.POSTGRES_HOST || 'localhost';
  const dbPort = process.env.POSTGRES_PORT || '5432';
  
  try {
    // Check if backup file exists
    if (!fs.existsSync(backupFile)) {
      throw new Error(`Backup file not found: ${backupFile}`);
    }
    
    console.log('✅ Backup file found');
    console.log(`📁 File: ${backupFile}`);
    console.log(`🗄️  Database: ${dbName}`);
    console.log(`🌐 Host: ${dbHost}:${dbPort}`);
    
    // Drop existing database if exists
    console.log('🗑️  Dropping existing database (if exists)...');
    try {
      execSync(`dropdb -h ${dbHost} -p ${dbPort} -U ${dbUser} --if-exists ${dbName}`, { stdio: 'inherit' });
    } catch (error) {
      console.log('ℹ️  Database did not exist, continuing...');
    }
    
    // Create new database
    console.log('🆕 Creating new database...');
    execSync(`createdb -h ${dbHost} -p ${dbPort} -U ${dbUser} ${dbName}`, { stdio: 'inherit' });
    
    // Restore from backup
    console.log('⚡ Restoring database from backup...');
    execSync(`psql -h ${dbHost} -p ${dbPort} -U ${dbUser} -d ${dbName} -f "${backupFile}"`, { stdio: 'inherit' });
    
    console.log('✅ Database restoration completed successfully!');
    console.log('🚀 Your OOAK.AI database is ready to use!');
    
    // Create .env.local file with database connection
    const envContent = `# OOAK.AI Database Configuration
POSTGRES_HOST=${dbHost}
POSTGRES_PORT=${dbPort}
POSTGRES_DB=${dbName}
POSTGRES_USER=${dbUser}
POSTGRES_PASSWORD=${process.env.POSTGRES_PASSWORD || ''}

# Database URL for connection
DATABASE_URL=postgresql://${dbUser}:${process.env.POSTGRES_PASSWORD || ''}@${dbHost}:${dbPort}/${dbName}

# NextJS Configuration
NEXT_PUBLIC_APP_NAME=OOAK.AI
NEXT_PUBLIC_APP_URL=http://localhost:3000
`;
    
    fs.writeFileSync('.env.local', envContent);
    console.log('📝 Created .env.local with database configuration');
    
  } catch (error) {
    console.error('❌ Database restoration failed:', error.message);
    console.error('💡 Make sure PostgreSQL is running and you have the correct permissions');
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  restoreDatabase();
}

module.exports = { restoreDatabase }; 