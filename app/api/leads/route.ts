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

    // Get total count - simplified for testing
    const countResult = await query(`
      SELECT COUNT(*) as total 
      FROM clients
    `, []);

    console.log('🔍 Count result:', countResult);

    const total = parseInt(countResult.rows[0]?.total || '0');

    // Get leads with pagination
    const leadsQuery = `
      SELECT 
        l.*,
        l.category as lead_source_name
      FROM clients l
      ORDER BY l.created_at DESC
      LIMIT $1 OFFSET $2
    `;
    
    const leadsResult = await query(leadsQuery, [limit, offset]);

    const totalPages = Math.ceil(total / limit);

    console.log('✅ Leads fetched successfully:', { total, page, totalPages });

    return NextResponse.json({
      success: true,
      data: leadsResult.rows || [],
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
      'SELECT id FROM clients WHERE phone = $1',
      [body.phone]
    );

    if (existingLead.rows && existingLead.rows.length > 0) {
      return NextResponse.json({
        success: false,
        error: 'Lead with this phone number already exists',
        data: null
      }, { status: 409 });
    }

    // Create new lead
    const insertQuery = `
      INSERT INTO clients (
        client_code, name, company_id, contact_person, email, phone, 
        address, city, state, postal_code, country, category, status, 
        created_at, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, NOW(), NOW()
      ) RETURNING *
    `;

    // Generate a simple client code
    const clientCode = `CL${Date.now().toString().slice(-6)}`;

    const values = [
      clientCode,
      body.name,
      1, // Default company_id
      body.name, // contact_person same as name
      body.email || '',
      body.phone,
      body.location || '', // address
      '', // city
      '', // state
      '', // postal_code
      'India', // country
      'lead', // category
      'new' // status
    ];

    const result = await query(insertQuery, values);

    if (!result.rows || result.rows.length === 0) {
      throw new Error('Failed to create lead');
    }

    console.log('✅ Lead created successfully:', result.rows[0]);

    return NextResponse.json({
      success: true,
      data: result.rows[0],
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