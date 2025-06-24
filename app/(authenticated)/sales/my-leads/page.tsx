'use client';

import * as React from 'react';
import { Loader2, RefreshCw, Eye, Edit, X } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { toast } from '@/components/ui/use-toast';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage, FormDescription } from '@/components/ui/form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Switch } from '@/components/ui/switch';

interface Lead {
  id: number;
  lead_number: string;
  client_name: string;
  company_name: string;
  branch_name: string;
  email: string;
  phone: string;
  country_code: string;
  lead_source: string;
  priority: string;
  created_at: string;
  status: string;
  notes?: string;
  bride_name?: string;
  groom_name?: string;
  wedding_date?: string;
  venue_preference?: string;
  guest_count?: number;
  budget_range?: string;
  expected_value?: number;
  description?: string;
  is_whatsapp?: boolean;
  has_separate_whatsapp?: boolean;
  whatsapp_country_code?: string;
  whatsapp_number?: string;
  location?: string;
  tags?: string[];
  lead_score?: number;
  conversion_stage?: string;
  last_contact_date?: string;
  next_follow_up_date?: string;
}

const editLeadSchema = z.object({
  client_name: z.string().min(1, 'Client name is required'),
  email: z.string().email('Invalid email address'),
  phone: z.string().min(1, 'Phone number is required'),
  country_code: z.string().min(1, 'Country code is required'),
  whatsapp_country_code: z.string().optional(),
  whatsapp_number: z.string().optional(),
  priority: z.enum(['low', 'medium', 'high']),
  bride_name: z.string().optional(),
  groom_name: z.string().optional(),
  wedding_date: z.string().optional().transform((val) => val || ''),
  venue_preference: z.string().optional(),
  guest_count: z.coerce.number().optional(),
  budget_range: z.string().min(1, 'Budget range is required'),
  notes: z.string().optional(),
  description: z.string().optional(),
  location: z.string().optional(),
  tags: z.array(z.string()).optional(),
  lead_score: z.coerce.number().optional(),
  conversion_stage: z.string().optional(),
  expected_value: z.coerce.number().optional(),
  last_contact_date: z.string().optional(),
  next_follow_up_date: z.string().optional(),
});

type EditLeadFormValues = z.infer<typeof editLeadSchema>;

interface EditLeadFormProps {
  lead: Lead;
  onSubmit: (data: EditLeadFormValues) => void;
  onCancel: () => void;
  isSubmitting: boolean;
}

