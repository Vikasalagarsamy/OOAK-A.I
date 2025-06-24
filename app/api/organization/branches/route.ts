import { NextResponse } from 'next/server';
import { getPool } from '@/lib/db';
import { Pool } from 'pg';

export async function GET() {
  const pool: Pool = getPool();

  try {
    const result = await pool.query(`
      SELECT 
        b.id,
        b.name,
        b.company_id,
        b.address,
        b.phone,
        b.email,
        b.manager_id,
        b.is_remote,
        b.branch_code,
        b.location,
        b.created_at,
        b.updated_at,
        c.name as company_name
      FROM branches b
      LEFT JOIN companies c ON b.company_id = c.id
      ORDER BY b.name
    `);

    return NextResponse.json({
      success: true,
      branches: result.rows
    });
  } catch (error) {
    console.error('Error fetching branches:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch branches' },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  const pool: Pool = getPool();

  try {
    const data = await request.json();

    // Validate required fields
    if (!data.name || !data.company_id || !data.address) {
      return NextResponse.json(
        { success: false, error: 'Name, company ID, and address are required' },
        { status: 400 }
      );
    }

    const result = await pool.query(
      `INSERT INTO branches (
        name,
        company_id,
        address,
        phone,
        email,
        manager_id,
        is_remote,
        branch_code,
        location
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *`,
      [
        data.name,
        data.company_id,
        data.address,
        data.phone || null,
        data.email || null,
        data.manager_id || null,
        data.is_remote || false,
        data.branch_code || null,
        data.location || null
      ]
    );

    // After inserting, fetch the company name for the response
    const branchWithCompany = await pool.query(`
      SELECT 
        b.*,
        c.name as company_name
      FROM branches b
      LEFT JOIN companies c ON b.company_id = c.id
      WHERE b.id = $1
    `, [result.rows[0].id]);

    return NextResponse.json({
      success: true,
      branch: branchWithCompany.rows[0]
    });
  } catch (error) {
    console.error('Error creating branch:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to create branch' },
      { status: 500 }
    );
  }
} 