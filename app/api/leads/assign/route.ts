import { NextResponse } from 'next/server';
import { query } from '@/lib/db';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { Permission } from '@/types/auth';
import { AuthClientService } from '@/lib/auth-client';

export const dynamic = 'force-dynamic';

// Get eligible employees for a lead
export async function GET(request: Request) {
  try {
    const session = await getServerSession(authOptions);
    if (!session) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { searchParams } = new URL(request.url);
    const companyId = parseInt(searchParams.get('company_id') || '', 10);
    const branchId = parseInt(searchParams.get('branch_id') || '', 10);

    if (isNaN(companyId) || isNaN(branchId)) {
      return NextResponse.json(
        { success: false, message: 'Invalid Company ID or Branch ID' },
        { status: 400 }
      );
    }

    // Check if user has permission to assign leads
    if (!AuthClientService.hasPermission(
      session.user.designation.id, 
      Permission.SALES_MANAGE_LEADS,
      session.user.designation.name
    )) {
      return NextResponse.json(
        { success: false, message: 'You do not have permission to assign leads' },
        { status: 403 }
      );
    }

    console.log('Fetching employees for:', { companyId, branchId });
    
    // First, verify the sales department exists
    const deptCheck = await query('SELECT id FROM departments WHERE name = $1', ['SALES']);
    console.log('Sales department check:', deptCheck);

    if (!deptCheck.success || !deptCheck.data || deptCheck.data.length === 0) {
      console.error('Sales department not found');
      return NextResponse.json({
        success: false,
        message: 'Sales department not found'
      });
    }

    const salesDeptId = deptCheck.data[0].id;
    console.log('Sales department ID:', salesDeptId);
    
    // Check if there are any employees matching the criteria
    const employeeCheck = await query(`
      SELECT COUNT(*) 
      FROM employees 
      WHERE company_id = $1 
      AND branch_id = $2 
      AND department_id = $3 
      AND status = 'active'
    `, [companyId, branchId, salesDeptId]);
    
    console.log('Employee check result:', employeeCheck);

    const result = await query(`
      SELECT 
        e.id,
        e.employee_id,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        d.name as designation_name,
        e.department_id,
        e.company_id,
        e.branch_id
      FROM employees e
      LEFT JOIN designations d ON e.designation_id = d.id
      WHERE e.company_id = $1 
      AND e.branch_id = $2
      AND e.department_id = $3
      AND e.status = 'active'
      ORDER BY 
        CASE 
          WHEN LOWER(d.name) LIKE '%head%' THEN 1
          WHEN LOWER(d.name) LIKE '%manager%' THEN 2
          WHEN LOWER(d.name) LIKE '%executive%' THEN 3
          ELSE 4
        END,
        e.first_name, 
        e.last_name
    `, [companyId, branchId, salesDeptId]);

    console.log('Final query result:', result);

    if (!result.success || !result.data) {
      throw new Error(result.error || 'Failed to fetch eligible employees');
    }

    return NextResponse.json({
      success: true,
      employees: result.data,
    });
  } catch (error) {
    console.error('Error fetching eligible employees:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch eligible employees' },
      { status: 500 }
    );
  }
}

