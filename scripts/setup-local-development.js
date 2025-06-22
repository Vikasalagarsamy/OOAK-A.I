const { execSync } = require('child_process');
const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const prodClient = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false }
});

async function setupLocalDevelopment() {
  console.log('🚀 Setting up OOAK.AI Local Development Environment...\n');
  
  try {
    // Step 1: Check if PostgreSQL is installed
    console.log('1️⃣ Checking PostgreSQL installation...');
    try {
      execSync('which psql', { stdio: 'ignore' });
      console.log('   ✅ PostgreSQL is installed');
    } catch (error) {
      console.log('   ❌ PostgreSQL not found. Installing...');
      console.log('   📥 Installing PostgreSQL via Homebrew...');
      execSync('brew install postgresql@15');
      execSync('brew services start postgresql@15');
      console.log('   ✅ PostgreSQL installed and started');
    }
    
    // Step 2: Create local development database
    console.log('\n2️⃣ Setting up local development database...');
    try {
      execSync('dropdb ooak_ai_dev 2>/dev/null', { stdio: 'ignore' });
    } catch (error) {
      // Database doesn't exist, which is fine
    }
    
    execSync('createdb ooak_ai_dev');
    console.log('   ✅ Created local database: ooak_ai_dev');
    
    // Step 3: Create local environment file
    console.log('\n3️⃣ Creating development environment configuration...');
    const localEnvContent = `# OOAK.AI Local Development Environment
NODE_ENV=development
DATABASE_URL=postgresql://localhost:5432/ooak_ai_dev
NEXT_PUBLIC_APP_URL=http://localhost:3000

# API Keys (Add your keys here)
# OPENAI_API_KEY=your_openai_key_here
# WHATSAPP_API_KEY=your_whatsapp_key_here
# INSTAGRAM_API_KEY=your_instagram_key_here

# Development Settings
DEBUG=true
LOG_LEVEL=debug
`;
    
    fs.writeFileSync('.env.local', localEnvContent);
    console.log('   ✅ Created .env.local for development');
    
    // Step 4: Update database connection to support multiple environments
    console.log('\n4️⃣ Updating database connection configuration...');
    await updateDatabaseConfig();
    console.log('   ✅ Updated lib/db.ts for multi-environment support');
    
    // Step 5: Sync production data to local
    console.log('\n5️⃣ Syncing production data to local development...');
    await syncProductionToLocal();
    console.log('   ✅ Production data synced to local development database');
    
    // Step 6: Create development scripts
    console.log('\n6️⃣ Creating development utility scripts...');
    await createDevelopmentScripts();
    console.log('   ✅ Development scripts created');
    
    // Step 7: Update package.json with development commands
    console.log('\n7️⃣ Adding development commands to package.json...');
    await updatePackageJson();
    console.log('   ✅ Development commands added to package.json');
    
    console.log('\n🎉 Local Development Environment Setup Complete!');
    console.log('\n📋 Next Steps:');
    console.log('   1. npm run dev - Start development server');
    console.log('   2. npm run db:sync - Sync latest production data');
    console.log('   3. npm run db:backup - Backup your local changes');
    console.log('   4. Start building features with real OOAK data!');
    console.log('\n🌐 Development URL: http://localhost:3000');
    
  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    process.exit(1);
  }
}

async function updateDatabaseConfig() {
  const dbConfigContent = `import { Pool } from 'pg';

// Auto-detect environment and use appropriate database configuration
const isDevelopment = process.env.NODE_ENV === 'development';
const isProduction = process.env.NODE_ENV === 'production';

let connectionConfig;

if (isDevelopment) {
  // Local development database
  connectionConfig = {
    connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/ooak_ai_dev',
    ssl: false,
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
  };
} else if (isProduction) {
  // Production database (Render)
  connectionConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    },
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000,
  };
} else {
  // Staging or other environments
  connectionConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    },
    max: 15,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 7000,
  };
}

// Create connection pool
const pool = new Pool(connectionConfig);

// Connection event handlers
pool.on('connect', (client) => {
  if (isDevelopment) {
    console.log('🔗 Connected to local development database');
  }
});

pool.on('error', (err) => {
  console.error('❌ Database connection error:', err);
  process.exit(-1);
});

// Database query function with error handling and retry logic
export async function query(text: string, params?: any[]): Promise<any> {
  const maxRetries = 3;
  let retries = 0;
  
  while (retries < maxRetries) {
    try {
      const start = Date.now();
      const result = await pool.query(text, params);
      const duration = Date.now() - start;
      
      if (isDevelopment && duration > 1000) {
        console.warn(\`⚠️ Slow query (\${duration}ms): \${text.substring(0, 100)}...\`);
      }
      
      return result;
    } catch (error: any) {
      retries++;
      console.error(\`❌ Database query error (attempt \${retries}/\${maxRetries}):\`, error.message);
      
      if (retries >= maxRetries) {
        throw error;
      }
      
      // Wait before retry (exponential backoff)
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, retries) * 1000));
    }
  }
}

// Get database connection for transactions
export async function getClient() {
  return await pool.connect();
}

// Health check function
export async function healthCheck(): Promise<boolean> {
  try {
    const result = await query('SELECT 1 as health');
    return result.rows[0].health === 1;
  } catch (error) {
    console.error('❌ Database health check failed:', error);
    return false;
  }
}

// Environment info
export const dbInfo = {
  environment: process.env.NODE_ENV || 'development',
  isDevelopment,
  isProduction,
  maxConnections: connectionConfig.max
};

export default pool;
`;
  
  fs.writeFileSync('lib/db.ts', dbConfigContent);
}

