import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export const dynamic = 'force-dynamic';

interface PostAssignmentPayload {
  leadId: number;
  employeeId: number;
  leadDetails: {
    client_name: string;
    phone: string;
    priority: string;
    lead_source: string;
  };
  assignedBy: {
    employee_id: string;
    first_name: string;
    last_name: string;
  };
}

async function createNotification(employeeId: number, leadDetails: any, assignedBy: any) {
  const content = `You have been assigned a new lead: ${leadDetails.client_name} from ${leadDetails.lead_source} – ${leadDetails.priority}`;
  
  await query(`
    INSERT INTO notifications (
      user_id,
      type,
      title,
      content,
      status,
      created_by,
      metadata
    ) VALUES (
      $1,
      'lead_assignment',
      'New Lead Assigned',
      $2,
      'unread',
      $3,
      $4
    )
  `, [
    employeeId,
    content,
    assignedBy.employee_id,
    JSON.stringify({
      lead_id: leadDetails.id,
      priority: leadDetails.priority,
      source: leadDetails.lead_source
    })
  ]);
}

async function sendWhatsAppMessage(employeeDetails: any, leadDetails: any, assignedBy: any) {
  const message = `Hi ${employeeDetails.first_name}, a new lead has been assigned to you:
- Client: ${leadDetails.client_name}
- Contact: ${leadDetails.phone}
- Priority: ${leadDetails.priority}
- Assigned by: ${assignedBy.first_name} ${assignedBy.last_name}
Please check your portal to follow up.`;

  await query(`
    INSERT INTO whatsapp_messages (
      to_number,
      message_content,
      message_type,
      status,
      metadata
    ) VALUES (
      $1,
      $2,
      'lead_assignment',
      'pending',
      $3
    )
  `, [
    employeeDetails.phone,
    message,
    JSON.stringify({
      lead_id: leadDetails.id,
      assigned_by: assignedBy.employee_id
    })
  ]);
}

async function createFollowUpTask(employeeId: number, leadDetails: any) {
  const dueDate = new Date();
  dueDate.setDate(dueDate.getDate() + 1); // Due in 1 day

  await query(`
    INSERT INTO ai_tasks (
      title,
      description,
      task_type,
      priority,
      assigned_to_employee_id,
      due_date,
      status,
      related_lead_id,
      created_at,
      updated_at
    ) VALUES (
      $1,
      $2,
      'lead_followup',
      $3,
      $4,
      $5,
      'open',
      $6,
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP
    )
  `, [
    `Follow up with ${leadDetails.client_name}`,
    'You have been assigned a new lead. Please follow up within 24 hours.',
    leadDetails.priority.toLowerCase(),
    employeeId,
    dueDate,
    leadDetails.id
  ]);
}

export async function POST(request: Request) {
  try {
    const body: PostAssignmentPayload = await request.json();
    const { leadId, employeeId, leadDetails, assignedBy } = body;

    // 1. Get employee details
    const employeeResult = await query(`
      SELECT first_name, last_name, phone, email
      FROM employees
      WHERE id = $1
    `, [employeeId]);

    if (!employeeResult.success || !employeeResult.data || employeeResult.data.length === 0) {
      throw new Error('Employee not found');
    }

    const employeeDetails = employeeResult.data[0];

    // 2. Create in-app notification
    await createNotification(employeeId, leadDetails, assignedBy);

    // 3. Send WhatsApp message
    await sendWhatsAppMessage(employeeDetails, leadDetails, assignedBy);

    // 4. Create follow-up task
    await createFollowUpTask(employeeId, leadDetails);

    return NextResponse.json({
      success: true,
      message: 'Post-assignment actions completed successfully'
    });
  } catch (error) {
    console.error('Error in post-assignment process:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to complete post-assignment actions' },
      { status: 500 }
    );
  }
} 