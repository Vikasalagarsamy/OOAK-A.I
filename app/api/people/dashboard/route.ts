import { NextResponse } from 'next/server'
import { query } from '@/lib/db'

// Specify Node.js runtime and force dynamic rendering
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url)
    const days = parseInt(searchParams.get('days') || '30')

    // Get total and active employees count
    const employeeCountResult = await query(`
      SELECT 
        COUNT(*) as total_employees,
        COUNT(CASE WHEN status = 'active' THEN 1 END) as active_employees
      FROM employees
    `)
    if (!employeeCountResult.success) {
      throw new Error(employeeCountResult.error)
    }

    // Get total departments count
    const departmentCountResult = await query('SELECT COUNT(*) as total_departments FROM departments')
    if (!departmentCountResult.success) {
      throw new Error(departmentCountResult.error)
    }

    // Get total designations count
    const designationCountResult = await query('SELECT COUNT(*) as total_designations FROM designations')
    if (!designationCountResult.success) {
      throw new Error(designationCountResult.error)
    }

    // Get department distribution
    const departmentDistributionResult = await query(`
      SELECT 
        d.name as department_name,
        COUNT(e.id) as employee_count
      FROM departments d
      LEFT JOIN employees e ON d.id = e.department_id AND e.status = 'active'
      GROUP BY d.id, d.name
      ORDER BY employee_count DESC
    `)
    if (!departmentDistributionResult.success) {
      throw new Error(departmentDistributionResult.error)
    }

    // Get designation stats
    const designationStatsResult = await query(`
      SELECT 
        des.name as designation_name,
        dep.name as department_name,
        COUNT(e.id) as employee_count
      FROM designations des
      LEFT JOIN departments dep ON des.department_id = dep.id
      LEFT JOIN employees e ON des.id = e.designation_id AND e.status = 'active'
      GROUP BY des.id, des.name, dep.name
      HAVING COUNT(e.id) > 0
      ORDER BY employee_count DESC
    `)
    if (!designationStatsResult.success) {
      throw new Error(designationStatsResult.error)
    }

    // Get recent hires
    const recentHiresResult = await query(`
      SELECT 
        e.id,
        e.employee_id,
        e.first_name,
        e.last_name,
        d.name as department_name,
        des.name as designation_name,
        e.hire_date
      FROM employees e
      LEFT JOIN departments d ON e.department_id = d.id
      LEFT JOIN designations des ON e.designation_id = des.id
      WHERE e.hire_date >= CURRENT_DATE - INTERVAL '${days} days'
      ORDER BY e.hire_date DESC
    `)
    if (!recentHiresResult.success) {
      throw new Error(recentHiresResult.error)
    }

    return NextResponse.json({
      success: true,
      data: {
        totalEmployees: parseInt(employeeCountResult.data?.[0].total_employees || '0'),
        activeEmployees: parseInt(employeeCountResult.data?.[0].active_employees || '0'),
        totalDepartments: parseInt(departmentCountResult.data?.[0].total_departments || '0'),
        totalDesignations: parseInt(designationCountResult.data?.[0].total_designations || '0'),
        departmentDistribution: departmentDistributionResult.data || [],
        designationStats: designationStatsResult.data || [],
        recentHires: recentHiresResult.data || [],
      },
    })
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch dashboard data' },
      { status: 500 }
    )
  }
} 