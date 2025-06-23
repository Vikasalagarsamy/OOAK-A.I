import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export async function GET() {
  try {
    const result = await query(`
      SELECT id, name, description, is_active
      FROM lead_sources
      WHERE is_active = true
      ORDER BY name ASC
    `);

    if (!result.success) {
      throw new Error(result.error);
    }

    return NextResponse.json({
      success: true,
      sources: result.data,
    });
  } catch (error) {
    console.error('Error fetching lead sources:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch lead sources', error: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
} 