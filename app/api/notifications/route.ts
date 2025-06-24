import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import { db } from '@/lib/db';

export async function GET(request: Request) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse('Unauthorized', { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const after = searchParams.get('after');

    // Get notifications for the user
    const query = {
      text: `
        SELECT *
        FROM notifications
        WHERE (target_user = $1 OR recipient_id = $2)
        ${after ? 'AND created_at > $3' : ''}
        ORDER BY created_at DESC
        LIMIT 50
      `,
      values: after 
        ? [user.id, user.id, after]
        : [user.id, user.id],
    };

    const { rows: notifications } = await db.query(query);

    // Get unread count
    const { rows: [{ count }] } = await db.query({
      text: `
        SELECT COUNT(*) as count
        FROM notifications
        WHERE (target_user = $1 OR recipient_id = $2)
        AND is_read = false
      `,
      values: [user.id, user.id],
    });

    return NextResponse.json({
      notifications,
      unreadCount: parseInt(count, 10),
    });

  } catch (error) {
    console.error('[NOTIFICATIONS_GET]', error);
    return new NextResponse('Internal Error', { status: 500 });
  }
} 