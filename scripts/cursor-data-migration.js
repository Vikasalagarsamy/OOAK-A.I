const { Pool } = require('pg');
const fs = require('fs/promises');
const path = require('path');

// Development database configuration
const DEV_CONFIG = {
  user: 'vikasalagarsamy',
  host: 'localhost',
  database: 'ooak_ai_db',
  port: 5432
};

// Production database configuration
const PROD_CONFIG = {
  connectionString: 'postgresql://ooak_admin:mSglqEawN72hkoEj8tSNF5qv9vJr3U6k@dpg-d1bf04er433s739icgmg-a.singapore-postgres.render.com/ooak_ai_db',
  ssl: { rejectUnauthorized: false },
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Create pools
const devPool = new Pool(DEV_CONFIG);
const prodPool = new Pool(PROD_CONFIG);

async function getTableColumns(client, tableName) {
  const { rows } = await client.query(`
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = $1
  `, [tableName]);
  return rows.map(row => row.column_name);
}

async function migrateTable(devClient, prodClient, tableName, orderBy = 'id') {
  console.log(`\n📦 Migrating ${tableName}...`);
  
  try {
    // Get column lists from both databases
    const devColumns = await getTableColumns(devClient, tableName);
    const prodColumns = await getTableColumns(prodClient, tableName);
    
    // Find common columns
    const commonColumns = devColumns.filter(col => prodColumns.includes(col));
    
    if (commonColumns.length === 0) {
      console.log(`❌ No matching columns found in ${tableName}`);
      return;
    }

    // Get data from development using only common columns
    const { rows } = await devClient.query(`
      SELECT ${commonColumns.join(', ')} 
      FROM ${tableName} 
      ORDER BY ${orderBy}
    `);
    
    if (rows.length === 0) {
      console.log(`ℹ️  No data in ${tableName} to migrate`);
      return;
    }

    // Insert each row
    for (const row of rows) {
      const columnList = commonColumns.join(', ');
      const valuePlaceholders = commonColumns.map((_, i) => `$${i + 1}`).join(', ');
      const values = commonColumns.map(col => row[col]);

      try {
        await prodClient.query(`
          INSERT INTO ${tableName} (${columnList})
          VALUES (${valuePlaceholders})
          ON CONFLICT DO NOTHING
        `, values);
      } catch (error) {
        console.error(`❌ Error inserting into ${tableName}:`, error.message);
        throw error;
      }
    }

    console.log(`✅ Migrated ${rows.length} rows from ${tableName}`);
    if (devColumns.length !== prodColumns.length) {
      console.log(`ℹ️  Note: Schema difference detected`);
      console.log(`   Dev columns: ${devColumns.length}`);
      console.log(`   Prod columns: ${prodColumns.length}`);
      console.log(`   Only migrated common columns: ${commonColumns.length}`);
    }
  } catch (error) {
    console.error(`❌ Error migrating ${tableName}:`, error.message);
    throw error;
  }
}

async function runDataMigration() {
  const devClient = await devPool.connect();
  const prodClient = await prodPool.connect();
  
  try {
    // Start transaction
    await prodClient.query('BEGIN');

    try {
      // Get list of tables
      const { rows: tables } = await devClient.query(`
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        ORDER BY tablename;
      `);

      // Define migration order (tables with foreign keys should come after their dependencies)
      const migrationOrder = [
        'designations',
        'companies',
        'branches',
        'departments',
        'roles',
        'employees',
        'menu_items',
        'designation_menu_permissions',
        'lead_sources',
        'leads',
        'lead_assignments'
      ];

      // Migrate each table in order
      for (const tableName of migrationOrder) {
        if (tables.some(t => t.tablename === tableName)) {
          await migrateTable(devClient, prodClient, tableName);
        }
      }

      // Verify the migration
      console.log('\n🔍 Verifying migration...');
      
      for (const tableName of migrationOrder) {
        if (tables.some(t => t.tablename === tableName)) {
          const devCount = (await devClient.query(`SELECT COUNT(*) FROM ${tableName}`)).rows[0].count;
          const prodCount = (await prodClient.query(`SELECT COUNT(*) FROM ${tableName}`)).rows[0].count;
          
          console.log(`\n📊 ${tableName}:`);
          console.log(`   Development: ${devCount} rows`);
          console.log(`   Production:  ${prodCount} rows`);
        }
      }

      await prodClient.query('COMMIT');
      console.log('\n✅ Data migration completed successfully');

    } catch (error) {
      await prodClient.query('ROLLBACK');
      throw error;
    }

  } catch (error) {
    console.error('\n❌ Data migration failed:', error.message);
    process.exit(1);
  } finally {
    await devClient.release();
    await prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

console.log('🚀 Starting Complete Data Migration...\n');
runDataMigration(); 
      // 1. Insert MANAGING DIRECTOR designation
      console.log('📝 Adding MANAGING DIRECTOR designation...');
      await client.query(`
        INSERT INTO designations (name, description)
        VALUES ('MANAGING DIRECTOR', 'Managing Director of OOAK.AI')
        ON CONFLICT (name) DO NOTHING
        RETURNING id;
      `);

      // 2. Insert System Administration menu item
      console.log('📝 Adding System Administration menu item...');
      const sysAdminResult = await client.query(`
        INSERT INTO menu_items (
          name, 
          path, 
          icon, 
          parent_id,
          string_id,
          section_name,
          is_admin_only,
          sort_order,
          is_visible
        )
        VALUES (
          'System Administration',
          '/admin',
          'Settings',
          NULL,
          'system-administration',
          'Administration',
          true,
          100,
          true
        )
        ON CONFLICT (string_id) DO NOTHING
        RETURNING id;
      `);

      // 3. Insert Menu Permissions under System Administration
      console.log('📝 Adding Menu Permissions menu item...');
      if (sysAdminResult.rows.length > 0) {
        const menuPermResult = await client.query(`
          INSERT INTO menu_items (
            name,
            path,
            icon,
            parent_id,
            string_id,
            section_name,
            is_admin_only,
            sort_order,
            is_visible
          )
          VALUES (
            'Menu Permissions',
            '/admin/menu-permissions',
            'Settings',
            $1,
            'menu-permissions',
            'Configuration',
            true,
            10,
            true
          )
          ON CONFLICT (string_id) DO NOTHING
          RETURNING id;
        `, [sysAdminResult.rows[0].id]);

        // 4. Set permissions for MANAGING DIRECTOR
        if (menuPermResult.rows.length > 0) {
          console.log('📝 Setting up permissions for MANAGING DIRECTOR...');
          await client.query(`
            INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
            SELECT 
              d.id,
              $1,
              true
            FROM designations d
            WHERE d.name = 'MANAGING DIRECTOR'
            ON CONFLICT (designation_id, menu_item_id) DO NOTHING;
          `, [menuPermResult.rows[0].id]);
        }
      }

      // 5. Verify the data
      console.log('\n🔍 Verifying data...');
      
      // Check menu items
      const menuItems = await client.query(`
        SELECT 
          mi.name,
          mi.path,
          mi.section_name,
          p.name as parent_name
        FROM menu_items mi
        LEFT JOIN menu_items p ON p.id = mi.parent_id
        WHERE mi.string_id IN ('system-administration', 'menu-permissions')
        ORDER BY mi.sort_order;
      `);

      console.log('\n📋 Menu Structure:');
      console.log('===============');
      menuItems.rows.forEach(item => {
        console.log(`📦 ${item.name}`);
        console.log(`   Path: ${item.path}`);
        console.log(`   Section: ${item.section_name}`);
        console.log(`   Parent: ${item.parent_name || 'None'}`);
        console.log('---------------');
      });

      // Check permissions
      const permissions = await client.query(`
        SELECT 
          d.name as designation,
          mi.name as menu_item,
          dmp.can_view
        FROM designation_menu_permissions dmp
        JOIN designations d ON d.id = dmp.designation_id
        JOIN menu_items mi ON mi.id = dmp.menu_item_id
        WHERE mi.string_id IN ('system-administration', 'menu-permissions')
        ORDER BY d.name, mi.name;
      `);

      console.log('\n📋 Permissions:');
      console.log('============');
      permissions.rows.forEach(perm => {
        console.log(`👤 ${perm.designation}`);
        console.log(`   Menu: ${perm.menu_item}`);
        console.log(`   Can View: ${perm.can_view}`);
        console.log('---------------');
      });

    } finally {
      client.release();
    }

  } catch (error) {
    console.error('❌ Data migration failed:', error);
    process.exit(1);
  }
}

// Run the data migration
console.log('🚀 Starting Cursor Production Data Migration...\n');
runDataMigration().catch(console.error); 

  } catch (error) {
    console.error('\n❌ Data migration failed:', error.message);
    process.exit(1);
  } finally {
    await devClient.release();
    await prodClient.release();
    await devPool.end();
    await prodPool.end();
  }
}

console.log('🚀 Starting Complete Data Migration...\n');
runDataMigration(); 