async function syncProductionToLocal() {
  console.log('   📥 Connecting to production database...');
  await prodClient.connect();
  
  // Get production schema
  console.log('   📋 Extracting production schema...');
  execSync('pg_dump --schema-only --no-owner --no-privileges "postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db" > temp_schema.sql');
  
  // Apply schema to local database
  console.log('   🏗️ Setting up local database schema...');
  execSync('psql -d ooak_ai_dev -f temp_schema.sql > /dev/null 2>&1');
  
  // Copy data from production to local
  console.log('   📊 Copying production data to local...');
  const tables = await prodClient.query(`
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    ORDER BY table_name
  `);
  
  for (const table of tables.rows) {
    const tableName = table.table_name;
    try {
      const result = await prodClient.query(`SELECT COUNT(*) FROM "${tableName}"`);
      const count = parseInt(result.rows[0].count);
      
      if (count > 0) {
        console.log(`     📋 Copying ${tableName} (${count} rows)...`);
        execSync(`pg_dump --data-only --table="${tableName}" "postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db" | psql -d ooak_ai_dev > /dev/null 2>&1`);
      }
    } catch (error) {
      // Skip tables that might have issues
      console.log(`     ⚠️ Skipped ${tableName}`);
    }
  }
  
  // Clean up
  fs.unlinkSync('temp_schema.sql');
  await prodClient.end();
}

async function createDevelopmentScripts() {
  // Create sync script
  const syncScript = `const { execSync } = require('child_process');

console.log('🔄 Syncing production data to local development...');

try {
  // Backup current local data
  execSync('pg_dump ooak_ai_dev > backup_local_' + new Date().toISOString().slice(0, 10) + '.sql');
  console.log('✅ Local data backed up');
  
  // Sync from production
  execSync('node scripts/setup-local-development.js --sync-only');
  console.log('✅ Production data synced to local');
  
} catch (error) {
  console.error('❌ Sync failed:', error.message);
  process.exit(1);
}
`;
  
  fs.writeFileSync('scripts/sync-prod-to-local.js', syncScript);
  
  // Create backup script
  const backupScript = `const { execSync } = require('child_process');
const fs = require('fs');

const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
const backupFile = \`backup_local_\${timestamp}.sql\`;

console.log('💾 Creating local database backup...');

try {
  execSync(\`pg_dump ooak_ai_dev > \${backupFile}\`);
  console.log(\`✅ Backup created: \${backupFile}\`);
  
  // Keep only last 5 backups
  const backups = fs.readdirSync('.')
    .filter(file => file.startsWith('backup_local_'))
    .sort()
    .reverse();
    
  if (backups.length > 5) {
    backups.slice(5).forEach(file => {
      fs.unlinkSync(file);
      console.log(\`🗑️ Removed old backup: \${file}\`);
    });
  }
  
} catch (error) {
  console.error('❌ Backup failed:', error.message);
  process.exit(1);
}
`;
  
  fs.writeFileSync('scripts/backup-local.js', backupScript);
}

async function updatePackageJson() {
  const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  
  packageJson.scripts = {
    ...packageJson.scripts,
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "db:sync": "node scripts/sync-prod-to-local.js",
    "db:backup": "node scripts/backup-local.js",
    "db:setup": "node scripts/setup-local-development.js",
    "db:reset": "dropdb ooak_ai_dev && createdb ooak_ai_dev && npm run db:sync"
  };
  
  fs.writeFileSync('package.json', JSON.stringify(packageJson, null, 2));
}

// Run setup
setupLocalDevelopment(); 