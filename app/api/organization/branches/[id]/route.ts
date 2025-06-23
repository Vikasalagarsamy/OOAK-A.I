import { NextResponse } from 'next/server';
import db from '@/lib/db';
import { Branch } from '@/types/organization';

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const data = await request.json();

    // Validate required fields
    if (!data.name || !data.company_id || !data.address) {
      return NextResponse.json(
        { error: 'Name, company ID, and address are required' },
        { status: 400 }
      );
    }

    const result = await db.query<Branch>(
      `UPDATE branches SET
        name = $1,
        company_id = $2,
        address = $3,
        phone = $4,
        email = $5,
        manager_id = $6,
        is_remote = $7,
        branch_code = $8,
        location = $9,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $10
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
        data.location || null,
        id
      ]
    );

    if (result.rowCount === 0) {
      return NextResponse.json(
        { error: 'Branch not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating branch:', error);
    return NextResponse.json(
      { error: 'Failed to update branch' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const result = await db.query(
      'DELETE FROM branches WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rowCount === 0) {
      return NextResponse.json(
        { error: 'Branch not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting branch:', error);
    return NextResponse.json(
      { error: 'Failed to delete branch' },
      { status: 500 }
    );
  }
} 