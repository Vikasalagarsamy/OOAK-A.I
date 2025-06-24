const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');

// Load environment variables
require('dotenv').config();

// Database configuration
const getDbConfig = () => {
    if (process.env.NODE_ENV === 'production' && process.env.DATABASE_URL) {
        return {
            connectionString: process.env.DATABASE_URL,
            ssl: { rejectUnauthorized: false },
            max: 20,
            idleTimeoutMillis: 30000,
            connectionTimeoutMillis: 10000,
        };
    }

    return {
        host: process.env.POSTGRES_HOST || 'localhost',
        port: parseInt(process.env.POSTGRES_PORT || '5432'),
        database: process.env.POSTGRES_DB || 'ooak_ai_dev',
        user: process.env.POSTGRES_USER || 'vikasalagarsamy',
        password: process.env.POSTGRES_PASSWORD || '',
        ssl: false,
        max: 10,
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 10000,
    };
};

// Initialize database connection
const pool = new Pool(getDbConfig());

async function executeColumnRemoval() {
    const client = await pool.connect();
    
    try {
        // Read the SQL script
        const sqlScript = fs.readFileSync(
            path.join(__dirname, 'remove_legacy_employee_columns.sql'),
            'utf8'
        );

        console.log('Starting column removal process...');
        
        // Execute the script
        await client.query(sqlScript);
        
        // Run verification queries
        const columnCheck = await client.query(`
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'employees' 
            AND column_name IN ('primary_company_id', 'home_branch_id')
        `);
        
        const employeeCount = await client.query('SELECT COUNT(*) FROM employee_company_assignments_v');
        const backupCount = await client.query('SELECT COUNT(*) FROM employees_column_backup');
        
        // Log results
        console.log('\nVerification Results:');
        console.log('- Legacy columns present:', columnCheck.rows.length === 0 ? 'No ✅' : 'Yes ❌');
        console.log('- Employees in view:', employeeCount.rows[0].count);
        console.log('- Backup records:', backupCount.rows[0].count);
        
        console.log('\nColumn removal completed successfully! ✅');
        
    } catch (error) {
        console.error('Error during column removal:', error);
        throw error;
    } finally {
        client.release();
        await pool.end();
    }
}

// Execute if run directly
if (require.main === module) {
    executeColumnRemoval()
        .catch(error => {
            console.error('Failed to remove columns:', error);
            process.exit(1);
        });
} 