import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import db from '@/lib/db';
import type { Branch } from '@/types/organization';

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401 }
      );
    }

    const result = await db.query<Branch>(
      'SELECT * FROM branches WHERE id = $1',
      [params.id]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      return new NextResponse(
        JSON.stringify({ error: 'Branch not found' }),
        { status: 404 }
      );
    }

    return new NextResponse(JSON.stringify(result.data[0]));
  } catch (error) {
    console.error('Error fetching branch:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to fetch branch' }),
      { status: 500 }
    );
  }
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401 }
      );
    }

    const body = await request.json();
    const { name, address, city, state, country, phone, email } = body;

    const result = await db.query<Branch>(
      `UPDATE branches 
       SET name = $1, address = $2, city = $3, state = $4, country = $5, phone = $6, email = $7, 
           updated_at = NOW(), updated_by = $8
       WHERE id = $9
       RETURNING *`,
      [name, address, city, state, country, phone, email, user.id, params.id]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      return new NextResponse(
        JSON.stringify({ error: 'Branch not found' }),
        { status: 404 }
      );
    }

    return new NextResponse(JSON.stringify(result.data[0]));
  } catch (error) {
    console.error('Error updating branch:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to update branch' }),
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401 }
      );
    }

    const result = await db.query(
      'DELETE FROM branches WHERE id = $1 RETURNING *',
      [params.id]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      return new NextResponse(
        JSON.stringify({ error: 'Branch not found' }),
        { status: 404 }
      );
    }

    return new NextResponse(JSON.stringify({ message: 'Branch deleted successfully' }));
  } catch (error) {
    console.error('Error deleting branch:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to delete branch' }),
      { status: 500 }
    );
  }
} 