import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export const dynamic = 'force-dynamic';

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }

    const id = parseInt(params.id);
    if (isNaN(id)) {
      return NextResponse.json(
        { success: false, message: 'Invalid lead ID' },
        { status: 400 }
      );
    }

    const body = await request.json();
    console.log('Request body:', body);

    const {
      client_name,
      email,
      phone,
      country_code,
      is_whatsapp,
      has_separate_whatsapp,
      whatsapp_country_code,
      whatsapp_number,
      priority,
      bride_name,
      groom_name,
      wedding_date,
      venue_preference,
      guest_count,
      budget_range,
      notes,
      description,
      location,
      tags,
      lead_score,
      conversion_stage,
      expected_value,
      last_contact_date,
      next_follow_up_date,
    } = body;

    // First check if the lead exists and is assigned to the current user
    const checkResult = await query(
      'SELECT id FROM leads WHERE id = $1 AND assigned_to = (SELECT id FROM employees WHERE email = $2)',
      [id, session.user.email]
    );
    console.log('Check result:', checkResult);

    if (!checkResult.success || !checkResult.data || checkResult.data.length === 0) {
      return NextResponse.json(
        { success: false, message: 'Lead not found or not assigned to you' },
        { status: 404 }
      );
    }

    // Prepare update values with proper type handling
    const updateValues = [
      client_name,
      email,
      phone,
      country_code || null,
      is_whatsapp || false,
      has_separate_whatsapp || false,
      whatsapp_country_code || null,
      whatsapp_number || null,
      priority,
      bride_name || null,
      groom_name || null,
      wedding_date || null,
      venue_preference || null,
      guest_count || null,
      budget_range,
      notes || null,
      description || null,
      location || null,
      Array.isArray(tags) ? tags : null,
      lead_score || 50,
      conversion_stage || 'new',
      expected_value || 0,
      last_contact_date || null,
      next_follow_up_date || null,
      id,
    ];

    console.log('Update values:', updateValues);

    // Update the lead
    const result = await query(
      `UPDATE leads SET 
        client_name = $1,
        email = $2,
        phone = $3,
        country_code = $4,
        is_whatsapp = $5,
        has_separate_whatsapp = $6,
        whatsapp_country_code = $7,
        whatsapp_number = $8,
        priority = $9,
        bride_name = $10,
        groom_name = $11,
        wedding_date = $12,
        venue_preference = $13,
        guest_count = $14,
        budget_range = $15,
        notes = $16,
        description = $17,
        location = $18,
        tags = $19,
        lead_score = $20,
        conversion_stage = $21,
        expected_value = $22,
        last_contact_date = $23,
        next_follow_up_date = $24,
        updated_at = NOW()
      WHERE id = $25 
      RETURNING *`,
      updateValues
    );
    console.log('Update result:', result);

    if (!result.success || !result.data || result.data.length === 0) {
      console.error('Failed to update lead:', result.error);
      throw new Error('Failed to update lead');
    }

    return NextResponse.json({
      success: true,
      message: 'Lead updated successfully',
      lead: result.data[0],
    });
  } catch (error) {
    console.error('Error updating lead:', error);
    return NextResponse.json(
      { success: false, message: error instanceof Error ? error.message : 'Failed to update lead' },
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

    if (isNaN(id)) {
      return NextResponse.json(
        { success: false, message: 'Invalid lead ID' },
        { status: 400 }
      );
    }

    // First check if the lead exists and is unassigned
    const checkResult = await query(
      'SELECT id FROM leads WHERE id = $1 AND assigned_to IS NULL',
      [id]
    );

    if (!checkResult.success || !checkResult.data || checkResult.data.length === 0) {
      return NextResponse.json(
        { success: false, message: 'Lead not found or already assigned' },
        { status: 404 }
      );
    }

    // Delete the lead
    const result = await query(
      'DELETE FROM leads WHERE id = $1 RETURNING id',
      [id]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      throw new Error('Failed to delete lead');
    }

    return NextResponse.json({
      success: true,
      message: 'Lead deleted successfully',
    });
  } catch (error) {
    console.error('Error deleting lead:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to delete lead' },
      { status: 500 }
    );
  }
}