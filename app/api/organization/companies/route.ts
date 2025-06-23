import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { Company, CompanyFormData } from '@/types/organization';

export async function GET() {
  const result = await query<Company>(
    'SELECT * FROM companies ORDER BY name ASC'
  );

  if (!result.success) {
    return NextResponse.json(
      { error: result.error || 'Failed to fetch companies' },
      { status: 500 }
    );
  }

  return NextResponse.json(result.data);
}

export async function POST(request: Request) {
  try {
    const data: CompanyFormData = await request.json();

    const result = await query<Company>(
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

    if (!result.success) {
      return NextResponse.json(
        { error: result.error || 'Failed to create company' },
        { status: 500 }
      );
    }

    return NextResponse.json(result.data?.[0]);
  } catch (error) {
    console.error('Error creating company:', error);
    return NextResponse.json(
      { error: 'Failed to create company' },
      { status: 500 }
    );
  }
} 