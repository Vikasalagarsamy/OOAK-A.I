const { Pool } = require('pg');
const readline = require('readline');

// Production database configuration
const RENDER_DATABASE_URL = 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db';

const pool = new Pool({
  connectionString: RENDER_DATABASE_URL,
  ssl: { 
    rejectUnauthorized: false,
    require: true
  },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 15000,
});

// Create readline interface for interactive commands
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

class DatabaseViewer {
  constructor() {
    this.client = null;
  }

  async connect() {
    console.log('🔗 Connecting to OOAK.AI Production Database...\n');
    this.client = await pool.connect();
    console.log('✅ Connected successfully!\n');
  }

  async showDatabaseOverview() {
    console.log('📊 OOAK.AI DATABASE OVERVIEW');
    console.log('============================\n');

    // Database info
    const dbInfo = await this.client.query('SELECT current_database(), current_user, version()');
    console.log(`🗄️  Database: ${dbInfo.rows[0].current_database}`);
    console.log(`👤 User: ${dbInfo.rows[0].current_user}`);
    console.log(`🐘 PostgreSQL Version: ${dbInfo.rows[0].version.split(' ')[1]}\n`);

    // Table count and sizes
    const tableStats = await this.client.query(`
      SELECT 
        schemaname,
        COUNT(*) as table_count,
        pg_size_pretty(SUM(pg_total_relation_size(schemaname||'.'||tablename))) as total_size
      FROM pg_tables 
      WHERE schemaname = 'public'
      GROUP BY schemaname
    `);

    console.log('📋 SCHEMA STATISTICS:');
    console.log('====================');
    tableStats.rows.forEach(row => {
      console.log(`📊 Schema: ${row.schemaname} | Tables: ${row.table_count} | Size: ${row.total_size}`);
    });
    console.log();
  }

  async listTables() {
    console.log('📋 ALL TABLES IN OOAK.AI DATABASE');
    console.log('=================================\n');

    const tablesQuery = await this.client.query(`
      SELECT 
        t.table_name,
        (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count,
        pg_size_pretty(pg_total_relation_size(t.table_name)) as size,
        obj_description(c.oid) as description
      FROM information_schema.tables t
      LEFT JOIN pg_class c ON c.relname = t.table_name
      WHERE t.table_schema = 'public' 
      AND t.table_type = 'BASE TABLE'
      ORDER BY t.table_name
    `);

    console.log(`Found ${tablesQuery.rows.length} tables:\n`);
    
    // Group tables by category
    const categories = {
      'Core Business': ['leads', 'clients', 'quotations', 'bookings', 'deliverables', 'payments'],
      'AI & Automation': ['ai_configurations', 'ai_tasks', 'ai_recommendations', 'ai_performance_tracking'],
      'Communication': ['communications', 'notifications', 'whatsapp_messages', 'chat_logs'],
      'Analytics': ['analytics_metrics', 'call_analytics', 'user_behavior_analytics', 'revenue_forecasts'],
      'Management': ['employees', 'departments', 'roles', 'permissions', 'companies'],
      'Services': ['services', 'service_packages', 'vendors', 'suppliers']
    };

    for (const [category, tableNames] of Object.entries(categories)) {
      console.log(`\n🏷️  ${category.toUpperCase()}:`);
      console.log('='.repeat(category.length + 4));
      
      tablesQuery.rows
        .filter(row => tableNames.some(name => row.table_name.includes(name)))
        .forEach(row => {
          console.log(`✅ ${row.table_name.padEnd(30)} | ${row.column_count.toString().padStart(2)} cols | ${row.size.padStart(8)}`);
        });
    }

    // Show remaining tables
    const categorizedTables = Object.values(categories).flat();
    const otherTables = tablesQuery.rows.filter(row => 
      !categorizedTables.some(name => row.table_name.includes(name))
    );

    if (otherTables.length > 0) {
      console.log(`\n🏷️  OTHER TABLES:`);
      console.log('================');
      otherTables.forEach(row => {
        console.log(`✅ ${row.table_name.padEnd(30)} | ${row.column_count.toString().padStart(2)} cols | ${row.size.padStart(8)}`);
      });
    }

    console.log(`\n📊 Total: ${tablesQuery.rows.length} tables`);
  }

  async viewTable(tableName) {
    console.log(`\n🔍 VIEWING TABLE: ${tableName.toUpperCase()}`);
    console.log('='.repeat(20 + tableName.length) + '\n');

    try {
      // Get table structure
      const structure = await this.client.query(`
        SELECT 
          column_name,
          data_type,
          is_nullable,
          column_default,
          character_maximum_length
        FROM information_schema.columns 
        WHERE table_name = $1 
        ORDER BY ordinal_position
      `, [tableName]);

      console.log('📋 TABLE STRUCTURE:');
      console.log('==================');
      structure.rows.forEach(col => {
        const nullable = col.is_nullable === 'YES' ? 'NULL' : 'NOT NULL';
        const length = col.character_maximum_length ? `(${col.character_maximum_length})` : '';
        console.log(`🔹 ${col.column_name.padEnd(25)} | ${(col.data_type + length).padEnd(20)} | ${nullable.padEnd(8)} | ${col.column_default || 'No default'}`);
      });

      // Get row count
      const countResult = await this.client.query(`SELECT COUNT(*) as count FROM ${tableName}`);
      const rowCount = parseInt(countResult.rows[0].count);
      console.log(`\n📊 Total Records: ${rowCount.toLocaleString()}`);

      // Show sample data if exists
      if (rowCount > 0) {
        console.log('\n📄 SAMPLE DATA (First 5 rows):');
        console.log('==============================');
        
        const sampleData = await this.client.query(`SELECT * FROM ${tableName} LIMIT 5`);
        
        if (sampleData.rows.length > 0) {
          // Show column headers
          const columns = Object.keys(sampleData.rows[0]);
          console.log(columns.map(col => col.padEnd(15)).join(' | '));
          console.log(columns.map(() => ''.padEnd(15, '-')).join('-|-'));
          
          // Show data rows
          sampleData.rows.forEach(row => {
            const values = columns.map(col => {
              let value = row[col];
              if (value === null) return 'NULL';
              if (typeof value === 'object') return JSON.stringify(value).substring(0, 12) + '...';
              return String(value).substring(0, 15);
            });
            console.log(values.map(val => val.padEnd(15)).join(' | '));
          });
        }
      } else {
        console.log('\n📭 No data in this table yet.');
      }

    } catch (error) {
      console.error(`❌ Error viewing table ${tableName}:`, error.message);
    }
  }

