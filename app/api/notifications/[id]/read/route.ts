import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import db from '@/lib/db';

export async function POST(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
    }

    const notificationId = params.id;

    const result = await db.query(
      'UPDATE notifications SET is_read = true, read_at = NOW() WHERE id = $1 AND user_id = $2 RETURNING *',
      [notificationId, user.id]
    );

    if (!result.success || !result.data || result.data.length === 0) {
      return new NextResponse(
        JSON.stringify({ error: 'Notification not found or unauthorized' }),
        { status: 404 }
      );
    }

    return new NextResponse(JSON.stringify(result.data[0]));
  } catch (error) {
    console.error('Error marking notification as read:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to mark notification as read' }),
      { status: 500 }
    );
  }
} 