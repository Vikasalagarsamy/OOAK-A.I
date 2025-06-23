import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    console.log('🔍 Fetching branches...');
    
    // Get company_id from query params if provided
    const { searchParams } = new URL(request.url);
    const companyId = searchParams.get('company_id');

    let result;
    if (companyId) {
      console.log('🔍 Filtering branches by company_id:', companyId);
      result = await query(`
        SELECT id, name, company_id, branch_code, address, phone, email, location
        FROM branches
        WHERE company_id = $1
        ORDER BY name ASC
      `, [parseInt(companyId)]);
    } else {
      result = await query(`
        SELECT id, name, company_id, branch_code, address, phone, email, location
        FROM branches
        ORDER BY name ASC
      `);
    }

    if (!result.success || !result.data) {
      throw new Error(result.error || 'Failed to fetch branches');
    }

    console.log('✅ Branches fetched successfully:', result.data.length);

    return NextResponse.json({
      success: true,
      branches: result.data,
    });
  } catch (error) {
    console.error('❌ Error fetching branches:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch branches', error: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
} 