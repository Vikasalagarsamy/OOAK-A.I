import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    console.log('🔍 Fetching companies...');
    
    const result = await query(`
      SELECT id, name, company_code, address, phone, email 
      FROM companies 
      ORDER BY name ASC
    `);

    if (!result.success || !result.data) {
      throw new Error(result.error || 'Failed to fetch companies');
    }

    console.log('✅ Companies fetched successfully:', result.data.length);

    return NextResponse.json({
      success: true,
      companies: result.data,
    });
  } catch (error) {
    console.error('❌ Error fetching companies:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch companies', error: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
} 