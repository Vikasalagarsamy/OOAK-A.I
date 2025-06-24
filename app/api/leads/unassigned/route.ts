import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    console.log('🔍 Fetching unassigned leads...');
    
    const result = await query(`
      SELECT 
        l.id, 
        l.lead_number, 
        l.client_name, 
        l.email, 
        l.phone,
        l.company_id, 
        l.branch_id, 
        l.lead_source, 
        l.priority,
        l.created_at, 
        l.updated_at,
        l.notes,
        l.status,
        c.name as company_name,
        b.name as branch_name
      FROM leads l
      LEFT JOIN companies c ON l.company_id = c.id
      LEFT JOIN branches b ON l.branch_id = b.id
      WHERE l.assigned_to IS NULL 
      ORDER BY l.created_at DESC
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