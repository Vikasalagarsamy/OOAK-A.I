import { NextResponse } from 'next/server';
import { getDbPool } from '@/lib/db';
import { Pool } from 'pg';

// GET /api/designations
export async function GET() {
  const pool: Pool = getDbPool();
  
  try {
    const result = await pool.query(
      'SELECT id, name FROM designations ORDER BY name'
    );

    return NextResponse.json({
      success: true,
      designations: result.rows
    });
  } catch (error) {
    console.error('Error fetching designations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch designations' },
      { status: 500 }
    );
  }
} 