  async showBusinessMetrics() {
    console.log('\n📈 OOAK.AI BUSINESS METRICS');
    console.log('===========================\n');

    const metrics = [
      {
        name: 'Lead Management',
        queries: [
          { label: 'Total Leads', query: 'SELECT COUNT(*) as count FROM leads' },
          { label: 'New Leads', query: "SELECT COUNT(*) as count FROM leads WHERE status = 'new'" },
          { label: 'Converted Leads', query: "SELECT COUNT(*) as count FROM leads WHERE status = 'converted'" }
        ]
      },
      {
        name: 'Client Portfolio',
        queries: [
          { label: 'Total Clients', query: 'SELECT COUNT(*) as count FROM clients' },
          { label: 'Active Clients', query: "SELECT COUNT(*) as count FROM clients WHERE status = 'active'" }
        ]
      },
      {
        name: 'Revenue Pipeline',
        queries: [
          { label: 'Total Quotations', query: 'SELECT COUNT(*) as count FROM quotations' },
          { label: 'Approved Quotes', query: "SELECT COUNT(*) as count FROM quotations WHERE status = 'approved'" },
          { label: 'Pending Quotes', query: "SELECT COUNT(*) as count FROM quotations WHERE status = 'pending'" }
        ]
      },
      {
        name: 'AI Performance',
        queries: [
          { label: 'AI Configurations', query: 'SELECT COUNT(*) as count FROM ai_configurations' },
          { label: 'Active AI Tasks', query: "SELECT COUNT(*) as count FROM ai_tasks WHERE status = 'active'" },
          { label: 'AI Recommendations', query: 'SELECT COUNT(*) as count FROM ai_recommendations' }
        ]
      }
    ];

    for (const category of metrics) {
      console.log(`🏷️  ${category.name.toUpperCase()}:`);
      console.log('='.repeat(category.name.length + 4));
      
      for (const metric of category.queries) {
        try {
          const result = await this.client.query(metric.query);
          const count = result.rows[0].count || 0;
          console.log(`📊 ${metric.label.padEnd(20)}: ${count.toLocaleString()}`);
        } catch (error) {
          console.log(`❌ ${metric.label.padEnd(20)}: Error reading data`);
        }
      }
      console.log();
    }
  }

  async interactiveMode() {
    console.log('\n🎮 INTERACTIVE DATABASE EXPLORER');
    console.log('================================\n');
    console.log('Available commands:');
    console.log('📋 list         - Show all tables');
    console.log('🔍 view <table> - View specific table details');
    console.log('📊 metrics      - Show business metrics');
    console.log('🔄 overview     - Show database overview');
    console.log('❌ exit         - Exit interactive mode\n');

    const askCommand = () => {
      rl.question('🎯 Enter command: ', async (input) => {
        const [command, ...args] = input.trim().split(' ');

        switch (command.toLowerCase()) {
          case 'list':
            await this.listTables();
            break;
          case 'view':
            if (args.length > 0) {
              await this.viewTable(args[0]);
            } else {
              console.log('❌ Please specify a table name. Example: view leads');
            }
            break;
          case 'metrics':
            await this.showBusinessMetrics();
            break;
          case 'overview':
            await this.showDatabaseOverview();
            break;
          case 'exit':
            console.log('\n👋 Goodbye! Your OOAK.AI database is ready for production!');
            await this.disconnect();
            rl.close();
            return;
          default:
            console.log('❌ Unknown command. Type "exit" to quit.');
        }

        console.log('\n' + '='.repeat(50));
        askCommand();
      });
    };

    askCommand();
  }

  async disconnect() {
    if (this.client) {
      this.client.release();
      await pool.end();
    }
  }
}

// Main execution
async function main() {
  const viewer = new DatabaseViewer();
  
  try {
    await viewer.connect();
    await viewer.showDatabaseOverview();
    await viewer.listTables();
    await viewer.showBusinessMetrics();
    await viewer.interactiveMode();
  } catch (error) {
    console.error('\n❌ Database Viewer Error:', error.message);
    await viewer.disconnect();
    process.exit(1);
  }
}

// Handle process termination
process.on('SIGINT', async () => {
  console.log('\n\n👋 Shutting down database viewer...');
  await pool.end();
  process.exit(0);
});

main().catch(console.error); 