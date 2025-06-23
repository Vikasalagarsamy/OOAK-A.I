import { useState, useCallback } from 'react';
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
import { Company, CompanyFormData } from '@/types/organization';
import { Trash2 } from 'lucide-react';

interface CompanyTableProps {
  companies: Company[];
  onAddCompany: (data: CompanyFormData) => Promise<void>;
  onEditCompany: (id: number, data: CompanyFormData) => Promise<void>;
  onDeleteCompany: (id: number) => Promise<void>;
}

const emptyForm: CompanyFormData = {
  name: '',
  registration_number: '',
  tax_id: '',
  address: '',
  phone: '',
  email: '',
  website: '',
  founded_date: '',
  company_code: '',
};

interface CompanyFormProps {
  initialData?: Company;
  onSubmit: (data: CompanyFormData) => Promise<void>;
  onCancel: () => void;
}

function CompanyForm({ initialData, onSubmit, onCancel }: CompanyFormProps) {
  const [data, setData] = useState<CompanyFormData>(() => {
    if (!initialData) return emptyForm;
    return {
      name: initialData.name,
      registration_number: initialData.registration_number || '',
      tax_id: initialData.tax_id || '',
      address: initialData.address || '',
      phone: initialData.phone || '',
      email: initialData.email || '',
      website: initialData.website || '',
      founded_date: initialData.founded_date || '',
      company_code: initialData.company_code || '',
    };
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSubmit(data);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="name">Company Name *</Label>
          <Input
            id="name"
            name="name"
            value={data.name}
            onChange={handleChange}
            required
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="registration_number">Registration Number</Label>
          <Input
            id="registration_number"
            name="registration_number"
            value={data.registration_number}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="tax_id">Tax ID</Label>
          <Input
            id="tax_id"
            name="tax_id"
            value={data.tax_id}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="company_code">Company Code</Label>
          <Input
            id="company_code"
            name="company_code"
            value={data.company_code}
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
          <Label htmlFor="website">Website</Label>
          <Input
            id="website"
            name="website"
            type="url"
            value={data.website}
            onChange={handleChange}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="founded_date">Founded Date</Label>
          <Input
            id="founded_date"
            name="founded_date"
            type="date"
            value={data.founded_date}
            onChange={handleChange}
          />
        </div>
      </div>
      <div className="space-y-2">
        <Label htmlFor="address">Address</Label>
        <Input
          id="address"
          name="address"
          value={data.address}
          onChange={handleChange}
        />
      </div>
      <div className="flex justify-end space-x-2">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit">
          {initialData ? 'Update' : 'Add'} Company
        </Button>
      </div>
    </form>
  );
}

export function CompanyTable({ companies, onAddCompany, onEditCompany, onDeleteCompany }: CompanyTableProps) {
  const [addDialogOpen, setAddDialogOpen] = useState(false);
  const [editingCompany, setEditingCompany] = useState<Company | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deletingCompany, setDeletingCompany] = useState<Company | null>(null);

  const handleAdd = async (data: CompanyFormData) => {
    await onAddCompany(data);
    setAddDialogOpen(false);
  };

  const handleEdit = async (data: CompanyFormData) => {
    if (editingCompany) {
      await onEditCompany(editingCompany.id, data);
      setEditingCompany(null);
    }
  };

  const handleDelete = async () => {
    if (deletingCompany) {
      await onDeleteCompany(deletingCompany.id);
      setDeleteDialogOpen(false);
      setDeletingCompany(null);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Companies</h2>
        <Dialog open={addDialogOpen} onOpenChange={setAddDialogOpen}>
          <DialogTrigger asChild>
            <Button>Add Company</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Add New Company</DialogTitle>
            </DialogHeader>
            <CompanyForm
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
              <TableHead>Registration No.</TableHead>
              <TableHead>Tax ID</TableHead>
              <TableHead>Phone</TableHead>
              <TableHead>Email</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {companies.map((company) => (
              <TableRow key={company.id}>
                <TableCell>{company.name}</TableCell>
                <TableCell>{company.registration_number}</TableCell>
                <TableCell>{company.tax_id}</TableCell>
                <TableCell>{company.phone}</TableCell>
                <TableCell>{company.email}</TableCell>
                <TableCell>
                  <div className="flex justify-end space-x-2">
                    <Dialog open={editingCompany?.id === company.id} onOpenChange={(open) => {
                      if (!open) setEditingCompany(null);
                    }}>
                      <DialogTrigger asChild>
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => setEditingCompany(company)}
                        >
                          Edit
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Edit Company</DialogTitle>
                        </DialogHeader>
                        <CompanyForm
                          initialData={company}
                          onSubmit={handleEdit}
                          onCancel={() => setEditingCompany(null)}
                        />
                      </DialogContent>
                    </Dialog>
                    
                    <Dialog open={deleteDialogOpen && deletingCompany?.id === company.id} onOpenChange={setDeleteDialogOpen}>
                      <DialogTrigger asChild>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="text-red-600 hover:text-red-800 hover:bg-red-100"
                          onClick={() => {
                            setDeletingCompany(company);
                            setDeleteDialogOpen(true);
                          }}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Delete Company</DialogTitle>
                        </DialogHeader>
                        <div className="py-4">
                          <p>Are you sure you want to delete {company.name}?</p>
                          <p className="text-sm text-gray-500 mt-1">This action cannot be undone.</p>
                        </div>
                        <div className="flex justify-end space-x-2">
                          <Button
                            variant="outline"
                            onClick={() => {
                              setDeleteDialogOpen(false);
                              setDeletingCompany(null);
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