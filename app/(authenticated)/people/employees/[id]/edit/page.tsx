'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { useToast } from '@/components/ui/use-toast'

interface Employee {
  id: number
  employee_id: string
  first_name: string
  last_name: string
  email: string
  phone: string
  status: string
  department_id: number
  designation_id: number
  company_id: number
  branch_id: number
  designation_name?: string
  department_name?: string
  branch_name?: string
  company_name?: string
}

interface Department {
  id: number
  name: string
}

interface Designation {
  id: number
  name: string
}

interface Branch {
  id: number
  name: string
}

interface Company {
  id: number
  name: string
}

export default function EditEmployeePage({ params }: { params: { id: string } }) {
  const [employee, setEmployee] = useState<Employee | null>(null)
  const [departments, setDepartments] = useState<Department[]>([])
  const [designations, setDesignations] = useState<Designation[]>([])
  const [branches, setBranches] = useState<Branch[]>([])
  const [companies, setCompanies] = useState<Company[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const { toast } = useToast()
  const router = useRouter()

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch employee data
        const employeeRes = await fetch(`/api/people/employees/${params.id}`)
        const employeeData = await employeeRes.json()
        
        if (!employeeData.success) {
          throw new Error(employeeData.error || 'Failed to fetch employee')
        }
        
        setEmployee(employeeData.employee)

        // Fetch departments
        const departmentsRes = await fetch('/api/departments')
        const departmentsData = await departmentsRes.json()
        setDepartments(departmentsData.departments || [])

        // Fetch designations
        const designationsRes = await fetch('/api/designations')
        const designationsData = await designationsRes.json()
        setDesignations(designationsData.designations || [])

        // Fetch branches
        const branchesRes = await fetch('/api/organization/branches')
        const branchesData = await branchesRes.json()
        setBranches(branchesData.branches || [])

        // Fetch companies
        const companiesRes = await fetch('/api/organization/companies')
        const companiesData = await companiesRes.json()
        setCompanies(companiesData.companies || [])
      } catch (error) {
        console.error('Error fetching data:', error)
        toast({
          title: 'Error',
          description: 'Failed to fetch employee data',
          variant: 'destructive'
        })
      } finally {
        setIsLoading(false)
      }
    }

    fetchData()
  }, [params.id, toast])

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    if (!employee) return

    try {
      const response = await fetch(`/api/people/employees/${params.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(employee)
      })

      const data = await response.json()
      if (data.success) {
        toast({
          title: 'Success',
          description: 'Employee updated successfully'
        })
        router.push('/people/employees')
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to update employee',
          variant: 'destructive'
        })
      }
    } catch (error) {
      console.error('Error updating employee:', error)
      toast({
        title: 'Error',
        description: 'Failed to update employee',
        variant: 'destructive'
      })
    }
  }

  if (isLoading || !employee) {
    return <div>Loading...</div>
  }

  return (
    <div className="p-6">
      <Card>
        <CardHeader>
          <CardTitle>Edit Employee</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="employee_id">Employee ID</Label>
                <Input
                  id="employee_id"
                  value={employee.employee_id}
                  onChange={(e) => setEmployee({ ...employee, employee_id: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="first_name">First Name</Label>
                <Input
                  id="first_name"
                  value={employee.first_name}
                  onChange={(e) => setEmployee({ ...employee, first_name: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="last_name">Last Name</Label>
                <Input
                  id="last_name"
                  value={employee.last_name}
                  onChange={(e) => setEmployee({ ...employee, last_name: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  value={employee.email || ''}
                  onChange={(e) => setEmployee({ ...employee, email: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="phone">Phone</Label>
                <Input
                  id="phone"
                  type="tel"
                  value={employee.phone || ''}
                  onChange={(e) => setEmployee({ ...employee, phone: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="designation">Designation</Label>
                <Select
                  value={employee.designation_id?.toString()}
                  onValueChange={(value) => setEmployee({ ...employee, designation_id: parseInt(value) })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select designation" />
                  </SelectTrigger>
                  <SelectContent>
                    {designations.map((designation) => (
                      <SelectItem key={designation.id} value={designation.id.toString()}>
                        {designation.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="department">Department</Label>
                <Select
                  value={employee.department_id?.toString()}
                  onValueChange={(value) => setEmployee({ ...employee, department_id: parseInt(value) })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select department" />
                  </SelectTrigger>
                  <SelectContent>
                    {departments.map((department) => (
                      <SelectItem key={department.id} value={department.id.toString()}>
                        {department.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="branch">Branch</Label>
                <Select
                  value={employee.branch_id?.toString()}
                  onValueChange={(value) => setEmployee({ ...employee, branch_id: parseInt(value) })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select branch" />
                  </SelectTrigger>
                  <SelectContent>
                    {branches.map((branch) => (
                      <SelectItem key={branch.id} value={branch.id.toString()}>
                        {branch.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="company">Company</Label>
                <Select
                  value={employee.company_id?.toString()}
                  onValueChange={(value) => setEmployee({ ...employee, company_id: parseInt(value) })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select company" />
                  </SelectTrigger>
                  <SelectContent>
                    {companies.map((company) => (
                      <SelectItem key={company.id} value={company.id.toString()}>
                        {company.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="status">Status</Label>
                <Select
                  value={employee.status}
                  onValueChange={(value) => setEmployee({ ...employee, status: value })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="active">Active</SelectItem>
                    <SelectItem value="inactive">Inactive</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="flex justify-end gap-4">
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push('/people/employees')}
              >
                Cancel
              </Button>
              <Button type="submit">Save Changes</Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  )
} 