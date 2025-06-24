import { db } from './db';

export interface CreateNotificationParams {
  type: string;
  priority?: 'low' | 'medium' | 'high';
  title: string;
  message: string;
  quotation_id?: number;
  expires_at?: Date;
  action_url?: string;
  action_label?: string;
  metadata?: Record<string, any>;
  scheduled_for?: Date;
  ai_enhanced?: boolean;
  recipient_role?: string;
  recipient_id?: number;
  target_user?: string;
  employee_id?: number;
}

export async function createNotification(params: CreateNotificationParams) {
  const {
    type,
    priority = 'medium',
    title,
    message,
    quotation_id,
    expires_at,
    action_url,
    action_label,
    metadata,
    scheduled_for = new Date(),
    ai_enhanced = false,
    recipient_role,
    recipient_id,
    target_user,
    employee_id,
  } = params;

  try {
    const { rows: [notification] } = await db.query({
      text: `
        INSERT INTO notifications (
          type,
          priority,
          title,
          message,
          quotation_id,
          expires_at,
          action_url,
          action_label,
          metadata,
          scheduled_for,
          ai_enhanced,
          recipient_role,
          recipient_id,
          target_user,
          employee_id
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
        RETURNING *
      `,
      values: [
        type,
        priority,
        title,
        message,
        quotation_id,
        expires_at,
        action_url,
        action_label,
        metadata,
        scheduled_for,
        ai_enhanced,
        recipient_role,
        recipient_id,
        target_user,
        employee_id,
      ],
    });

    return notification;
  } catch (error) {
    console.error('[CREATE_NOTIFICATION]', error);
    throw error;
  }
}

// Example usage:
// await createNotification({
//   type: 'LEAD_ASSIGNED',
//   title: 'New Lead Assigned',
//   message: 'A new lead has been assigned to you',
//   target_user: userId,
//   action_url: `/sales/my-leads/${leadId}`,
//   action_label: 'View Lead',
//   metadata: { leadId, leadName },
// }); 