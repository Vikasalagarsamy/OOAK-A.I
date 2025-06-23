'use client';

import { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';

interface UnassignedLead {
  id: number;
  lead_number: string;
  client_name: string;
  company_id: number;
  branch_id: number;
  email: string;
  phone: string;
  lead_source: string;
  created_at: string;
  priority: string;
}

export default function UnassignedLeadsPage() {
  const [leads, setLeads] = useState<UnassignedLead[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchUnassignedLeads = async () => {
      try {
        const response = await fetch('/api/leads/unassigned');
        const data = await response.json();

        if (data.success) {
          setLeads(data.leads);
        } else {
          throw new Error(data.message || 'Failed to fetch unassigned leads');
        }
      } catch (error) {
        console.error('Error fetching unassigned leads:', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchUnassignedLeads();
  }, []);

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

  return (
    <div className="container mx-auto py-6">
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl font-bold">Unassigned Leads</CardTitle>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="flex justify-center items-center h-32">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
            </div>
          ) : leads.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              No unassigned leads found
            </div>
          ) : (
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Lead #</TableHead>
                    <TableHead>Client Name</TableHead>
                    <TableHead>Contact</TableHead>
                    <TableHead>Source</TableHead>
                    <TableHead>Priority</TableHead>
                    <TableHead>Created At</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {leads.map((lead) => (
                    <TableRow key={lead.id}>
                      <TableCell className="font-medium">{lead.lead_number}</TableCell>
                      <TableCell>{lead.client_name}</TableCell>
                      <TableCell>
                        <div className="flex flex-col gap-1">
                          <span className="text-sm">{lead.email}</span>
                          <span className="text-sm text-gray-500">{lead.phone}</span>
                        </div>
                      </TableCell>
                      <TableCell>{lead.lead_source}</TableCell>
                      <TableCell>
                        <Badge className={getPriorityColor(lead.priority)}>
                          {lead.priority}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        {format(new Date(lead.created_at), 'MMM d, yyyy h:mm a')}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
} 