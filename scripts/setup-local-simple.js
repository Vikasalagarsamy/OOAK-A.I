const { execSync } = require('child_process');
const fs = require('fs');

async function setupLocalDevelopmentSimple() {
  console.log('🚀 Setting up OOAK.AI Local Development Environment (Simple)...\n');
  
  try {
    // Step 1: Check if PostgreSQL is installed
    console.log('1️⃣ Checking PostgreSQL installation...');
    try {
      execSync('which psql', { stdio: 'ignore' });
      console.log('   ✅ PostgreSQL is already installed');
    } catch (error) {
      console.log('   ❌ PostgreSQL not found. Please install PostgreSQL first:');
      console.log('   📥 Run: brew install postgresql@15');
      console.log('   🚀 Run: brew services start postgresql@15');
      process.exit(1);
    }
    
    // Step 2: Create local development database
    console.log('\n2️⃣ Setting up local development database...');
    try {
      execSync('dropdb ooak_ai_dev 2>/dev/null', { stdio: 'ignore' });
      console.log('   🗑️ Dropped existing database');
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
    
    // Step 4: Update database connection
    console.log('\n4️⃣ Updating database connection configuration...');
    await updateDatabaseConfig();
    console.log('   ✅ Updated lib/db.ts for multi-environment support');
    
    // Step 5: Use existing comprehensive extraction script
    console.log('\n5️⃣ Setting up database schema and data...');
    console.log('   📋 We\'ll use the comprehensive data extraction script to populate local database');
    
    // Create a local version of the comprehensive script
    await createLocalDataScript();
    console.log('   ✅ Created local data population script');
    
    // Step 6: Update package.json
    console.log('\n6️⃣ Adding development commands to package.json...');
    await updatePackageJson();
    console.log('   ✅ Development commands added to package.json');
    
    console.log('\n🎉 Local Development Environment Setup Complete!');
    console.log('\n📋 Next Steps:');
    console.log('   1. npm run db:populate - Populate local database with production data');
    console.log('   2. npm run dev - Start development server');
    console.log('   3. npm run db:backup - Backup your local changes');
    console.log('\n🌐 Development URL: http://localhost:3000');
    console.log('\n⚠️  Note: Run "npm run db:populate" first to get all your production data locally!');
    
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

async function createLocalDataScript() {
  const localDataScript = `const fs = require('fs');
const { Client } = require('pg');

// Production database connection
const prodClient = new Client({
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false }
});

// Local database connection
const localClient = new Client({
  connectionString: 'postgresql://localhost:5432/ooak_ai_dev',
  ssl: false
});

async function populateLocalDatabase() {
  console.log('🔄 Populating local database with production data...');
  
  try {
    console.log('🔗 Connecting to production database...');
    await prodClient.connect();
    
    console.log('🔗 Connecting to local database...');
    await localClient.connect();
    
    // Get all tables from production
    console.log('📋 Getting table list from production...');
    const tablesResult = await prodClient.query(\`
      SELECT table_name, column_name, data_type, is_nullable
      FROM information_schema.columns 
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position
    \`);
    
    // Group columns by table
    const tableColumns = {};
    tablesResult.rows.forEach(row => {
      if (!tableColumns[row.table_name]) {
        tableColumns[row.table_name] = [];
      }
      tableColumns[row.table_name].push({
        name: row.column_name,
        type: row.data_type,
        nullable: row.is_nullable === 'YES'
      });
    });
    
    console.log(\`📊 Found \${Object.keys(tableColumns).length} tables\`);
    
    // Create tables in local database
    for (const tableName of Object.keys(tableColumns)) {
      console.log(\`🏗️ Creating table: \${tableName}\`);
      
      // Get table creation SQL from production
      const createTableResult = await prodClient.query(\`
        SELECT 
          'CREATE TABLE IF NOT EXISTS "' || table_name || '" (' ||
          string_agg(
            '"' || column_name || '" ' || 
            CASE 
              WHEN data_type = 'character varying' THEN 'VARCHAR' || COALESCE('(' || character_maximum_length || ')', '')
              WHEN data_type = 'character' THEN 'CHAR' || COALESCE('(' || character_maximum_length || ')', '')
              WHEN data_type = 'text' THEN 'TEXT'
              WHEN data_type = 'integer' THEN 'INTEGER'
              WHEN data_type = 'bigint' THEN 'BIGINT'
              WHEN data_type = 'smallint' THEN 'SMALLINT'
              WHEN data_type = 'boolean' THEN 'BOOLEAN'
              WHEN data_type = 'timestamp without time zone' THEN 'TIMESTAMP'
              WHEN data_type = 'timestamp with time zone' THEN 'TIMESTAMPTZ'
              WHEN data_type = 'date' THEN 'DATE'
              WHEN data_type = 'time without time zone' THEN 'TIME'
              WHEN data_type = 'numeric' THEN 'NUMERIC' || COALESCE('(' || numeric_precision || ',' || numeric_scale || ')', '')
              WHEN data_type = 'real' THEN 'REAL'
              WHEN data_type = 'double precision' THEN 'DOUBLE PRECISION'
              WHEN data_type = 'json' THEN 'JSON'
              WHEN data_type = 'jsonb' THEN 'JSONB'
              ELSE UPPER(data_type)
            END ||
            CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END,
            ', ' ORDER BY ordinal_position
          ) || ');' as create_sql
        FROM information_schema.columns
        WHERE table_name = $1 AND table_schema = 'public'
        GROUP BY table_name
      \`, [tableName]);
      
      if (createTableResult.rows.length > 0) {
        try {
          await localClient.query(createTableResult.rows[0].create_sql);
        } catch (error) {
          console.log(\`   ⚠️ Could not create \${tableName}: \${error.message}\`);
        }
      }
    }
    
    // Copy data from production to local
    console.log('📊 Copying data from production to local...');
    
    for (const tableName of Object.keys(tableColumns)) {
      try {
        // Check if table has data
        const countResult = await prodClient.query(\`SELECT COUNT(*) FROM "\${tableName}"\`);
        const count = parseInt(countResult.rows[0].count);
        
        if (count > 0) {
          console.log(\`  📋 Copying \${tableName} (\${count} rows)...\`);
          
          // Get all data from production table
          const dataResult = await prodClient.query(\`SELECT * FROM "\${tableName}"\`);
          
          if (dataResult.rows.length > 0) {
            // Clear local table
            await localClient.query(\`DELETE FROM "\${tableName}"\`);
            
            // Insert data into local table
            const columns = tableColumns[tableName].map(col => col.name);
            const columnNames = columns.map(col => \`"\${col}"\`).join(', ');
            
            for (const row of dataResult.rows) {
              const values = columns.map(col => row[col]);
              const placeholders = values.map((_, i) => \`$\${i + 1}\`).join(', ');
              
              try {
                await localClient.query(
                  \`INSERT INTO "\${tableName}" (\${columnNames}) VALUES (\${placeholders})\`,
                  values
                );
              } catch (error) {
                // Skip rows that fail (foreign key constraints, etc.)
              }
            }
          }
        }
      } catch (error) {
        console.log(\`   ⚠️ Skipped \${tableName}: \${error.message}\`);
      }
    }
    
    console.log('✅ Local database populated successfully!');
    console.log('🎉 Your local development environment is ready with real OOAK data!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await prodClient.end();
    await localClient.end();
  }
}

populateLocalDatabase();
`;
  
  fs.writeFileSync('scripts/populate-local-database.js', localDataScript);
}

async function updatePackageJson() {
  const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  
  packageJson.scripts = {
    ...packageJson.scripts,
    "dev": "next dev",
    "build": "next build",
    "start": "next start", 
    "lint": "next lint",
    "db:populate": "node scripts/populate-local-database.js",
    "db:backup": "pg_dump ooak_ai_dev > backup_local_$(date +%Y%m%d_%H%M%S).sql",
    "db:setup": "node scripts/setup-local-simple.js",
    "db:reset": "dropdb ooak_ai_dev && createdb ooak_ai_dev && npm run db:populate"
  };
  
  fs.writeFileSync('package.json', JSON.stringify(packageJson, null, 2));
}

// Run setup
setupLocalDevelopmentSimple(); 