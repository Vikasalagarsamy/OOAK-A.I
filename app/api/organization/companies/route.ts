import { NextResponse } from 'next/server'
import { getDbPool } from '@/lib/db'
import { Pool } from 'pg'

// GET /api/organization/companies
export async function GET() {
  const pool: Pool = getDbPool()

  try {
    const result = await pool.query(
      `SELECT 
        id, 
        name,
        company_code,
        registration_number,
        tax_id,
        address,
        phone,
        email,
        website,
        founded_date,
        created_at,
        updated_at
      FROM companies 
      ORDER BY name`
    )

    return NextResponse.json({
      success: true,
      companies: result.rows
    })
  } catch (error) {
    console.error('Error fetching companies:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch companies' },
      { status: 500 }
    )
  }
}

export async function POST(request: Request) {
  const pool: Pool = getDbPool()
  
  try {
    const data = await request.json();

    const result = await pool.query(
      `INSERT INTO companies (
        name, registration_number, tax_id, address, phone, 
        email, website, founded_date, company_code
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
      RETURNING *`,
      [
        data.name,
        data.registration_number || null,
        data.tax_id || null,
        data.address || null,
        data.phone || null,
        data.email || null,
        data.website || null,
        data.founded_date || null,
        data.company_code || null,
      ]
    );

    return NextResponse.json({
      success: true,
      company: result.rows[0]
    });
  } catch (error) {
    console.error('Error creating company:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to create company' },
      { status: 500 }
    );
  }
} 