import { NextResponse } from 'next/server';
import { requireAuth } from '@/lib/auth';
import db from '@/lib/db';

export async function POST(request: Request) {
  try {
    const user = await requireAuth(request);
    if (!user) {
      return new NextResponse(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
    }

    const result = await db.query(
      'UPDATE notifications SET is_read = true, read_at = NOW() WHERE user_id = $1 AND is_read = false RETURNING *',
      [user.id]
    );

    if (!result.success) {
      throw new Error(result.error || 'Failed to mark notifications as read');
    }

    return new NextResponse(JSON.stringify({
      message: 'All notifications marked as read',
      count: result.data?.length || 0
    }));
  } catch (error) {
    console.error('Error marking all notifications as read:', error);
    return new NextResponse(
      JSON.stringify({ error: 'Failed to mark notifications as read' }),
      { status: 500 }
    );
  }
} 