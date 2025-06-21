const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

async function migrateProductionDatabase() {
  console.log('🚀 Starting OOAK.AI Production Database Migration...');
  
  // Get production environment variables
  const dbUrl = process.env.DATABASE_URL;
  const dbHost = process.env.POSTGRES_HOST;
  const dbPort = process.env.POSTGRES_PORT || '5432';
  const dbName = process.env.POSTGRES_DB;
  const dbUser = process.env.POSTGRES_USER;
  const dbPassword = process.env.POSTGRES_PASSWORD;
  
  if (!dbUrl && (!dbHost || !dbName || !dbUser)) {
    console.error('❌ Missing database configuration. Please set DATABASE_URL or individual DB environment variables.');
    process.exit(1);
  }
  
  try {
    console.log('✅ Production database configuration found');
    console.log(`🗄️  Database: ${dbName || 'from DATABASE_URL'}`);
    console.log(`🌐 Host: ${dbHost || 'from DATABASE_URL'}`);
    
    // Check if backup file exists (for initial migration)
    const backupFile = path.join(__dirname, '../../OOAK-FUTURE/backup_20250621_072656.sql');
    
    if (fs.existsSync(backupFile)) {
      console.log('📁 Backup file found, running initial database setup...');
      
      if (dbUrl) {
        // Use DATABASE_URL for connection
        execSync(`psql "${dbUrl}" -f "${backupFile}"`, { stdio: 'inherit' });
      } else {
        // Use individual connection parameters
        const pgConnStr = `postgresql://${dbUser}:${dbPassword}@${dbHost}:${dbPort}/${dbName}`;
        execSync(`psql "${pgConnStr}" -f "${backupFile}"`, { stdio: 'inherit' });
      }
      
      console.log('✅ Database migration completed successfully!');
    } else {
      console.log('⚠️  No backup file found. Running basic table creation...');
      
      // Create basic tables if backup doesn't exist
      const basicSchema = `
        CREATE TABLE IF NOT EXISTS leads (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255),
          phone VARCHAR(20) NOT NULL,
          status VARCHAR(50) DEFAULT 'new',
          created_at TIMESTAMP DEFAULT NOW(),
          updated_at TIMESTAMP DEFAULT NOW()
        );
        
        CREATE TABLE IF NOT EXISTS clients (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL,
          phone VARCHAR(20) NOT NULL,
          status VARCHAR(50) DEFAULT 'active',
          created_at TIMESTAMP DEFAULT NOW(),
          updated_at TIMESTAMP DEFAULT NOW()
        );
        
        CREATE TABLE IF NOT EXISTS bookings (
          id SERIAL PRIMARY KEY,
          client_id INTEGER REFERENCES clients(id),
          event_date DATE,
          status VARCHAR(50) DEFAULT 'pending',
          total_amount DECIMAL(10,2) DEFAULT 0,
          created_at TIMESTAMP DEFAULT NOW(),
          updated_at TIMESTAMP DEFAULT NOW()
        );
        
        CREATE TABLE IF NOT EXISTS quotations (
          id SERIAL PRIMARY KEY,
          client_id INTEGER REFERENCES clients(id),
          total_amount DECIMAL(10,2) NOT NULL,
          status VARCHAR(50) DEFAULT 'pending',
          created_at TIMESTAMP DEFAULT NOW(),
          updated_at TIMESTAMP DEFAULT NOW()
        );
      `;
      
      if (dbUrl) {
        execSync(`psql "${dbUrl}" -c "${basicSchema}"`, { stdio: 'inherit' });
      } else {
        const pgConnStr = `postgresql://${dbUser}:${dbPassword}@${dbHost}:${dbPort}/${dbName}`;
        execSync(`psql "${pgConnStr}" -c "${basicSchema}"`, { stdio: 'inherit' });
      }
      
      console.log('✅ Basic schema created successfully!');
    }
    
    console.log('🎉 OOAK.AI Production Database is ready!');
    console.log('🚀 Your AI-powered wedding photography platform is live!');
    
  } catch (error) {
    console.error('❌ Production database migration failed:', error.message);
    console.error('💡 Make sure the database is accessible and credentials are correct');
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  migrateProductionDatabase();
}

module.exports = { migrateProductionDatabase }; 