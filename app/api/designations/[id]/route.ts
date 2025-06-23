import { NextResponse } from 'next/server'
import { query } from '@/lib/db'

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const { name, department_id, description } = await request.json()
    const id = parseInt(params.id)

    // Validate required fields
    if (!name || !department_id) {
      return NextResponse.json(
        { success: false, error: 'Name and department are required' },
        { status: 400 }
      )
    }

    // Check if designation exists
    const designationCheck = await query(
      'SELECT id FROM designations WHERE id = $1',
      [id]
    )
    if (!designationCheck.success || !designationCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Designation not found' },
        { status: 404 }
      )
    }

    // Check if department exists
    const deptCheck = await query(
      'SELECT id FROM departments WHERE id = $1',
      [department_id]
    )
    if (!deptCheck.success || !deptCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Department not found' },
        { status: 404 }
      )
    }

    // Check for duplicate designation name in the same department (excluding current designation)
    const duplicateCheck = await query(
      'SELECT id FROM designations WHERE name = $1 AND department_id = $2 AND id != $3',
      [name, department_id, id]
    )
    if (!duplicateCheck.success) {
      throw new Error(duplicateCheck.error)
    }
    if (duplicateCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Designation already exists in this department' },
        { status: 400 }
      )
    }

    // Update designation
    const result = await query(
      `UPDATE designations 
       SET name = $1, department_id = $2, description = $3, updated_at = CURRENT_TIMESTAMP
       WHERE id = $4
       RETURNING id, name, department_id, description, created_at, updated_at`,
      [name, department_id, description, id]
    )
    if (!result.success) {
      throw new Error(result.error)
    }

    return NextResponse.json({ success: true, designation: result.data?.[0] })
  } catch (error) {
    console.error('Error updating designation:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to update designation' },
      { status: 500 }
    )
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id)

    // Check if designation exists
    const designationCheck = await query(
      'SELECT id FROM designations WHERE id = $1',
      [id]
    )
    if (!designationCheck.success || !designationCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Designation not found' },
        { status: 404 }
      )
    }

    // Check if designation is in use by any employees
    const employeeCheck = await query(
      'SELECT id FROM employees WHERE designation_id = $1 LIMIT 1',
      [id]
    )
    if (!employeeCheck.success) {
      throw new Error(employeeCheck.error)
    }
    if (employeeCheck.data?.length) {
      return NextResponse.json(
        { success: false, error: 'Cannot delete designation as it is assigned to employees' },
        { status: 400 }
      )
    }

    // Delete designation
    const result = await query('DELETE FROM designations WHERE id = $1', [id])
    if (!result.success) {
      throw new Error(result.error)
    }

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Error deleting designation:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to delete designation' },
      { status: 500 }
    )
  }
} 