'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Badge } from '@/components/ui/badge'
import { useToast } from '@/components/ui/use-toast'
import { useRouter } from 'next/navigation'

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

export default function EmployeesPage() {
  const [employees, setEmployees] = useState<Employee[]>([])
  const [departments, setDepartments] = useState<Department[]>([])
  const [designations, setDesignations] = useState<Designation[]>([])
  const [branches, setBranches] = useState<Branch[]>([])
  const [companies, setCompanies] = useState<Company[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false)
  const [nextEmployeeId, setNextEmployeeId] = useState('')
  const [selectedCompanyId, setSelectedCompanyId] = useState<string>('')
  const [selectedDepartmentId, setSelectedDepartmentId] = useState<string>('')
  const [filteredBranches, setFilteredBranches] = useState<Branch[]>([])
  const [filteredDesignations, setFilteredDesignations] = useState<Designation[]>([])
  const { toast } = useToast()
  const router = useRouter()

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch all initial data in parallel
        const [employeesPromise, departmentsPromise, companiesPromise, nextIdPromise] = [
          fetchEmployees(),
          fetch('/api/departments'),
          fetch('/api/organization/companies'),
          fetch('/api/people/employees/next-id')
        ]

        // Wait for all requests to complete
        const [
          _,
          departmentsRes,
          companiesRes,
          nextIdRes
        ] = await Promise.all([
          employeesPromise,
          departmentsPromise,
          companiesPromise,
          nextIdPromise
        ])

        // Process departments
        const departmentsData = await departmentsRes.json()
        if (departmentsData.success) {
          setDepartments(departmentsData.departments)
        } else {
          console.error('Failed to fetch departments:', departmentsData.error)
        }

        // Process companies
        const companiesData = await companiesRes.json()
        if (companiesData.success) {
          setCompanies(companiesData.companies)
        } else {
          console.error('Failed to fetch companies:', companiesData.error)
        }

        // Process next employee ID
        const nextIdData = await nextIdRes.json()
        if (nextIdData.success) {
          setNextEmployeeId(nextIdData.nextId)
        } else {
          console.error('Failed to fetch next employee ID:', nextIdData.error)
        }
      } catch (error) {
        console.error('Error fetching data:', error)
        toast({
          title: 'Error',
          description: 'Failed to fetch data',
          variant: 'destructive'
        })
      }
    }

    fetchData()
  }, [toast])

  // Fetch branches when company is selected
  useEffect(() => {
    const fetchBranches = async () => {
      if (!selectedCompanyId) {
        setFilteredBranches([])
        return
      }

      try {
        const response = await fetch(`/api/organization/branches/by-company/${selectedCompanyId}`)
        const data = await response.json()
        if (data.success) {
          setFilteredBranches(data.branches)
        }
      } catch (error) {
        console.error('Error fetching branches:', error)
        toast({
          title: 'Error',
          description: 'Failed to fetch branches',
          variant: 'destructive'
        })
      }
    }

    fetchBranches()
  }, [selectedCompanyId, toast])

  // Fetch designations when department is selected
  useEffect(() => {
    const fetchDesignations = async () => {
      if (!selectedDepartmentId) {
        setFilteredDesignations([])
        return
      }

      try {
        const response = await fetch(`/api/designations/by-department/${selectedDepartmentId}`)
        const data = await response.json()
        if (data.success) {
          setFilteredDesignations(data.designations)
        }
      } catch (error) {
        console.error('Error fetching designations:', error)
        toast({
          title: 'Error',
          description: 'Failed to fetch designations',
          variant: 'destructive'
        })
      }
    }

    fetchDesignations()
  }, [selectedDepartmentId, toast])

  // Fetch employees data
  const fetchEmployees = async () => {
    try {
      const response = await fetch('/api/people/employees')
      const data = await response.json()
      if (data.success) {
        setEmployees(data.employees)
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to fetch employees',
          variant: 'destructive'
        })
      }
    } catch (error) {
      console.error('Error fetching employees:', error)
      toast({
        title: 'Error',
        description: 'Failed to fetch employees',
        variant: 'destructive'
      })
    } finally {
      setIsLoading(false)
    }
  }

  // Add new employee
  const handleAddEmployee = async (formData: FormData) => {
    try {
      // Convert form data to object and ensure numeric fields are numbers
      const formValues = Object.fromEntries(formData)
      const employeeData = {
        ...formValues,
        department_id: parseInt(formValues.department_id as string),
        designation_id: parseInt(formValues.designation_id as string),
        company_id: parseInt(formValues.company_id as string),
        branch_id: parseInt(formValues.branch_id as string)
      }

      const response = await fetch('/api/people/employees', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(employeeData)
      })

      const responseData = await response.json()
      if (responseData.success) {
        toast({
          title: 'Success',
          description: 'Employee added successfully'
        })
        setIsAddDialogOpen(false)
        fetchEmployees()
      } else {
        toast({
          title: 'Error',
          description: responseData.error || 'Failed to add employee',
          variant: 'destructive'
        })
      }
    } catch (error) {
      console.error('Error adding employee:', error)
      toast({
        title: 'Error',
        description: 'Failed to add employee',
        variant: 'destructive'
      })
    }
  }

  // Delete employee
  const handleDeleteEmployee = async (id: number) => {
    if (!confirm('Are you sure you want to delete this employee?')) return

    try {
      const response = await fetch(`/api/people/employees/${id}`, {
        method: 'DELETE'
      })

      const data = await response.json()
      if (data.success) {
        toast({
          title: 'Success',
          description: 'Employee deleted successfully'
        })
        fetchEmployees()
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to delete employee',
          variant: 'destructive'
        })
      }
    } catch (error) {
      console.error('Error deleting employee:', error)
      toast({
        title: 'Error',
        description: 'Failed to delete employee',
        variant: 'destructive'
      })
    }
  }

  return (
    <div className="p-6">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Employees</CardTitle>
          <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
            <DialogTrigger asChild>
              <Button>Add Employee</Button>
            </DialogTrigger>
                      <DialogContent>
            <DialogHeader>
              <DialogTitle>Add New Employee</DialogTitle>
            </DialogHeader>
            {isLoading ? (
              <div className="flex items-center justify-center py-6">
                Loading...
              </div>
            ) : (
              <form action={handleAddEmployee} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="employee_id">Employee ID</Label>
                    <Input 
                      id="employee_id" 
                      name="employee_id" 
                      value={nextEmployeeId}
                      readOnly
                      required 
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="first_name">First Name</Label>
                    <Input id="first_name" name="first_name" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="last_name">Last Name</Label>
                    <Input id="last_name" name="last_name" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="email">Email</Label>
                    <Input id="email" name="email" type="email" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="phone">Phone</Label>
                    <Input id="phone" name="phone" type="tel" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="company_id">Company</Label>
                    <Select 
                      name="company_id" 
                      value={selectedCompanyId}
                      onValueChange={(value) => {
                        setSelectedCompanyId(value)
                        // Reset branch when company changes
                        const form = document.querySelector('form') as HTMLFormElement
                        if (form) {
                          form.branch_id.value = ''
                        }
                      }}
                      required
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
                    <Label htmlFor="branch_id">Branch</Label>
                    <Select 
                      name="branch_id" 
                      required
                      disabled={!selectedCompanyId}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder={selectedCompanyId ? "Select branch" : "Select company first"} />
                      </SelectTrigger>
                      <SelectContent>
                        {filteredBranches.map((branch) => (
                          <SelectItem key={branch.id} value={branch.id.toString()}>
                            {branch.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="department_id">Department</Label>
                    <Select 
                      name="department_id" 
                      value={selectedDepartmentId}
                      onValueChange={(value) => {
                        setSelectedDepartmentId(value)
                        // Reset designation when department changes
                        const form = document.querySelector('form') as HTMLFormElement
                        if (form) {
                          form.designation_id.value = ''
                        }
                      }}
                      required
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
                    <Label htmlFor="designation_id">Designation</Label>
                    <Select 
                      name="designation_id" 
                      required
                      disabled={!selectedDepartmentId}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder={selectedDepartmentId ? "Select designation" : "Select department first"} />
                      </SelectTrigger>
                      <SelectContent>
                        {filteredDesignations.map((designation) => (
                          <SelectItem key={designation.id} value={designation.id.toString()}>
                            {designation.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <Button type="submit" className="w-full">Add Employee</Button>
              </form>
            )}
            </DialogContent>
          </Dialog>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Employee ID</TableHead>
                  <TableHead>Name</TableHead>
                  <TableHead>Email</TableHead>
                  <TableHead>Phone</TableHead>
                  <TableHead>Designation</TableHead>
                  <TableHead>Department</TableHead>
                  <TableHead>Branch</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                  <TableRow>
                    <TableCell colSpan={9} className="text-center">
                      Loading...
                    </TableCell>
                  </TableRow>
                ) : employees.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={9} className="text-center">
                      No employees found
                    </TableCell>
                  </TableRow>
                ) : (
                  employees.map((employee) => (
                    <TableRow key={employee.id}>
                      <TableCell>{employee.employee_id}</TableCell>
                      <TableCell>{`${employee.first_name} ${employee.last_name}`}</TableCell>
                      <TableCell>{employee.email}</TableCell>
                      <TableCell>{employee.phone}</TableCell>
                      <TableCell>{employee.designation_name}</TableCell>
                      <TableCell>{employee.department_name}</TableCell>
                      <TableCell>{employee.branch_name}</TableCell>
                      <TableCell>
                        <Badge variant={employee.status === 'active' ? 'default' : 'secondary'}>
                          {employee.status}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="flex gap-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => router.push(`/people/employees/${employee.id}/edit`)}
                          >
                            Edit
                          </Button>
                          <Button
                            variant="destructive"
                            size="sm"
                            onClick={() => handleDeleteEmployee(employee.id)}
                          >
                            Delete
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  )))
                }
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  )
} 