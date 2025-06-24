import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.employee_id) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Get leads assigned to the current employee
    const result = await query(`
      SELECT 
        l.id,
        l.lead_number,
        l.client_name,
        l.email,
        l.phone,
        l.country_code,
        l.is_whatsapp,
        l.has_separate_whatsapp,
        l.whatsapp_country_code,
        l.whatsapp_number,
        l.status,
        l.lead_source,
        l.priority,
        l.created_at,
        l.assigned_at,
        c.name as company_name,
        b.name as branch_name,
        l.notes,
        l.bride_name,
        l.groom_name,
        l.wedding_date,
        l.venue_preference,
        l.guest_count,
        l.budget_range,
        l.expected_value,
        l.description,
        l.location,
        l.tags,
        l.lead_score,
        l.conversion_stage,
        l.last_contact_date,
        l.next_follow_up_date
      FROM leads l
      LEFT JOIN companies c ON l.company_id = c.id
      LEFT JOIN branches b ON l.branch_id = b.id
      WHERE l.assigned_to = (
        SELECT id FROM employees WHERE employee_id = $1
      )
      ORDER BY 
        CASE 
          WHEN l.priority = 'high' THEN 1
          WHEN l.priority = 'medium' THEN 2
          ELSE 3
        END,
        l.created_at DESC
    `, [session.user.employee_id]);

    if (!result.success) {
      throw new Error(result.error || 'Failed to fetch leads');
    }

    return NextResponse.json({
      success: true,
      leads: result.data,
    });
  } catch (error) {
    console.error('Error fetching my leads:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch leads' },
      { status: 500 }
    );
  }
} 