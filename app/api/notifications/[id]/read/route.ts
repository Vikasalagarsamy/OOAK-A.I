import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import { db } from '@/lib/db';

export async function POST(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession();
    if (!session?.user) {
      return new NextResponse('Unauthorized', { status: 401 });
    }

    const { id } = params;

    // Mark notification as read
    await db.query({
      text: `
        UPDATE notifications
        SET is_read = true, read_at = NOW()
        WHERE id = $1
        AND (target_user = $2 OR recipient_id = $3)
      `,
      values: [id, session.user.id, session.user.employeeId],
    });

    return new NextResponse('OK');

  } catch (error) {
    console.error('[NOTIFICATION_READ]', error);
    return new NextResponse('Internal Error', { status: 500 });
  }
} 