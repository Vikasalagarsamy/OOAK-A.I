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
import { Trash2, Edit } from 'lucide-react';
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
      address: initialData.address || '',
      phone: initialData.phone || '',
      email: initialData.email || '',
      manager_id: initialData.manager_id,
      is_remote: initialData.is_remote || false,
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
        if (!data.success) throw new Error(data.error || 'Failed to fetch companies');
        setCompanies(data.companies || []);
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
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="name">Branch Name *</Label>
          <Input
            id="name"
            name="name"
            value={data.name}
            onChange={handleChange}
            required
            className="w-full"
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="company_id">Company *</Label>
          <Select
            value={data.company_id ? data.company_id.toString() : ''}
            onValueChange={handleCompanyChange}
          >
            <SelectTrigger className="w-full">
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
            className="w-full"
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="location">Location</Label>
          <Input
            id="location"
            name="location"
            value={data.location}
            onChange={handleChange}
            className="w-full"
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
            className="w-full"
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
            className="w-full"
          />
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
          className="w-full"
        />
      </div>
      <div className="flex items-center space-x-2">
        <Switch
          id="is_remote"
          checked={data.is_remote}
          onCheckedChange={handleSwitchChange}
        />
        <Label htmlFor="is_remote">Remote Branch</Label>
      </div>
      <div className="flex justify-end space-x-2 pt-4">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit" variant="default">
          {initialData ? 'Update' : 'Add'} Branch
        </Button>
      </div>
    </form>
  );
}

export function BranchTable({ branches, onAddBranch, onEditBranch, onDeleteBranch }: BranchTableProps) {
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [selectedBranch, setSelectedBranch] = useState<Branch | null>(null);

  const handleAdd = async (data: BranchFormData) => {
    await onAddBranch(data);
    setIsAddDialogOpen(false);
  };

  const handleEdit = async (data: BranchFormData) => {
    if (selectedBranch) {
      await onEditBranch(selectedBranch.id, data);
      setIsEditDialogOpen(false);
      setSelectedBranch(null);
    }
  };

  const handleDelete = async () => {
    if (selectedBranch) {
      await onDeleteBranch(selectedBranch.id);
      setIsDeleteDialogOpen(false);
      setSelectedBranch(null);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Branches</h2>
        <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
          <DialogTrigger asChild>
            <Button>Add Branch</Button>
          </DialogTrigger>
          <DialogContent className="max-w-3xl">
            <DialogHeader>
              <DialogTitle>Add New Branch</DialogTitle>
            </DialogHeader>
            <BranchForm
              onSubmit={handleAdd}
              onCancel={() => setIsAddDialogOpen(false)}
            />
          </DialogContent>
        </Dialog>
      </div>

      <div className="rounded-md border shadow-sm">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Branch Name</TableHead>
              <TableHead>Company</TableHead>
              <TableHead>Branch Code</TableHead>
              <TableHead>Location</TableHead>
              <TableHead>Address</TableHead>
              <TableHead>Phone</TableHead>
              <TableHead>Email</TableHead>
              <TableHead>Remote</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {branches && branches.length > 0 ? (
              branches.map((branch) => (
                <TableRow key={branch.id}>
                  <TableCell className="font-medium">{branch.name}</TableCell>
                  <TableCell>{branch.company_name}</TableCell>
                  <TableCell>{branch.branch_code}</TableCell>
                  <TableCell>{branch.location}</TableCell>
                  <TableCell>{branch.address}</TableCell>
                  <TableCell>{branch.phone}</TableCell>
                  <TableCell>{branch.email}</TableCell>
                  <TableCell>{branch.is_remote ? 'Yes' : 'No'}</TableCell>
                  <TableCell className="text-right space-x-2">
                    <Dialog open={isEditDialogOpen && selectedBranch?.id === branch.id} onOpenChange={(open) => {
                      setIsEditDialogOpen(open);
                      if (!open) setSelectedBranch(null);
                    }}>
                      <DialogTrigger asChild>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => setSelectedBranch(branch)}
                        >
                          <Edit className="h-4 w-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent className="max-w-3xl">
                        <DialogHeader>
                          <DialogTitle>Edit Branch</DialogTitle>
                        </DialogHeader>
                        <BranchForm
                          initialData={branch}
                          onSubmit={handleEdit}
                          onCancel={() => {
                            setIsEditDialogOpen(false);
                            setSelectedBranch(null);
                          }}
                        />
                      </DialogContent>
                    </Dialog>

                    <Dialog open={isDeleteDialogOpen && selectedBranch?.id === branch.id} onOpenChange={(open) => {
                      setIsDeleteDialogOpen(open);
                      if (!open) setSelectedBranch(null);
                    }}>
                      <DialogTrigger asChild>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => setSelectedBranch(branch)}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Delete Branch</DialogTitle>
                        </DialogHeader>
                        <p>Are you sure you want to delete this branch?</p>
                        <div className="flex justify-end space-x-2 mt-4">
                          <Button variant="outline" onClick={() => {
                            setIsDeleteDialogOpen(false);
                            setSelectedBranch(null);
                          }}>
                            Cancel
                          </Button>
                          <Button variant="destructive" onClick={handleDelete}>
                            Delete
                          </Button>
                        </div>
                      </DialogContent>
                    </Dialog>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} className="text-center py-4">
                  No branches found
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
} 