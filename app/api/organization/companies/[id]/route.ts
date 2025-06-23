import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { Company, CompanyFormData } from '@/types/organization';

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  const result = await query<Company>(
    'SELECT * FROM companies WHERE id = $1',
    [params.id]
  );

  if (!result.success) {
    return NextResponse.json(
      { error: result.error || 'Failed to fetch company' },
      { status: 500 }
    );
  }

  if (!result.data?.length) {
    return NextResponse.json(
      { error: 'Company not found' },
      { status: 404 }
    );
  }

  return NextResponse.json(result.data[0]);
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const data: CompanyFormData = await request.json();

    const result = await query<Company>(
      `UPDATE companies SET 
        name = $1,
        registration_number = $2,
        tax_id = $3,
        address = $4,
        phone = $5,
        email = $6,
        website = $7,
        founded_date = $8,
        company_code = $9,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $10
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
        params.id,
      ]
    );

    if (!result.success) {
      return NextResponse.json(
        { error: result.error || 'Failed to update company' },
        { status: 500 }
      );
    }

    if (!result.data?.length) {
      return NextResponse.json(
        { error: 'Company not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(result.data[0]);
  } catch (error) {
    console.error('Error updating company:', error);
    return NextResponse.json(
      { error: 'Failed to update company' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  const result = await query<Company>(
    'DELETE FROM companies WHERE id = $1 RETURNING *',
    [params.id]
  );

  if (!result.success) {
    return NextResponse.json(
      { error: result.error || 'Failed to delete company' },
      { status: 500 }
    );
  }

  if (!result.data?.length) {
    return NextResponse.json(
      { error: 'Company not found' },
      { status: 404 }
    );
  }

  return NextResponse.json(result.data[0]);
} 