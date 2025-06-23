import { NextResponse } from 'next/server';
import db from '@/lib/db';
import { Branch } from '@/types/organization';

export async function GET() {
  try {
    const result = await db.query<Branch>(`
      SELECT b.*, c.name as company_name
      FROM branches b
      LEFT JOIN companies c ON b.company_id = c.id
      ORDER BY b.name
    `);

    return NextResponse.json(result.rows);
  } catch (error) {
    console.error('Error fetching branches:', error);
    return NextResponse.json(
      { error: 'Failed to fetch branches' },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const data = await request.json();

    // Validate required fields
    if (!data.name || !data.company_id || !data.address) {
      return NextResponse.json(
        { error: 'Name, company ID, and address are required' },
        { status: 400 }
      );
    }

    const result = await db.query<Branch>(
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

    return NextResponse.json(result.rows[0]);
  } catch (error) {
    console.error('Error creating branch:', error);
    return NextResponse.json(
      { error: 'Failed to create branch' },
      { status: 500 }
    );
  }
} 