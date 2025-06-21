import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { DashboardStats } from '@/types/database';

export async function GET(request: NextRequest) {
  try {
    console.log('🔍 Fetching dashboard statistics...');

    // Parallel queries for better performance
    const [
      leadsResult,
      clientsResult,
      bookingsResult,
      revenueResult,
      quotationsResult
    ] = await Promise.all([
      // Total leads
      query('SELECT COUNT(*) as total FROM leads WHERE created_at >= NOW() - INTERVAL \'30 days\''),
      
      // Total clients
      query('SELECT COUNT(*) as total FROM clients WHERE status = \'active\' AND created_at >= NOW() - INTERVAL \'30 days\''),
      
      // Active bookings
      query('SELECT COUNT(*) as total FROM bookings WHERE status IN (\'confirmed\', \'in_progress\') AND event_date >= NOW()'),
      
      // Total revenue (last 30 days)
      query('SELECT COALESCE(SUM(total_amount), 0) as total FROM bookings WHERE status = \'completed\' AND created_at >= NOW() - INTERVAL \'30 days\''),
      
      // Pending quotations
      query('SELECT COUNT(*) as total FROM quotations WHERE status = \'pending\' AND created_at >= NOW() - INTERVAL \'7 days\'')
    ]);

    // Check if all queries were successful
    if (!leadsResult.success || !clientsResult.success || !bookingsResult.success || !revenueResult.success || !quotationsResult.success) {
      throw new Error('Failed to fetch dashboard data');
    }

    const stats: DashboardStats = {
      total_leads: parseInt(leadsResult.data?.[0]?.total || '0'),
      total_clients: parseInt(clientsResult.data?.[0]?.total || '0'),
      total_bookings: parseInt(bookingsResult.data?.[0]?.total || '0'),
      total_revenue: parseFloat(revenueResult.data?.[0]?.total || '0'),
      pending_quotations: parseInt(quotationsResult.data?.[0]?.total || '0'),
      active_projects: parseInt(bookingsResult.data?.[0]?.total || '0'), // Same as active bookings
    };

    console.log('✅ Dashboard statistics fetched successfully:', stats);

    return NextResponse.json({
      success: true,
      data: stats,
      message: 'Dashboard statistics fetched successfully'
    });

  } catch (error) {
    console.error('❌ Dashboard API error:', error);
    return NextResponse.json({
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error occurred',
      data: null
    }, { status: 500 });
  }
} 