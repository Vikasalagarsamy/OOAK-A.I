'use client';

import { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { format } from 'date-fns';
import { UserPlus, Eye, Trash2, Loader2, RefreshCw } from 'lucide-react';
import { toast } from '@/components/ui/use-toast';

interface UnassignedLead {
  id: number;
  lead_number: string;
  client_name: string;
  company_id: number;
  company_name: string;
  branch_id: number;
  branch_name: string;
  email: string;
  phone: string;
  lead_source: string;
  created_at: string;
  priority: string;
  notes?: string;
  status: string;
}

interface Employee {
  id: number;
  employee_id: string;
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  designation_name: string;
}

export default function UnassignedLeadsPage() {
  const [leads, setLeads] = useState<UnassignedLead[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedLead, setSelectedLead] = useState<UnassignedLead | null>(null);
  const [isAssignDialogOpen, setIsAssignDialogOpen] = useState(false);
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [eligibleEmployees, setEligibleEmployees] = useState<Employee[]>([]);
  const [isAssigning, setIsAssigning] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [isLoadingEmployees, setIsLoadingEmployees] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  useEffect(() => {
    fetchUnassignedLeads();
  }, []);

  const fetchUnassignedLeads = async () => {
    try {
      setIsLoading(true);
      const response = await fetch('/api/leads/unassigned');
      const data = await response.json();

      if (data.success) {
        setLeads(data.leads);
      } else {
        throw new Error(data.message || 'Failed to fetch unassigned leads');
      }
    } catch (error) {
      console.error('Error fetching unassigned leads:', error);
      toast({
        title: 'Error',
        description: 'Failed to fetch unassigned leads',
        variant: 'destructive',
      });
    } finally {
      setIsLoading(false);
      setIsRefreshing(false);
    }
  };

  const handleRefresh = () => {
    setIsRefreshing(true);
    fetchUnassignedLeads();
  };

  const fetchEligibleEmployees = async (lead: UnassignedLead) => {
    try {
      setIsLoadingEmployees(true);
      const response = await fetch(
        `/api/leads/assign?company_id=${lead.company_id}&branch_id=${lead.branch_id}`,
        {
          method: 'GET',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to fetch eligible employees');
      }

      const data = await response.json();

      if (data.success) {
        setEligibleEmployees(data.employees);
      } else {
        throw new Error(data.message || 'Failed to fetch eligible employees');
      }
    } catch (error) {
      console.error('Error fetching eligible employees:', error);
      toast({
        title: 'Error',
        description: error instanceof Error ? error.message : 'Failed to fetch eligible employees',
        variant: 'destructive',
      });
    } finally {
      setIsLoadingEmployees(false);
    }
  };

  const handleAssignClick = async (lead: UnassignedLead) => {
    setSelectedLead(lead);
    setIsAssignDialogOpen(true);
    await fetchEligibleEmployees(lead);
  };

  const handleViewClick = (lead: UnassignedLead) => {
    setSelectedLead(lead);
    setIsViewDialogOpen(true);
  };

  const handleDeleteClick = (lead: UnassignedLead) => {
    setSelectedLead(lead);
    setIsDeleteDialogOpen(true);
  };

  const handleAssignLead = async (employeeId: number) => {
    if (!selectedLead) return;

    try {
      setIsAssigning(true);
      const response = await fetch('/api/leads/assign', {
        method: 'POST',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          leadId: selectedLead.id,
          employeeId,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to assign lead');
      }

      const data = await response.json();

      if (data.success) {
        toast({
          title: 'Success',
          description: data.message || 'Lead assigned successfully',
        });
        setLeads(leads.filter(lead => lead.id !== selectedLead.id));
        setIsAssignDialogOpen(false);
        setSelectedLead(null);
      } else {
        throw new Error(data.message || 'Failed to assign lead');
      }
    } catch (error) {
      console.error('Error assigning lead:', error);
      toast({
        title: 'Error',
        description: error instanceof Error ? error.message : 'Failed to assign lead',
        variant: 'destructive',
      });
    } finally {
      setIsAssigning(false);
    }
  };

  const handleDeleteLead = async () => {
    if (!selectedLead) return;

    try {
      setIsDeleting(true);
      const response = await fetch(`/api/leads/${selectedLead.id}`, {
        method: 'DELETE',
      });

      const data = await response.json();

      if (data.success) {
        toast({
          title: 'Success',
          description: 'Lead deleted successfully',
        });
        setLeads(leads.filter(lead => lead.id !== selectedLead.id));
        setIsDeleteDialogOpen(false);
        setSelectedLead(null);
      } else {
        throw new Error(data.message || 'Failed to delete lead');
      }
    } catch (error) {
      console.error('Error deleting lead:', error);
      toast({
        title: 'Error',
        description: 'Failed to delete lead',
        variant: 'destructive',
      });
    } finally {
      setIsDeleting(false);
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'bg-red-100 text-red-800';
      case 'medium':
        return 'bg-yellow-100 text-yellow-800';
      case 'low':
        return 'bg-green-100 text-green-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getTodayLeadsCount = () => {
    const today = new Date();
    return leads.filter(lead => {
      const leadDate = new Date(lead.created_at);
      return (
        leadDate.getDate() === today.getDate() &&
        leadDate.getMonth() === today.getMonth() &&
        leadDate.getFullYear() === today.getFullYear()
      );
    }).length;
  };

  const getHighPriorityCount = () => {
    return leads.filter(lead => lead.priority.toLowerCase() === 'high').length;
  };

  return (
    <div className="p-6 space-y-6 w-full">
      {/* Stats Section */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="bg-white shadow-sm">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">Total Unassigned</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{leads.length}</div>
          </CardContent>
        </Card>
        <Card className="bg-white shadow-sm">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">High Priority</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{getHighPriorityCount()}</div>
          </CardContent>
        </Card>
        <Card className="bg-white shadow-sm">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">Today's New Leads</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">{getTodayLeadsCount()}</div>
          </CardContent>
        </Card>
      </div>

      {/* Main Content */}
      <Card className="bg-white shadow-sm">
        <CardHeader className="border-b">
          <div className="flex justify-between items-center">
            <CardTitle className="text-xl font-semibold">Unassigned Leads</CardTitle>
            <Button 
              variant="outline" 
              size="sm" 
              onClick={handleRefresh}
              disabled={isRefreshing}
            >
              <RefreshCw className={`h-4 w-4 mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
              Refresh
            </Button>
          </div>
        </CardHeader>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="flex justify-center items-center h-64">
              <Loader2 className="h-8 w-8 animate-spin text-gray-400" />
            </div>
          ) : leads.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-64 text-gray-500">
              <div className="text-lg font-medium">No unassigned leads found</div>
              <div className="text-sm">New leads will appear here when they are created</div>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow className="bg-gray-50">
                    <TableHead className="font-semibold">Lead #</TableHead>
                    <TableHead className="font-semibold">Client Name</TableHead>
                    <TableHead className="font-semibold">Company</TableHead>
                    <TableHead className="font-semibold">Branch</TableHead>
                    <TableHead className="font-semibold">Contact</TableHead>
                    <TableHead className="font-semibold">Source</TableHead>
                    <TableHead className="font-semibold">Priority</TableHead>
                    <TableHead className="font-semibold">Created At</TableHead>
                    <TableHead className="font-semibold text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {leads.map((lead) => (
                    <TableRow key={lead.id} className="hover:bg-gray-50">
                      <TableCell className="font-medium">{lead.lead_number}</TableCell>
                      <TableCell>{lead.client_name}</TableCell>
                      <TableCell>
                        <div className="flex items-center">
                          <span className="font-medium">{lead.company_name}</span>
                        </div>
                      </TableCell>
                      <TableCell>{lead.branch_name}</TableCell>
                      <TableCell>
                        <div className="flex flex-col gap-1">
                          <span className="text-sm font-medium">{lead.email}</span>
                          <span className="text-sm text-gray-500">{lead.phone}</span>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant="secondary" className="font-normal">
                          {lead.lead_source}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge className={`${getPriorityColor(lead.priority)} font-normal`}>
                          {lead.priority}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="text-sm text-gray-500">
                          {format(new Date(lead.created_at), 'MMM d, yyyy')}
                          <div className="text-xs">
                            {format(new Date(lead.created_at), 'h:mm a')}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex justify-end gap-2">
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleViewClick(lead)}
                            className="hover:bg-gray-100"
                          >
                            <Eye className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleAssignClick(lead)}
                            className="hover:bg-gray-100"
                          >
                            <UserPlus className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleDeleteClick(lead)}
                            className="text-red-600 hover:text-red-700 hover:bg-red-50"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>

      {/* View Dialog */}
      <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold flex items-center gap-2">
              <Eye className="h-5 w-5" />
              Lead Details
            </DialogTitle>
          </DialogHeader>
          {selectedLead && (
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-gray-500">Lead Number</label>
                  <div className="mt-1 text-base">{selectedLead.lead_number}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Client Name</label>
                  <div className="mt-1 text-base">{selectedLead.client_name}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Company</label>
                  <div className="mt-1 text-base">{selectedLead.company_name}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Branch</label>
                  <div className="mt-1 text-base">{selectedLead.branch_name}</div>
                </div>
              </div>
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-gray-500">Email</label>
                  <div className="mt-1 text-base">{selectedLead.email}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Phone</label>
                  <div className="mt-1 text-base">{selectedLead.phone}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Source</label>
                  <div className="mt-1">
                    <Badge variant="secondary" className="font-normal">
                      {selectedLead.lead_source}
                    </Badge>
                  </div>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500">Priority</label>
                  <div className="mt-1">
                    <Badge className={`${getPriorityColor(selectedLead.priority)} font-normal`}>
                      {selectedLead.priority}
                    </Badge>
                  </div>
                </div>
              </div>
              {selectedLead.notes && (
                <div className="col-span-2">
                  <label className="text-sm font-medium text-gray-500">Notes</label>
                  <div className="mt-1 text-base whitespace-pre-wrap">{selectedLead.notes}</div>
                </div>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Assign Dialog */}
      <Dialog open={isAssignDialogOpen} onOpenChange={setIsAssignDialogOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold flex items-center gap-2">
              <UserPlus className="h-5 w-5" />
              Assign Lead
            </DialogTitle>
            {selectedLead && (
              <DialogDescription>
                Select a sales team member from {selectedLead.company_name} - {selectedLead.branch_name}
              </DialogDescription>
            )}
          </DialogHeader>
          {isLoadingEmployees ? (
            <div className="flex justify-center items-center h-32">
              <Loader2 className="h-8 w-8 animate-spin text-gray-400" />
            </div>
          ) : eligibleEmployees.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <div className="text-lg font-medium">No eligible employees found</div>
              <div className="text-sm">There are no sales team members available in this branch</div>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-2 max-h-[400px] overflow-y-auto">
              {eligibleEmployees.map((employee) => (
                <Button
                  key={employee.id}
                  variant="outline"
                  className="flex items-center justify-between p-4 h-auto"
                  onClick={() => handleAssignLead(employee.id)}
                  disabled={isAssigning}
                >
                  <div className="flex flex-col items-start gap-1">
                    <div className="font-medium">
                      {employee.first_name} {employee.last_name}
                    </div>
                    <div className="text-sm text-gray-500">{employee.designation_name}</div>
                  </div>
                  <div className="flex flex-col items-end text-sm text-gray-500">
                    <div>{employee.email}</div>
                    <div>{employee.phone}</div>
                  </div>
                </Button>
              ))}
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Delete Dialog */}
      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold flex items-center gap-2 text-red-600">
              <Trash2 className="h-5 w-5" />
              Delete Lead
            </DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this lead? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setIsDeleteDialogOpen(false)}
              disabled={isDeleting}
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDeleteLead}
              disabled={isDeleting}
              className="gap-2"
            >
              {isDeleting && <Loader2 className="h-4 w-4 animate-spin" />}
              Delete Lead
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
} 