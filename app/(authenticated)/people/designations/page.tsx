'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Badge } from '@/components/ui/badge'
import { toast } from '@/components/ui/use-toast'

interface Department {
  id: number
  name: string
}

interface Designation {
  id: number
  name: string
  department_id: number
  department_name: string
  description: string | null
  created_at: string
  updated_at: string
}

export default function DesignationsPage() {
  const router = useRouter()
  const [designations, setDesignations] = useState<Designation[]>([])
  const [departments, setDepartments] = useState<Department[]>([])
  const [loading, setLoading] = useState(true)
  const [selectedDepartment, setSelectedDepartment] = useState<string>('all')
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false)
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [selectedDesignation, setSelectedDesignation] = useState<Designation | null>(null)
  const [formData, setFormData] = useState({
    name: '',
    department_id: '',
    description: '',
  })

  // Fetch departments and designations on component mount
  useEffect(() => {
    fetchDepartments()
    fetchDesignations()
  }, [])

  const fetchDepartments = async () => {
    try {
      const response = await fetch('/api/departments')
      const data = await response.json()
      if (data.success) {
        setDepartments(data.departments)
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to fetch departments',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Error fetching departments:', error)
      toast({
        title: 'Error',
        description: 'Failed to fetch departments',
        variant: 'destructive',
      })
    }
  }

  const fetchDesignations = async () => {
    try {
      const response = await fetch('/api/designations')
      const data = await response.json()
      if (data.success) {
        setDesignations(data.designations)
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to fetch designations',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Error fetching designations:', error)
      toast({
        title: 'Error',
        description: 'Failed to fetch designations',
        variant: 'destructive',
      })
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const response = await fetch('/api/designations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      })
      const data = await response.json()
      if (data.success) {
        toast({
          title: 'Success',
          description: 'Designation created successfully',
        })
        setIsAddDialogOpen(false)
        setFormData({ name: '', department_id: '', description: '' })
        fetchDesignations()
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to create designation',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Error creating designation:', error)
      toast({
        title: 'Error',
        description: 'Failed to create designation',
        variant: 'destructive',
      })
    }
  }

  const handleEdit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!selectedDesignation) return

    try {
      const response = await fetch(`/api/designations/${selectedDesignation.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      })
      const data = await response.json()
      if (data.success) {
        toast({
          title: 'Success',
          description: 'Designation updated successfully',
        })
        setIsEditDialogOpen(false)
        setSelectedDesignation(null)
        setFormData({ name: '', department_id: '', description: '' })
        fetchDesignations()
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to update designation',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Error updating designation:', error)
      toast({
        title: 'Error',
        description: 'Failed to update designation',
        variant: 'destructive',
      })
    }
  }

  const handleDelete = async (id: number) => {
    if (!confirm('Are you sure you want to delete this designation?')) return

    try {
      const response = await fetch(`/api/designations/${id}`, {
        method: 'DELETE',
      })
      const data = await response.json()
      if (data.success) {
        toast({
          title: 'Success',
          description: 'Designation deleted successfully',
        })
        fetchDesignations()
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to delete designation',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Error deleting designation:', error)
      toast({
        title: 'Error',
        description: 'Failed to delete designation',
        variant: 'destructive',
      })
    }
  }

  const filteredDesignations = selectedDepartment === 'all'
    ? designations
    : designations.filter(d => d.department_id === parseInt(selectedDepartment))

  const groupedDesignations = filteredDesignations.reduce((acc, designation) => {
    const dept = designation.department_name
    if (!acc[dept]) {
      acc[dept] = []
    }
    acc[dept].push(designation)
    return acc
  }, {} as Record<string, Designation[]>)

  return (
    <div className="container mx-auto py-10">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Designations</h1>
        <div className="flex gap-4 items-center">
          <Select
            value={selectedDepartment}
            onValueChange={setSelectedDepartment}
          >
            <SelectTrigger className="w-[200px]">
              <SelectValue placeholder="Filter by Department" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Departments</SelectItem>
              {departments.map((dept) => (
                <SelectItem key={dept.id} value={dept.id.toString()}>
                  {dept.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
            <DialogTrigger asChild>
              <Button>Add Designation</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Add New Designation</DialogTitle>
              </DialogHeader>
              <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                  <Label htmlFor="name">Designation Name</Label>
                  <Input
                    id="name"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="department">Department</Label>
                  <Select
                    value={formData.department_id}
                    onValueChange={(value) => setFormData({ ...formData, department_id: value })}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Select Department" />
                    </SelectTrigger>
                    <SelectContent>
                      {departments.map((dept) => (
                        <SelectItem key={dept.id} value={dept.id.toString()}>
                          {dept.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div>
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  />
                </div>
                <Button type="submit" className="w-full">Create Designation</Button>
              </form>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      <div className="space-y-6">
        {Object.entries(groupedDesignations).map(([department, designations]) => (
          <div key={department} className="border rounded-lg">
            <div className="bg-muted p-4">
              <h2 className="text-lg font-semibold">{department}</h2>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Designation Name</TableHead>
                  <TableHead>Description</TableHead>
                  <TableHead>Created At</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {designations.map((designation) => (
                  <TableRow key={designation.id}>
                    <TableCell>{designation.name}</TableCell>
                    <TableCell>{designation.description}</TableCell>
                    <TableCell>{new Date(designation.created_at).toLocaleDateString()}</TableCell>
                    <TableCell>
                      <div className="flex gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            setSelectedDesignation(designation)
                            setFormData({
                              name: designation.name,
                              department_id: designation.department_id.toString(),
                              description: designation.description || '',
                            })
                            setIsEditDialogOpen(true)
                          }}
                        >
                          Edit
                        </Button>
                        <Button
                          variant="destructive"
                          size="sm"
                          onClick={() => handleDelete(designation.id)}
                        >
                          Delete
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        ))}
      </div>

      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Edit Designation</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleEdit} className="space-y-4">
            <div>
              <Label htmlFor="edit-name">Designation Name</Label>
              <Input
                id="edit-name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
              />
            </div>
            <div>
              <Label htmlFor="edit-department">Department</Label>
              <Select
                value={formData.department_id}
                onValueChange={(value) => setFormData({ ...formData, department_id: value })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select Department" />
                </SelectTrigger>
                <SelectContent>
                  {departments.map((dept) => (
                    <SelectItem key={dept.id} value={dept.id.toString()}>
                      {dept.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label htmlFor="edit-description">Description</Label>
              <Textarea
                id="edit-description"
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              />
            </div>
            <Button type="submit" className="w-full">Update Designation</Button>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
} 