import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { DashboardStats } from '@/types/database';

export async function GET(request: NextRequest) {
  try {
    console.log('🔍 Fetching dashboard statistics...');

    // Parallel queries for better performance
    const [
      employeesResult,
      designationsResult,
      menuItemsResult,
      permissionsResult
    ] = await Promise.all([
      // Total employees
      query('SELECT COUNT(*) as total FROM employees'),
      
      // Total designations
      query('SELECT COUNT(*) as total FROM designations'),
      
      // Total menu items
      query('SELECT COUNT(*) as total FROM menu_items'),
      
      // Total permissions
      query('SELECT COUNT(*) as total FROM designation_menu_permissions')
    ]);

    // Check if all queries were successful
    if (!employeesResult.success || !designationsResult.success || !menuItemsResult.success || !permissionsResult.success) {
      throw new Error('Failed to fetch dashboard data');
    }

    const stats: DashboardStats = {
      total_employees: parseInt(employeesResult.data?.[0]?.total || '0'),
      total_designations: parseInt(designationsResult.data?.[0]?.total || '0'),
      total_menu_items: parseInt(menuItemsResult.data?.[0]?.total || '0'),
      total_permissions: parseInt(permissionsResult.data?.[0]?.total || '0')
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