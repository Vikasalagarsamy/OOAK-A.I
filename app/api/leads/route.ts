import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { Lead, CreateLeadForm } from '@/types/database';
import { z } from 'zod';

export const dynamic = 'force-dynamic';

// Validation schema for lead creation
const createLeadSchema = z.object({
  company_id: z.number().min(1, 'Company is required'),
  branch_id: z.number().min(1, 'Branch is required'),
  client_name: z.string().min(1, 'Client name is required'),
  bride_name: z.string().optional().nullable(),
  groom_name: z.string().optional().nullable(),
  email: z.string().email().optional().or(z.literal('')).nullable(),
  phone: z.string().min(1, 'Phone number is required'),
  whatsapp_number: z.string().optional().nullable(),
  country_code: z.string().min(1, 'Country code is required'),
  whatsapp_country_code: z.string().optional().nullable(),
  is_whatsapp: z.boolean(),
  has_separate_whatsapp_number: z.boolean(),
  priority: z.enum(['low', 'medium', 'high']).default('medium'),
  lead_source: z.string().min(1, 'Lead source is required'),
  notes: z.string().optional().nullable(),
  wedding_date: z.string().optional().nullable(),
  venue_preference: z.string().optional().nullable(),
  guest_count: z.number().optional().nullable(),
  budget_range: z.string().optional().nullable(),
  description: z.string().optional().nullable(),
  location: z.string().optional().nullable(),
});

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

async function generateNextLeadNumber() {
  const result = await query(`
    SELECT lead_number 
    FROM leads 
    WHERE lead_number ~ '^L\\d{4}$'
    ORDER BY 
      CAST(SUBSTRING(lead_number FROM 2) AS INTEGER) DESC 
    LIMIT 1
  `);

  if (!result.success || !result.data || result.data.length === 0) {
    return 'L0001';
  }

  const lastNumber = result.data[0].lead_number;
  const numericPart = parseInt(lastNumber.substring(1));
  const nextNumber = numericPart + 1;
  return `L${nextNumber.toString().padStart(4, '0')}`;
}

export async function POST(request: Request) {
  try {
    const body = await request.json();
    console.log('📝 Creating new lead:', body);

    // Validate request body
    const validatedData = createLeadSchema.parse(body);
    console.log('✅ Validation passed:', validatedData);

    // Generate next lead number
    const leadNumber = await generateNextLeadNumber();
    console.log('📝 Generated lead number:', leadNumber);

    // Determine WhatsApp number based on has_separate_whatsapp flag
    const whatsappNumber = !validatedData.has_separate_whatsapp_number 
      ? validatedData.phone 
      : validatedData.whatsapp_number || validatedData.phone;
    
    const whatsappCountryCode = !validatedData.has_separate_whatsapp_number 
      ? validatedData.country_code 
      : validatedData.whatsapp_country_code || validatedData.country_code;

    console.log('📱 Phone details:', {
      phone: validatedData.phone,
      whatsapp: whatsappNumber,
      hasSeparate: validatedData.has_separate_whatsapp_number
    });

    // Handle optional fields with null values
    const guestCount = validatedData.guest_count ? 
      parseInt(validatedData.guest_count.toString()) : 
      null;

    const result = await query(`
      INSERT INTO leads (
        lead_number,
        company_id,
        branch_id,
        client_name,
        bride_name,
        groom_name,
        email,
        country_code,
        phone,
        is_whatsapp,
        has_separate_whatsapp,
        whatsapp_country_code,
        whatsapp_number,
        notes,
        lead_source,
        location,
        priority,
        budget_range,
        wedding_date,
        venue_preference,
        guest_count,
        description,
        status,
        assigned_to
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
        $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
        $21, $22, 'UNASSIGNED', NULL
      ) RETURNING 
        id, 
        lead_number, 
        phone, 
        whatsapp_number, 
        has_separate_whatsapp,
        country_code,
        whatsapp_country_code
    `, [
      leadNumber,
      validatedData.company_id,
      validatedData.branch_id,
      validatedData.client_name,
      validatedData.bride_name || null,
      validatedData.groom_name || null,
      validatedData.email || null,
      validatedData.country_code,
      validatedData.phone,
      validatedData.is_whatsapp,
      validatedData.has_separate_whatsapp_number,
      whatsappCountryCode,
      whatsappNumber,
      validatedData.notes || null,
      validatedData.lead_source,
      validatedData.location || null,
      validatedData.priority,
      validatedData.budget_range || null,
      validatedData.wedding_date || null,
      validatedData.venue_preference || null,
      guestCount,
      validatedData.description || null
    ]);

    if (!result.success || !result.data) {
      console.error('❌ Database error:', result.error);
      throw new Error(result.error || 'Failed to create lead');
    }

    console.log('✅ Lead created successfully:', result.data[0]);

    return NextResponse.json({
      success: true,
      lead: result.data[0]
    });
  } catch (error) {
    console.error('❌ Error creating lead:', error);
    return NextResponse.json(
      { 
        success: false, 
        message: 'Failed to create lead', 
        error: error instanceof Error ? error.message : 'Unknown error',
        details: error
      },
      { status: 500 }
    );
  }
} 