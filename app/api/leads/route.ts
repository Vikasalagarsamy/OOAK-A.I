import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { Lead, CreateLeadForm } from '@/types/database';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '10');
    const status = searchParams.get('status');
    const search = searchParams.get('search');
    
    const offset = (page - 1) * limit;
    
    console.log('🔍 Fetching leads with filters:', { page, limit, status, search });

    // Build dynamic query
    let whereClause = 'WHERE 1=1';
    const params: any[] = [];
    let paramIndex = 1;

    if (status) {
      whereClause += ` AND status = $${paramIndex}`;
      params.push(status);
      paramIndex++;
    }

    if (search) {
      whereClause += ` AND (name ILIKE $${paramIndex} OR phone ILIKE $${paramIndex} OR email ILIKE $${paramIndex})`;
      params.push(`%${search}%`);
      paramIndex++;
    }

    // Get total count
    const countResult = await query(`
      SELECT COUNT(*) as total 
      FROM leads 
      ${whereClause}
    `, params);

    if (!countResult.success) {
      throw new Error('Failed to fetch leads count');
    }

    const total = parseInt(countResult.data?.[0]?.total || '0');

    // Get leads with pagination
    const leadsQuery = `
      SELECT 
        l.*,
        ls.name as lead_source_name,
        e.name as assigned_employee_name
      FROM leads l
      LEFT JOIN lead_sources ls ON l.lead_source_id = ls.id
      LEFT JOIN employees e ON l.assigned_to = e.id
      ${whereClause}
      ORDER BY l.created_at DESC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;

    params.push(limit, offset);
    
    const leadsResult = await query(leadsQuery, params);

    if (!leadsResult.success) {
      throw new Error('Failed to fetch leads');
    }

    const totalPages = Math.ceil(total / limit);

    console.log('✅ Leads fetched successfully:', { total, page, totalPages });

    return NextResponse.json({
      success: true,
      data: leadsResult.data || [],
      pagination: {
        total,
        page,
        limit,
        totalPages
      },
      message: 'Leads fetched successfully'
    });

  } catch (error) {
    console.error('❌ Leads GET API error:', error);
    return NextResponse.json({
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error occurred',
      data: null
    }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body: CreateLeadForm = await request.json();
    
    console.log('🆕 Creating new lead:', body);

    // Validate required fields
    if (!body.name || !body.phone) {
      return NextResponse.json({
        success: false,
        error: 'Name and phone are required fields',
        data: null
      }, { status: 400 });
    }

    // Check if lead with same phone already exists
    const existingLead = await query(
      'SELECT id FROM leads WHERE phone = $1',
      [body.phone]
    );

    if (existingLead.success && existingLead.data && existingLead.data.length > 0) {
      return NextResponse.json({
        success: false,
        error: 'Lead with this phone number already exists',
        data: null
      }, { status: 409 });
    }

    // Create new lead
    const insertQuery = `
      INSERT INTO leads (
        name, email, phone, lead_source_id, status, 
        wedding_date, budget_range, location, created_at, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW()
      ) RETURNING *
    `;

    const values = [
      body.name,
      body.email || null,
      body.phone,
      body.lead_source_id || null,
      'new', // Default status
      body.wedding_date || null,
      body.budget_range || null,
      body.location || null
    ];

    const result = await query(insertQuery, values);

    if (!result.success || !result.data) {
      throw new Error('Failed to create lead');
    }

    console.log('✅ Lead created successfully:', result.data[0]);

    return NextResponse.json({
      success: true,
      data: result.data[0],
      message: 'Lead created successfully'
    }, { status: 201 });

  } catch (error) {
    console.error('❌ Leads POST API error:', error);
    return NextResponse.json({
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error occurred',
      data: null
    }, { status: 500 });
  }
} 