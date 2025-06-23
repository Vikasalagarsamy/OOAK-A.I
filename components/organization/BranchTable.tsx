"use client";

import { useState, useEffect } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Branch, BranchFormData } from '@/types/organization';
import { Trash2 } from 'lucide-react';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

interface Company {
  id: number;
  name: string;
}

interface BranchTableProps {
  branches: Branch[];
  onAddBranch: (data: BranchFormData) => Promise<void>;
  onEditBranch: (id: number, data: BranchFormData) => Promise<void>;
  onDeleteBranch: (id: number) => Promise<void>;
}

const emptyForm: BranchFormData = {
  name: '',
  company_id: 0,
  address: '',
  phone: '',
  email: '',
  manager_id: undefined,
  is_remote: false,
  branch_code: '',
  location: '',
};

interface BranchFormProps {
  initialData?: Branch;
  onSubmit: (data: BranchFormData) => Promise<void>;
  onCancel: () => void;
}

function BranchForm({ initialData, onSubmit, onCancel }: BranchFormProps) {
  const [data, setData] = useState<BranchFormData>(() => {
    if (!initialData) return emptyForm;
    return {
      name: initialData.name,
      company_id: initialData.company_id,
      address: initialData.address,
      phone: initialData.phone || '',
      email: initialData.email || '',
      manager_id: initialData.manager_id,
      is_remote: initialData.is_remote,
      branch_code: initialData.branch_code || '',
      location: initialData.location || '',
    };
  });

  const [companies, setCompanies] = useState<Company[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchCompanies = async () => {
      try {
        setIsLoading(true);
        const response = await fetch('/api/organization/companies');
        if (!response.ok) throw new Error('Failed to fetch companies');
        const data = await response.json();
        setCompanies(Array.isArray(data) ? data : []);
      } catch (error) {
        console.error('Error fetching companies:', error);
        setCompanies([]);
      } finally {
        setIsLoading(false);
      }
    };
    fetchCompanies();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSubmit(data);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type } = e.target;
    setData(prev => ({
      ...prev,
      [name]: type === 'number' ? Number(value) : value
    }));
  };

  const handleSwitchChange = (checked: boolean) => {
    setData(prev => ({ ...prev, is_remote: checked }));
  };

  const handleCompanyChange = (value: string) => {
    setData(prev => ({ ...prev, company_id: parseInt(value) }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="name">Branch Name *</Label>
          <Input
            id="name"
            name="name"
            value={data.name}
            onChange={handleChange}
            required
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="company_id">Company *</Label>
          <Select
            value={data.company_id ? data.company_id.toString() : ''}
            onValueChange={handleCompanyChange}
          >
            <SelectTrigger>
              <SelectValue placeholder="Select a company" />
            </SelectTrigger>
            <SelectContent>
              {isLoading ? (
                <SelectItem value="loading" disabled>
                  Loading companies...
                </SelectItem>
              ) : companies.length > 0 ? (
                companies.map((company) => (
                  <SelectItem key={company.id} value={company.id.toString()}>
                    {company.name}
                  </SelectItem>
                ))
              ) : (
                <SelectItem value="no-companies" disabled>
                  No companies available
                </SelectItem>
              )}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label htmlFor="branch_code">Branch Code</Label>
          <Input
            id="branch_code"
            name="branch_code"
            value={data.branch_code}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="location">Location</Label>
          <Input
            id="location"
            name="location"
            value={data.location}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="phone">Phone</Label>
          <Input
            id="phone"
            name="phone"
            type="tel"
            value={data.phone}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="email">Email</Label>
          <Input
            id="email"
            name="email"
            type="email"
            value={data.email}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="manager_id">Manager ID</Label>
          <Input
            id="manager_id"
            name="manager_id"
            type="number"
            value={data.manager_id || ''}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label>Remote Branch</Label>
          <div className="flex items-center space-x-2">
            <Switch
              id="is_remote"
              checked={data.is_remote}
              onCheckedChange={handleSwitchChange}
            />
            <Label htmlFor="is_remote">Is Remote</Label>
          </div>
        </div>
      </div>
      <div className="space-y-2">
        <Label htmlFor="address">Address *</Label>
        <Input
          id="address"
          name="address"
          value={data.address}
          onChange={handleChange}
          required
        />
      </div>
      <div className="flex justify-end space-x-2">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit">
          {initialData ? 'Update' : 'Add'} Branch
        </Button>
      </div>
    </form>
  );
}

export function BranchTable({ branches, onAddBranch, onEditBranch, onDeleteBranch }: BranchTableProps) {
  const [addDialogOpen, setAddDialogOpen] = useState(false);
  const [editingBranch, setEditingBranch] = useState<Branch | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deletingBranch, setDeletingBranch] = useState<Branch | null>(null);

  const handleAdd = async (data: BranchFormData) => {
    await onAddBranch(data);
    setAddDialogOpen(false);
  };

  const handleEdit = async (data: BranchFormData) => {
    if (editingBranch) {
      await onEditBranch(editingBranch.id, data);
      setEditingBranch(null);
    }
  };

  const handleDelete = async () => {
    if (deletingBranch) {
      await onDeleteBranch(deletingBranch.id);
      setDeleteDialogOpen(false);
      setDeletingBranch(null);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Branches</h2>
        <Dialog open={addDialogOpen} onOpenChange={setAddDialogOpen}>
          <DialogTrigger asChild>
            <Button>Add Branch</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Add New Branch</DialogTitle>
            </DialogHeader>
            <BranchForm
              onSubmit={handleAdd}
              onCancel={() => setAddDialogOpen(false)}
            />
          </DialogContent>
        </Dialog>
      </div>

      <div className="border rounded-lg">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Company</TableHead>
              <TableHead>Location</TableHead>
              <TableHead>Branch Code</TableHead>
              <TableHead>Phone</TableHead>
              <TableHead>Email</TableHead>
              <TableHead>Remote</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {branches.map((branch) => (
              <TableRow key={branch.id}>
                <TableCell>{branch.name}</TableCell>
                <TableCell>{branch.company_name}</TableCell>
                <TableCell>{branch.location}</TableCell>
                <TableCell>{branch.branch_code}</TableCell>
                <TableCell>{branch.phone}</TableCell>
                <TableCell>{branch.email}</TableCell>
                <TableCell>{branch.is_remote ? 'Yes' : 'No'}</TableCell>
                <TableCell>
                  <div className="flex justify-end space-x-2">
                    <Dialog open={editingBranch?.id === branch.id} onOpenChange={(open) => {
                      if (!open) setEditingBranch(null);
                    }}>
                      <DialogTrigger asChild>
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => setEditingBranch(branch)}
                        >
                          Edit
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Edit Branch</DialogTitle>
                        </DialogHeader>
                        <BranchForm
                          initialData={branch}
                          onSubmit={handleEdit}
                          onCancel={() => setEditingBranch(null)}
                        />
                      </DialogContent>
                    </Dialog>
                    
                    <Dialog open={deleteDialogOpen && deletingBranch?.id === branch.id} onOpenChange={setDeleteDialogOpen}>
                      <DialogTrigger asChild>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="text-red-600 hover:text-red-800 hover:bg-red-100"
                          onClick={() => {
                            setDeletingBranch(branch);
                            setDeleteDialogOpen(true);
                          }}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Delete Branch</DialogTitle>
                        </DialogHeader>
                        <div className="py-4">
                          <p>Are you sure you want to delete {branch.name}?</p>
                          <p className="text-sm text-gray-500 mt-1">This action cannot be undone.</p>
                        </div>
                        <div className="flex justify-end space-x-2">
                          <Button
                            variant="outline"
                            onClick={() => {
                              setDeleteDialogOpen(false);
                              setDeletingBranch(null);
                            }}
                          >
                            Cancel
                          </Button>
                          <Button
                            variant="destructive"
                            onClick={handleDelete}
                          >
                            Delete
                          </Button>
                        </div>
                      </DialogContent>
                    </Dialog>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
} 