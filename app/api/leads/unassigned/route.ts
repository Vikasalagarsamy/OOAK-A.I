import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    console.log('🔍 Fetching unassigned leads...');
    
    const result = await query(`
      SELECT 
        id, lead_number, client_name, email, phone,
        company_id, branch_id, lead_source, priority,
        created_at, updated_at
      FROM leads 
      WHERE assigned_to IS NULL 
      ORDER BY created_at DESC
    `);

    if (!result.success || !result.data) {
      throw new Error(result.error || 'Failed to fetch unassigned leads');
    }

    console.log('✅ Unassigned leads fetched successfully:', result.data.length);

    return NextResponse.json({
      success: true,
      leads: result.data,
    });
  } catch (error) {
    console.error('❌ Error fetching unassigned leads:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch unassigned leads', error: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
} 