// Assign lead to employee
export async function POST(request: Request) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.employee_id) {
      return NextResponse.json(
        { success: false, message: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Check if user has permission to assign leads
    if (!AuthClientService.hasPermission(
      session.user.designation.id, 
      Permission.SALES_MANAGE_LEADS,
      session.user.designation.name
    )) {
      return NextResponse.json(
        { success: false, message: 'You do not have permission to assign leads' },
        { status: 403 }
      );
    }

    const body = await request.json();
    const { leadId, employeeId } = body;

    if (!leadId || !employeeId) {
      return NextResponse.json(
        { success: false, message: 'Lead ID and Employee ID are required' },
        { status: 400 }
      );
    }

    // First verify the employee exists and is active
    const employeeCheck = await query(
      'SELECT id FROM employees WHERE id = $1 AND status = $2',
      [employeeId, 'active']
    );

    if (!employeeCheck.success || !employeeCheck.data || employeeCheck.data.length === 0) {
      return NextResponse.json(
        { success: false, message: 'Invalid or inactive employee' },
        { status: 400 }
      );
    }

    // Get lead details before updating
    const leadDetails = await query(`
      SELECT 
        l.*,
        c.name as company_name,
        b.name as branch_name
      FROM leads l
      LEFT JOIN companies c ON l.company_id = c.id
      LEFT JOIN branches b ON l.branch_id = b.id
      WHERE l.id = $1
    `, [leadId]);

    console.log('Lead details query result:', leadDetails);

    if (!leadDetails.success || !leadDetails.data || leadDetails.data.length === 0) {
      return NextResponse.json(
        { success: false, message: 'Lead not found' },
        { status: 404 }
      );
    }

    // Check if lead is already assigned
    if (leadDetails.data[0].assigned_to !== null) {
      return NextResponse.json(
        { success: false, message: 'Lead is already assigned' },
        { status: 400 }
      );
    }

    console.log('Attempting to assign lead:', {
      leadId,
      employeeId,
      assignedBy: session.user.employee_id
    });

    // Update the lead
    const result = await query(`
      UPDATE leads 
      SET 
        assigned_to = $1,
        assigned_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP,
        status = 'ASSIGNED'
      WHERE id = $2 
      AND assigned_to IS NULL
      RETURNING id, lead_number, assigned_to, assigned_at, status
    `, [employeeId, leadId]);

    console.log('Update query result:', result);

    if (!result.success) {
      console.error('Database error during lead assignment:', result.error);
      throw new Error(`Database error: ${result.error}`);
    }

    if (!result.data || result.data.length === 0) {
      console.error('No rows updated during lead assignment');
      throw new Error('Failed to assign lead - no rows were updated');
    }

    // Get current user (assigner) details
    const assignerDetails = await query(`
      SELECT employee_id, first_name, last_name
      FROM employees
      WHERE employee_id = $1
    `, [session.user.employee_id]);

    if (!assignerDetails.success || !assignerDetails.data || assignerDetails.data.length === 0) {
      console.error('Failed to get assigner details:', assignerDetails.error);
      throw new Error('Failed to get assigner details');
    }

    try {
      // Trigger post-assignment workflow
      const postAssignmentResponse = await fetch(new URL('/api/leads/assign/post-assignment', request.url).toString(), {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          leadId,
          employeeId,
          leadDetails: leadDetails.data[0],
          assignedBy: assignerDetails.data[0],
        }),
      });

      if (!postAssignmentResponse.ok) {
        const errorText = await postAssignmentResponse.text();
        console.error('Post-assignment workflow failed:', errorText);
        // Continue with the assignment even if post-assignment fails
      }
    } catch (postAssignmentError) {
      console.error('Error in post-assignment workflow:', postAssignmentError);
      // Continue with the assignment even if post-assignment fails
    }

    // Get assigned employee details for the success message
    const assignedEmployeeDetails = await query(`
      SELECT first_name, last_name
      FROM employees
      WHERE id = $1
    `, [employeeId]);

    const employeeName = assignedEmployeeDetails.success && assignedEmployeeDetails.data?.[0]
      ? `${assignedEmployeeDetails.data[0].first_name} ${assignedEmployeeDetails.data[0].last_name}`
      : 'selected employee';

    return NextResponse.json({
      success: true,
      message: `Lead assigned successfully to ${employeeName}`,
      lead: result.data[0],
    });
  } catch (error) {
    console.error('Error assigning lead:', error);
    const errorMessage = error instanceof Error ? error.message : 'Failed to assign lead';
    return NextResponse.json(
      { success: false, message: errorMessage },
      { status: 500 }
    );
  }
} 