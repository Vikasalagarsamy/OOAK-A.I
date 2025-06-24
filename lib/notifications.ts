import db from './db';

export interface CreateNotificationParams {
  type: string;
  priority?: string;
  title: string;
  message: string;
  user_id: number;
  quotation_id?: number;
  action_url?: string;
  action_label?: string;
  metadata?: Record<string, any>;
  scheduled_for?: Date;
  ai_enhanced?: boolean;
  recipient_role?: string;
  recipient_id?: number;
  data?: Record<string, any>;
}

export interface Notification {
  id: string;
  type: string;
  priority: string;
  title: string;
  message: string;
  user_id: number;
  quotation_id?: number;
  is_read: boolean;
  created_at: string;
  expires_at?: string;
  action_url?: string;
  action_label?: string;
  metadata?: Record<string, any>;
  scheduled_for?: string;
  ai_enhanced?: boolean;
  recipient_role?: string;
  recipient_id?: number;
  data?: Record<string, any>;
  read_at?: string;
}

export async function createNotification(params: CreateNotificationParams): Promise<Notification | null> {
  try {
    const result = await db.query<Notification>(
      `INSERT INTO notifications (
        type,
        priority,
        title,
        message,
        user_id,
        quotation_id,
        action_url,
        action_label,
        metadata,
        scheduled_for,
        ai_enhanced,
        recipient_role,
        recipient_id,
        data
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
      ) RETURNING *`,
      [
        params.type,
        params.priority || 'normal',
        params.title,
        params.message,
        params.user_id,
        params.quotation_id,
        params.action_url,
        params.action_label,
        params.metadata,
        params.scheduled_for,
        params.ai_enhanced,
        params.recipient_role,
        params.recipient_id,
        params.data
      ]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      throw new Error(result.error || 'Failed to create notification');
    }

    return result.data[0];
  } catch (error) {
    console.error('Error creating notification:', error);
    return null;
  }
}

export async function getNotifications(userId: number, limit = 50): Promise<Notification[]> {
  try {
    const result = await db.query<Notification>(
      `SELECT * FROM notifications 
       WHERE user_id = $1 
       ORDER BY created_at DESC 
       LIMIT $2`,
      [userId, limit]
    );

    if (!result.success) {
      throw new Error(result.error || 'Failed to fetch notifications');
    }

    return result.data || [];
  } catch (error) {
    console.error('Error fetching notifications:', error);
    return [];
  }
}

export async function markNotificationAsRead(id: string, userId: number): Promise<boolean> {
  try {
    const result = await db.query(
      `UPDATE notifications 
       SET is_read = true, read_at = NOW() 
       WHERE id = $1 AND user_id = $2 
       RETURNING *`,
      [id, userId]
    );

    return !!(result.success && result.data && result.data.length > 0);
  } catch (error) {
    console.error('Error marking notification as read:', error);
    return false;
  }
}

export async function markAllNotificationsAsRead(userId: number): Promise<boolean> {
  try {
    const result = await db.query(
      `UPDATE notifications 
       SET is_read = true, read_at = NOW() 
       WHERE user_id = $1 AND is_read = false 
       RETURNING *`,
      [userId]
    );

    return result.success;
  } catch (error) {
    console.error('Error marking all notifications as read:', error);
    return false;
  }
}

export async function getUnreadCount(userId: number): Promise<number> {
  try {
    const result = await db.query<{ count: string }>(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = $1 AND is_read = false',
      [userId]
    );

    if (!result.success || !result.data) {
      throw new Error(result.error || 'Failed to get unread count');
    }

    return parseInt(result.data[0].count);
  } catch (error) {
    console.error('Error getting unread count:', error);
    return 0;
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