function EditLeadForm({ lead, onSubmit, onCancel, isSubmitting }: EditLeadFormProps) {
  const form = useForm<EditLeadFormValues>({
    resolver: zodResolver(editLeadSchema),
    defaultValues: {
      client_name: lead.client_name,
      email: lead.email || '',
      phone: lead.phone,
      country_code: lead.country_code || '+91',
      whatsapp_country_code: lead.whatsapp_country_code || '+91',
      whatsapp_number: lead.whatsapp_number || '',
      priority: lead.priority as 'low' | 'medium' | 'high',
      bride_name: lead.bride_name || '',
      groom_name: lead.groom_name || '',
      wedding_date: lead.wedding_date || '',
      venue_preference: lead.venue_preference || '',
      guest_count: lead.guest_count || undefined,
      budget_range: lead.budget_range || '0-100000',
      notes: lead.notes || '',
      description: lead.description || '',
      location: lead.location || '',
      tags: lead.tags || [],
      lead_score: lead.lead_score || 50,
      conversion_stage: lead.conversion_stage || 'new',
      expected_value: lead.expected_value || 0,
      last_contact_date: lead.last_contact_date ? new Date(lead.last_contact_date).toISOString().split('T')[0] : '',
      next_follow_up_date: lead.next_follow_up_date ? new Date(lead.next_follow_up_date).toISOString().split('T')[0] : '',
    },
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <div className="grid grid-cols-2 gap-6">
          <div className="space-y-4">
            <h3 className="text-sm font-medium text-gray-500">Basic Information</h3>
            <FormField
              control={form.control}
              name="client_name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Client Name</FormLabel>
                  <FormControl>
                    <Input {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="email"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Email</FormLabel>
                  <FormControl>
                    <Input {...field} type="email" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <div className="grid grid-cols-2 gap-2">
              <FormField
                control={form.control}
                name="country_code"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Country Code</FormLabel>
                    <FormControl>
                      <Input {...field} disabled={isSubmitting} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="phone"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Phone</FormLabel>
                    <FormControl>
                      <Input {...field} disabled={isSubmitting} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <FormField
                control={form.control}
                name="whatsapp_country_code"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>WhatsApp Country Code</FormLabel>
                    <FormControl>
                      <Input {...field} disabled={isSubmitting} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="whatsapp_number"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>WhatsApp Number</FormLabel>
                    <FormControl>
                      <Input {...field} disabled={isSubmitting} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <FormField
              control={form.control}
              name="priority"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Priority</FormLabel>
                  <Select 
                    onValueChange={field.onChange}
                    defaultValue={field.value}
                    disabled={isSubmitting}
                  >
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Select priority" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="low">Low</SelectItem>
                      <SelectItem value="medium">Medium</SelectItem>
                      <SelectItem value="high">High</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="location"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Location</FormLabel>
                  <FormControl>
                    <Input {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
          <div className="space-y-4">
            <h3 className="text-sm font-medium text-gray-500">Wedding Details</h3>
            <FormField
              control={form.control}
              name="bride_name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Bride Name</FormLabel>
                  <FormControl>
                    <Input {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="groom_name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Groom Name</FormLabel>
                  <FormControl>
                    <Input {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="wedding_date"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Wedding Date</FormLabel>
                  <FormControl>
                    <Input 
                      type="date"
                      {...field}
                      value={field.value || ''}
                      disabled={isSubmitting}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="venue_preference"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Venue Preference</FormLabel>
                  <FormControl>
                    <Input {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="guest_count"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Guest Count</FormLabel>
                  <FormControl>
                    <Input {...field} type="number" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="budget_range"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Budget Range</FormLabel>
                  <Select 
                    onValueChange={field.onChange}
                    defaultValue={field.value}
                    disabled={isSubmitting}
                  >
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Select budget range" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="0-100000">Below 1L</SelectItem>
                      <SelectItem value="100000-200000">1L - 2L</SelectItem>
                      <SelectItem value="200000-500000">2L - 5L</SelectItem>
                      <SelectItem value="500000-1000000">5L - 10L</SelectItem>
                      <SelectItem value="1000000+">Above 10L</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="expected_value"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Expected Value</FormLabel>
                  <FormControl>
                    <Input {...field} type="number" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </div>
        <div className="grid grid-cols-2 gap-6">
          <div className="space-y-4">
            <h3 className="text-sm font-medium text-gray-500">Follow-up Details</h3>
            <FormField
              control={form.control}
              name="conversion_stage"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Conversion Stage</FormLabel>
                  <Select 
                    onValueChange={field.onChange}
                    defaultValue={field.value}
                    disabled={isSubmitting}
                  >
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Select conversion stage" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="new">New</SelectItem>
                      <SelectItem value="contacted">Contacted</SelectItem>
                      <SelectItem value="interested">Interested</SelectItem>
                      <SelectItem value="negotiating">Negotiating</SelectItem>
                      <SelectItem value="won">Won</SelectItem>
                      <SelectItem value="lost">Lost</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="lead_score"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Lead Score</FormLabel>
                  <FormControl>
                    <Input {...field} type="number" min="0" max="100" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="last_contact_date"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Last Contact Date</FormLabel>
                  <FormControl>
                    <Input {...field} type="date" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="next_follow_up_date"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Next Follow-up Date</FormLabel>
                  <FormControl>
                    <Input {...field} type="date" disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
          <div className="space-y-4">
            <h3 className="text-sm font-medium text-gray-500">Additional Information</h3>
            <FormField
              control={form.control}
              name="notes"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Notes</FormLabel>
                  <FormControl>
                    <Textarea {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="description"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Description</FormLabel>
                  <FormControl>
                    <Textarea {...field} disabled={isSubmitting} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
        </div>
        <div className="flex justify-end space-x-2">
          <Button
            type="button"
            variant="outline"
            onClick={onCancel}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Saving...
              </>
            ) : (
              'Save Changes'
            )}
          </Button>
        </div>
      </form>
    </Form>
  );
}

export default function MyLeadsPage() {
  const [leads, setLeads] = React.useState<Lead[]>([]);
  const [isLoading, setIsLoading] = React.useState(true);
  const [isRefreshing, setIsRefreshing] = React.useState(false);
  const [selectedLead, setSelectedLead] = React.useState<Lead | null>(null);
  const [isViewDialogOpen, setIsViewDialogOpen] = React.useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = React.useState(false);
  const [isSubmitting, setIsSubmitting] = React.useState(false);

  const fetchMyLeads = async () => {
    try {
      setIsLoading(true);
      const response = await fetch('/api/leads/my-leads', {
        credentials: 'include',
      });

      if (!response.ok) {
        throw new Error('Failed to fetch leads');
      }

      const data = await response.json();

      if (data.success) {
        setLeads(data.leads);
      } else {
        throw new Error(data.message || 'Failed to fetch leads');
      }
    } catch (error) {
      console.error('Error fetching leads:', error);
      toast({
        title: 'Error',
        description: 'Failed to fetch leads',
        variant: 'destructive',
      });
    } finally {
      setIsLoading(false);
    }
  };

  React.useEffect(() => {
    fetchMyLeads();
  }, []);

  const handleRefresh = () => {
    setIsRefreshing(true);
    fetchMyLeads().finally(() => setIsRefreshing(false));
  };

  const handleViewClick = (lead: Lead) => {
    setSelectedLead(lead);
    setIsViewDialogOpen(true);
  };

  const handleEditClick = (lead: Lead) => {
    setSelectedLead(lead);
    setIsEditDialogOpen(true);
  };

  const handleEditSubmit = async (data: EditLeadFormValues) => {
    if (!selectedLead) return;

    try {
      setIsSubmitting(true);
      
      // Format dates and handle data types
      const formattedData = {
        ...data,
        guest_count: data.guest_count ? Number(data.guest_count) : undefined,
        lead_score: data.lead_score ? Number(data.lead_score) : 50,
        expected_value: data.expected_value ? Number(data.expected_value) : 0,
        wedding_date: data.wedding_date || undefined,
        last_contact_date: data.last_contact_date || undefined,
        next_follow_up_date: data.next_follow_up_date || undefined,
        tags: data.tags || [],
      };

      console.log('Submitting data:', formattedData);

      const response = await fetch(`/api/leads/${selectedLead.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formattedData),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to update lead');
      }

      const result = await response.json();

      if (result.success) {
        // Update the leads list with the edited lead
        setLeads(leads.map(lead => 
          lead.id === selectedLead.id 
            ? { ...lead, ...result.lead }
            : lead
        ));

        toast({
          title: 'Success',
          description: 'Lead updated successfully',
        });

        setIsEditDialogOpen(false);
      } else {
        throw new Error(result.message || 'Failed to update lead');
      }
    } catch (error) {
      console.error('Error updating lead:', error);
      toast({
        title: 'Error',
        description: error instanceof Error ? error.message : 'Failed to update lead',
        variant: 'destructive',
      });
    } finally {
      setIsSubmitting(false);
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
            <CardTitle className="text-sm font-medium text-gray-500">Total Leads</CardTitle>
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
            <CardTitle className="text-xl font-semibold">My Leads</CardTitle>
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
              <div className="text-lg font-medium">No leads found</div>
              <div className="text-sm">You don't have any leads assigned to you yet</div>
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
                    <TableHead className="font-semibold">Status</TableHead>
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
                        <Badge className={`font-normal ${getPriorityColor(lead.priority)}`}>
                          {lead.priority}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        {new Date(lead.created_at).toLocaleDateString('en-US', {
                          year: 'numeric',
                          month: 'short',
                          day: 'numeric',
                        })}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className="font-normal">
                          {lead.status}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex justify-end gap-2">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleViewClick(lead)}
                          >
                            <Eye className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleEditClick(lead)}
                          >
                            <Edit className="h-4 w-4" />
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

      {/* View Lead Dialog */}
      <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <div className="flex items-center justify-between">
              <DialogTitle className="text-xl font-semibold flex items-center gap-2">
                <Eye className="h-5 w-5" />
                Lead Details
              </DialogTitle>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setIsViewDialogOpen(false)}
                className="h-8 w-8"
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          </DialogHeader>
          {selectedLead && (
            <div className="space-y-6">
              <div className="grid grid-cols-2 gap-6">
                <div className="space-y-4">
                  <div>
                    <h3 className="text-sm font-medium text-gray-500">Basic Information</h3>
                    <div className="mt-2 space-y-3">
                      <div>
                        <span className="text-sm font-medium text-gray-900">Lead Number</span>
                        <p className="mt-1">{selectedLead.lead_number}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Client Name</span>
                        <p className="mt-1">{selectedLead.client_name}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Email</span>
                        <p className="mt-1">{selectedLead.email}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Phone</span>
                        <p className="mt-1">{selectedLead.phone}</p>
                      </div>
                    </div>
                  </div>
                  <div>
                    <h3 className="text-sm font-medium text-gray-500">Company Details</h3>
                    <div className="mt-2 space-y-3">
                      <div>
                        <span className="text-sm font-medium text-gray-900">Company</span>
                        <p className="mt-1">{selectedLead.company_name}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Branch</span>
                        <p className="mt-1">{selectedLead.branch_name}</p>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="space-y-4">
                  <div>
                    <h3 className="text-sm font-medium text-gray-500">Wedding Details</h3>
                    <div className="mt-2 space-y-3">
                      <div>
                        <span className="text-sm font-medium text-gray-900">Bride Name</span>
                        <p className="mt-1">{selectedLead.bride_name || 'N/A'}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Groom Name</span>
                        <p className="mt-1">{selectedLead.groom_name || 'N/A'}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Wedding Date</span>
                        <p className="mt-1">{selectedLead.wedding_date || 'Not set'}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Venue</span>
                        <p className="mt-1">{selectedLead.venue_preference || 'Not specified'}</p>
                      </div>
                    </div>
                  </div>
                  <div>
                    <h3 className="text-sm font-medium text-gray-500">Event Details</h3>
                    <div className="mt-2 space-y-3">
                      <div>
                        <span className="text-sm font-medium text-gray-900">Guest Count</span>
                        <p className="mt-1">{selectedLead.guest_count || 'Not specified'}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Budget Range</span>
                        <p className="mt-1">{selectedLead.budget_range || 'Not specified'}</p>
                      </div>
                      <div>
                        <span className="text-sm font-medium text-gray-900">Expected Value</span>
                        <p className="mt-1">{selectedLead.expected_value ? `₹${selectedLead.expected_value.toLocaleString()}` : 'Not specified'}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div>
                <h3 className="text-sm font-medium text-gray-500">Lead Status</h3>
                <div className="mt-2 space-y-3">
                  <div>
                    <span className="text-sm font-medium text-gray-900">Source</span>
                    <div className="mt-1">
                      <Badge variant="secondary">{selectedLead.lead_source}</Badge>
                    </div>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-900">Priority</span>
                    <div className="mt-1">
                      <Badge className={getPriorityColor(selectedLead.priority)}>
                        {selectedLead.priority}
                      </Badge>
                    </div>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-900">Status</span>
                    <div className="mt-1">
                      <Badge variant="outline">{selectedLead.status}</Badge>
                    </div>
                  </div>
                </div>
              </div>
              <div>
                <h3 className="text-sm font-medium text-gray-500">Additional Information</h3>
                <div className="mt-2 space-y-3">
                  <div>
                    <span className="text-sm font-medium text-gray-900">Notes</span>
                    <p className="mt-1 whitespace-pre-wrap">{selectedLead.notes || 'No notes'}</p>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-900">Description</span>
                    <p className="mt-1 whitespace-pre-wrap">{selectedLead.description || 'No description'}</p>
                  </div>
                </div>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Edit Lead Dialog */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <div className="flex items-center justify-between">
              <DialogTitle className="text-xl font-semibold flex items-center gap-2">
                <Edit className="h-5 w-5" />
                Edit Lead
              </DialogTitle>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setIsEditDialogOpen(false)}
                className="h-8 w-8"
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          </DialogHeader>
          {selectedLead && (
            <EditLeadForm
              lead={selectedLead}
              onSubmit={handleEditSubmit}
              onCancel={() => setIsEditDialogOpen(false)}
              isSubmitting={isSubmitting}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
} 