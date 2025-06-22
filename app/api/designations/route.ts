import { NextResponse } from 'next/server';
import { getDbPool } from '@/lib/db';

export async function GET() {
  const pool = getDbPool();
  
  try {
    const result = await pool.query(`
      SELECT 
        id,
        name,
        department_id,
        description
      FROM designations
      ORDER BY name ASC;
    `);

    return NextResponse.json({ success: true, designations: result.rows });
  } catch (error) {
    console.error('Error fetching designations:', error);
    return NextResponse.json(
      { error: 'Failed to fetch designations' },
      { status: 500 }
    );
  }
} 