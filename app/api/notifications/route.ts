import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import db from '@/lib/db';

export async function GET(request: Request) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
    }

    const url = new URL(request.url);
    const after = url.searchParams.get('after');

    // Get notifications
    let notificationsQuery = `
      SELECT *
      FROM notifications
      WHERE user_id = $1
      ${after ? 'AND created_at > $2' : ''}
      ORDER BY created_at DESC
      LIMIT 50
    `;

    const queryParams = after ? [user.id, after] : [user.id];
    const notificationsResult = await db.query(notificationsQuery, queryParams);

    if (!notificationsResult.success) {
      throw new Error(notificationsResult.error || 'Failed to fetch notifications');
    }

    // Get unread count
    const unreadCountResult = await db.query(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = $1 AND is_read = false',
      [user.id]
    );

    if (!unreadCountResult.success) {
      throw new Error(unreadCountResult.error || 'Failed to fetch unread count');
    }

    return new NextResponse(JSON.stringify({
      notifications: notificationsResult.data || [],
      unreadCount: parseInt(unreadCountResult.data?.[0]?.count || '0'),
    }));

  } catch (error) {
    console.error('Error in notifications route:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to fetch notifications' }),
      { status: 500 }
    );
  }
} 