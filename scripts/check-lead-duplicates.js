const { Pool } = require('pg');

// Development database configuration
const devConfig = {
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_dev',
  user: 'vikasalagarsamy',
  password: ''
};

// Production database configuration
const prodConfig = {
  host: 'localhost',
  port: 5432,
  database: 'ooak_ai_prod',
  user: 'vikasalagarsamy',
  password: ''
};

const devPool = new Pool(devConfig);
const prodPool = new Pool(prodConfig);

async function checkDuplicateLeads(pool, dbName) {
  console.log(`\nChecking for duplicate leads in ${dbName} database...`);
  console.log('=================================================');

  // Check duplicates by phone number
  const phoneQuery = `
    WITH duplicate_check AS (
      SELECT 
        phone,
        COUNT(*) as count,
        array_agg(id ORDER BY id) as lead_ids,
        array_agg(client_name ORDER BY id) as names,
        array_agg(created_at ORDER BY id) as created_dates,
        array_agg(status ORDER BY id) as statuses,
        array_agg(email ORDER BY id) as emails,
        array_agg(lead_number ORDER BY id) as lead_numbers
      FROM leads 
      WHERE phone IS NOT NULL AND phone != ''
      GROUP BY phone
      HAVING COUNT(*) > 1
    )
    SELECT * FROM duplicate_check ORDER BY count DESC, phone;
  `;

  // Check duplicates by email
  const emailQuery = `
    WITH duplicate_check AS (
      SELECT 
        email,
        COUNT(*) as count,
        array_agg(id ORDER BY id) as lead_ids,
        array_agg(client_name ORDER BY id) as names,
        array_agg(created_at ORDER BY id) as created_dates,
        array_agg(status ORDER BY id) as statuses,
        array_agg(phone ORDER BY id) as phones,
        array_agg(lead_number ORDER BY id) as lead_numbers
      FROM leads 
      WHERE email IS NOT NULL AND email != ''
      GROUP BY email
      HAVING COUNT(*) > 1
    )
    SELECT * FROM duplicate_check ORDER BY count DESC, email;
  `;

  // Get total leads count
  const totalQuery = `SELECT COUNT(*) as total FROM leads;`;
  const totalResult = await pool.query(totalQuery);
  const totalLeads = parseInt(totalResult.rows[0].total);

  console.log(`Total leads: ${totalLeads}`);
  console.log('\nDuplicates by Phone Number:');
  console.log('---------------------------');

  const phoneResults = await pool.query(phoneQuery);
  if (phoneResults.rows.length === 0) {
    console.log('No duplicate phone numbers found.');
  } else {
    phoneResults.rows.forEach(row => {
      console.log(`\nPhone: ${row.phone}`);
      console.log(`Count: ${row.count}`);
      console.log('Details:');
      for (let i = 0; i < row.lead_ids.length; i++) {
        console.log(`  ${i + 1}. Lead #${row.lead_numbers[i]}`);
        console.log(`     ID: ${row.lead_ids[i]}`);
        console.log(`     Name: ${row.names[i]}`);
        console.log(`     Email: ${row.emails[i] || 'N/A'}`);
        console.log(`     Created: ${new Date(row.created_dates[i]).toLocaleString()}`);
        console.log(`     Status: ${row.statuses[i]}`);
      }
    });
  }

  console.log('\nDuplicates by Email:');
  console.log('-------------------');

  const emailResults = await pool.query(emailQuery);
  if (emailResults.rows.length === 0) {
    console.log('No duplicate emails found.');
  } else {
    emailResults.rows.forEach(row => {
      console.log(`\nEmail: ${row.email}`);
      console.log(`Count: ${row.count}`);
      console.log('Details:');
      for (let i = 0; i < row.lead_ids.length; i++) {
        console.log(`  ${i + 1}. Lead #${row.lead_numbers[i]}`);
        console.log(`     ID: ${row.lead_ids[i]}`);
        console.log(`     Name: ${row.names[i]}`);
        console.log(`     Phone: ${row.phones[i] || 'N/A'}`);
        console.log(`     Created: ${new Date(row.created_dates[i]).toLocaleString()}`);
        console.log(`     Status: ${row.statuses[i]}`);
      }
    });
  }

  return {
    totalLeads,
    duplicatePhones: phoneResults.rows.length,
    duplicateEmails: emailResults.rows.length,
    phoneDetails: phoneResults.rows,
    emailDetails: emailResults.rows
  };
}

async function main() {
  try {
    console.log('Checking for duplicate leads...');
    const devResults = await checkDuplicateLeads(devPool, 'Development');

    console.log('\nSummary:');
    console.log('========');
    console.log('Development Database:');
    console.log(`- Total Leads: ${devResults.totalLeads}`);
    console.log(`- Number of Phone Numbers with Duplicates: ${devResults.duplicatePhones}`);
    console.log(`- Number of Emails with Duplicates: ${devResults.duplicateEmails}`);

    // Calculate total duplicate leads
    const totalDuplicateLeads = devResults.phoneDetails.reduce((acc, curr) => acc + curr.count - 1, 0) +
                               devResults.emailDetails.reduce((acc, curr) => acc + curr.count - 1, 0);
    
    console.log(`- Total Duplicate Leads: ${totalDuplicateLeads}`);

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await devPool.end();
    await prodPool.end();
  }
}

main(); 