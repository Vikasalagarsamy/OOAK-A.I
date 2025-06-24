import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import { db } from '@/lib/db';

export async function POST(request: Request) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse('Unauthorized', { status: 401 });
    }

    // Mark all notifications as read
    await db.query({
      text: `
        UPDATE notifications
        SET is_read = true, read_at = NOW()
        WHERE (target_user = $1 OR recipient_id = $2)
        AND is_read = false
      `,
      values: [user.id, user.id],
    });

    return new NextResponse('OK');

  } catch (error) {
    console.error('[NOTIFICATIONS_READ_ALL]', error);
    return new NextResponse('Internal Error', { status: 500 });
  }
} 