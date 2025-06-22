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
      eventsResult,
      revenueResult,
      quotationsResult,
      performanceResult
    ] = await Promise.all([
      // Total leads (last 30 days)
      query(`
        SELECT COUNT(*) as total 
        FROM leads 
        WHERE created_at >= NOW() - INTERVAL '30 days'
      `),
      
      // Total active clients
      query(`
        SELECT COUNT(*) as total 
        FROM clients 
        WHERE status = 'active'
      `),
      
      // Active events (upcoming weddings/shoots)
      query(`
        SELECT COUNT(*) as total 
        FROM events 
        WHERE status IN ('confirmed', 'in_progress') 
        AND event_date >= CURRENT_DATE
      `),
      
      // Total revenue from sales_performance_metrics (last 30 days)
      query(`
        SELECT COALESCE(SUM(revenue_amount), 0) as total 
        FROM sales_performance_metrics 
        WHERE created_at >= NOW() - INTERVAL '30 days'
      `),
      
      // Pending quotations
      query(`
        SELECT COUNT(*) as total 
        FROM quotations 
        WHERE status = 'pending' 
        AND created_at >= NOW() - INTERVAL '7 days'
      `),

      // Overall sales performance
      query(`
        SELECT 
          COUNT(DISTINCT l.id) as total_leads_converted,
          AVG(q.total_amount) as avg_quote_value
        FROM leads l
        LEFT JOIN quotations q ON q.lead_id = l.id
        WHERE l.created_at >= NOW() - INTERVAL '30 days'
        AND l.status = 'converted'
      `)
    ]);

    // Check if all queries were successful
    if (!leadsResult.success || !clientsResult.success || !eventsResult.success || 
        !revenueResult.success || !quotationsResult.success || !performanceResult.success) {
      throw new Error('Failed to fetch dashboard data');
    }

    const stats: DashboardStats = {
      total_leads: parseInt(leadsResult.data?.[0]?.total || '0'),
      total_clients: parseInt(clientsResult.data?.[0]?.total || '0'),
      total_events: parseInt(eventsResult.data?.[0]?.total || '0'),
      total_revenue: parseFloat(revenueResult.data?.[0]?.total || '0'),
      pending_quotations: parseInt(quotationsResult.data?.[0]?.total || '0'),
      leads_converted: parseInt(performanceResult.data?.[0]?.total_leads_converted || '0'),
      avg_quote_value: parseFloat(performanceResult.data?.[0]?.avg_quote_value || '0'),
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