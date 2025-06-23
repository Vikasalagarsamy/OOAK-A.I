'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Card, CardContent } from '@/components/ui/card';
import { Switch } from '@/components/ui/switch';
import { toast } from '@/components/ui/use-toast';
import { CountrySelect } from '@/components/ui/country-select';
import { cn } from '@/lib/utils';
import { Form, FormControl, FormField, FormItem, FormMessage, FormDescription } from '@/components/ui/form';
import { PhoneInput } from "@/components/ui/phone-input";
import { WhatsAppInput } from '../ui/whatsapp-input';
import { LeadFormValues, Company, Branch, LeadSource } from "@/types/database";

// Simple function to get max length based on country code
const getPhoneMaxLength = (countryCode: string): number => {
  const maxLengths: { [key: string]: number } = {
    '+91': 10,  // India
    '+1': 10,   // USA/Canada
    '+44': 10,  // UK
    '+61': 9,   // Australia
    '+65': 8,   // Singapore
    '+60': 10,  // Malaysia
    '+971': 9,  // UAE
    '+966': 9,  // Saudi Arabia
  };
  return maxLengths[countryCode] || 10;
};

// Form schema
const leadFormSchema = z.object({
  company_id: z.number().min(1, 'Company is required'),
  branch_id: z.number().min(1, 'Branch is required'),
  client_name: z.string().min(1, 'Client name is required'),
  bride_name: z.string().optional(),
  groom_name: z.string().optional(),
  email: z.string().email('Invalid email address').optional().or(z.literal('')),
  phone: z.string().min(1, 'Phone number is required'),
  whatsapp_number: z.string().optional(),
  country_code: z.string().min(1, 'Country code is required'),
  whatsapp_country_code: z.string().optional(),
  is_whatsapp: z.boolean().default(false),
  priority: z.enum(['low', 'medium', 'high']).default('medium'),
  lead_source: z.string().min(1, 'Lead source is required'),
  notes: z.string().optional(),
  wedding_date: z.string().optional().or(z.literal('')),
  venue_preference: z.string().optional().or(z.literal('')),
  guest_count: z.coerce.number().optional().or(z.literal(0)),
  budget_range: z.string().default('unspecified'),
  description: z.string().optional().or(z.literal('')),
  location: z.string().optional().or(z.literal('')),
  has_separate_whatsapp_number: z.boolean().default(false),
});

type FormData = z.infer<typeof leadFormSchema>;

export default function CreateLeadForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [leadSources, setLeadSources] = useState<LeadSource[]>([]);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [branches, setBranches] = useState<Branch[]>([]);
  const [filteredBranches, setFilteredBranches] = useState<Branch[]>([]);
  const [selectedCountryCode, setSelectedCountryCode] = useState('+91');
  const [selectedWhatsAppCountryCode, setSelectedWhatsAppCountryCode] = useState('+91');
  
  const form = useForm<FormData>({
    resolver: zodResolver(leadFormSchema),
    defaultValues: {
      company_id: 0,
      branch_id: 0,
      is_whatsapp: true,
      country_code: '+91',
      whatsapp_country_code: '+91',
      priority: 'medium',
      phone: "",
      whatsapp_number: "",
      client_name: "",
      email: "",
      notes: "",
      lead_source: "",
      budget_range: "unspecified",
      has_separate_whatsapp_number: false,
    },
    mode: 'onChange'
  });

  // Fetch companies and lead sources
  useEffect(() => {
    const fetchData = async () => {
      try {
        console.log('🔍 Fetching initial data...');
        const [companiesResponse, sourcesResponse, branchesResponse] = await Promise.all([
          fetch('/api/companies'),
          fetch('/api/leads/sources'),
          fetch('/api/branches')
        ]);
        
        const companiesData = await companiesResponse.json();
        const sourcesData = await sourcesResponse.json();
        const branchesData = await branchesResponse.json();
        
        if (companiesData.success) {
          console.log('✅ Companies loaded:', companiesData.companies?.length);
          setCompanies(companiesData.companies);
        }
        
        if (sourcesData.success) {
          console.log('✅ Lead sources loaded:', sourcesData.sources?.length);
          setLeadSources(sourcesData.sources);
        }

        if (branchesData.success) {
          console.log('✅ Branches loaded:', branchesData.branches?.length);
          setBranches(branchesData.branches);
        }
      } catch (error) {
        console.error('❌ Error fetching data:', error);
        toast({
          title: 'Error',
          description: 'Failed to load form data. Please try again.',
          variant: 'destructive',
        });
      }
    };

    fetchData();
  }, []);

  // Update filtered branches when company changes
  const selectedCompanyId = form.watch('company_id');
  useEffect(() => {
    const fetchBranches = async () => {
      try {
        console.log('🔍 Fetching branches for company:', selectedCompanyId);
        if (!selectedCompanyId) {
          setFilteredBranches([]);
          return;
        }

        const response = await fetch(`/api/branches?company_id=${selectedCompanyId}`);
        const data = await response.json();

        if (data.success) {
          console.log('✅ Branches loaded:', data.branches.length);
          setFilteredBranches(data.branches);
        } else {
          throw new Error(data.message || 'Failed to fetch branches');
        }
      } catch (error) {
        console.error('❌ Error fetching branches:', error);
        toast({
          title: 'Error',
          description: 'Failed to load branches. Please try again.',
          variant: 'destructive',
        });
      }
    };

    fetchBranches();
  }, [selectedCompanyId]);

  // Watch form values for WhatsApp logic
  const sameAsPhone = form.watch('has_separate_whatsapp_number');
  const phone = form.watch('phone');
  const countryCode = form.watch('country_code');

  // Update WhatsApp number when phone changes and numbers should be the same
  useEffect(() => {
    if (!sameAsPhone && phone) {
      form.setValue('whatsapp_number', phone);
      form.setValue('whatsapp_country_code', countryCode);
    }
  }, [sameAsPhone, phone, countryCode, form]);

  // Handle form submission with custom validation
  const onSubmit = async (data: z.infer<typeof leadFormSchema>) => {
    try {
      setIsLoading(true);
      console.log('📝 Submitting form data:', data);

      // Prepare the submission data
      const submissionData = {
        ...data,
        // When has_separate_whatsapp_number is false (toggle ON), use phone number for WhatsApp
        // When true (toggle OFF), use the separately entered WhatsApp number
        whatsapp_number: !data.has_separate_whatsapp_number ? data.phone : data.whatsapp_number,
        whatsapp_country_code: !data.has_separate_whatsapp_number ? data.country_code : data.whatsapp_country_code,
        // Keep the original phone number regardless of WhatsApp status
        phone: data.phone,
        country_code: data.country_code,
        // Set is_whatsapp to true since all numbers can receive WhatsApp
        is_whatsapp: true,
      };

      const response = await fetch('/api/leads', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(submissionData),
      });

      const result = await response.json();

      if (!result.success) {
        throw new Error(result.message || 'Failed to create lead');
      }

      console.log('✅ Lead created successfully:', result.lead);
      toast({
        title: 'Success',
        description: `Lead ${result.lead.lead_number} created successfully`,
      });

      // Reset form and redirect to unassigned leads
      form.reset();
      router.push('/sales/unassigned');
    } catch (error) {
      console.error('❌ Error creating lead:', error);
      toast({
        title: 'Error',
        description: error instanceof Error ? error.message : 'Failed to create lead',
        variant: 'destructive',
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8 p-6">
        {/* Company and Branch Selection */}
        <Card>
          <CardContent className="pt-6">
            <h2 className="text-xl font-semibold mb-4">Company & Branch</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="company_id"
                render={({ field }) => (
                  <FormItem className="space-y-2">
                    <Label>Company *</Label>
                    <Select
                      value={field.value ? field.value.toString() : ""}
                      onValueChange={(value) => {
                        field.onChange(value ? parseInt(value) : 0);
                        // Reset branch selection when company changes
                        form.setValue('branch_id', 0);
                      }}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select company" />
                      </SelectTrigger>
                      <SelectContent>
                        {companies.map((company) => (
                          <SelectItem key={company.id} value={company.id.toString()}>
                            {company.name} ({company.company_code})
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="branch_id"
                render={({ field }) => (
                  <FormItem className="space-y-2">
                    <Label>Branch *</Label>
                    <Select
                      value={field.value ? field.value.toString() : ""}
                      onValueChange={(value) => {
                        field.onChange(value ? parseInt(value) : 0);
                      }}
                      disabled={!selectedCompanyId}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder={selectedCompanyId ? "Select branch" : "Select company first"} />
                      </SelectTrigger>
                      <SelectContent>
                        {filteredBranches.map((branch) => (
                          <SelectItem key={branch.id} value={branch.id.toString()}>
                            {branch.name} ({branch.branch_code || 'No Code'})
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
          </CardContent>
        </Card>

        {/* Basic Information */}
        <Card>
          <CardContent className="pt-6">
            <h2 className="text-xl font-semibold mb-4">Basic Information</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="client_name">Client Name *</Label>
                <Input
                  id="client_name"
                  {...form.register('client_name')}
                  placeholder="Enter client name"
                />
                {form.formState.errors.client_name && (
                  <p className="text-sm text-red-500">{form.formState.errors.client_name.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="bride_name">Bride Name</Label>
                <Input
                  id="bride_name"
                  {...form.register('bride_name')}
                  placeholder="Enter bride name"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="groom_name">Groom Name</Label>
                <Input
                  id="groom_name"
                  {...form.register('groom_name')}
                  placeholder="Enter groom name"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  {...form.register('email')}
                  placeholder="Enter email address"
                />
              </div>

              <div className="space-y-2">
                <Label>Mobile Number</Label>
                <div className="flex gap-2">
                  <CountrySelect 
                    value={selectedCountryCode}
                    onChange={(code) => {
                      setSelectedCountryCode(code);
                      form.setValue('phone', '');
                    }}
                  />
                  <FormField
                    control={form.control}
                    name="phone"
                    render={({ field }) => (
                      <FormItem className="flex-1">
                        <FormControl>
                          <PhoneInput
                            value={field.value || ''}
                            onChange={field.onChange}
                            maxLength={getPhoneMaxLength(selectedCountryCode)}
                            placeholder={`Enter ${getPhoneMaxLength(selectedCountryCode)} digits`}
                            aria-label="Phone number"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>

              <div className="flex flex-col space-y-2">
                <div className="flex items-center space-x-2">
                  <FormField
                    control={form.control}
                    name="has_separate_whatsapp_number"
                    render={({ field }) => (
                      <FormItem>
                        <FormControl>
                          <div className="flex items-center space-x-2">
                            <Switch
                              id="same-as-phone"
                              checked={!field.value}
                              onCheckedChange={(checked) => {
                                field.onChange(!checked);
                                if (checked) {
                                  // When toggle is ON (same as phone)
                                  form.setValue('whatsapp_number', form.getValues('phone'));
                                  form.setValue('whatsapp_country_code', form.getValues('country_code'));
                                }
                              }}
                            />
                            <Label htmlFor="same-as-phone">WhatsApp number same as mobile number</Label>
                          </div>
                        </FormControl>
                      </FormItem>
                    )}
                  />
                </div>

                {form.watch('has_separate_whatsapp_number') && (
                  <div className="flex gap-2">
                    <CountrySelect 
                      value={selectedWhatsAppCountryCode}
                      onChange={(code) => {
                        setSelectedWhatsAppCountryCode(code);
                        form.setValue('whatsapp_country_code', code);
                        form.setValue('whatsapp_number', '');
                      }}
                    />
                    <FormField
                      control={form.control}
                      name="whatsapp_number"
                      render={({ field }) => (
                        <FormItem className="flex-1">
                          <FormControl>
                            <WhatsAppInput
                              value={field.value || ''}
                              onChange={field.onChange}
                              maxLength={getPhoneMaxLength(selectedWhatsAppCountryCode)}
                              placeholder={`Enter ${getPhoneMaxLength(selectedWhatsAppCountryCode)} digits`}
                              aria-label="WhatsApp number"
                            />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Event Details */}
        <Card>
          <CardContent className="pt-6">
            <h2 className="text-xl font-semibold mb-4">Event Details (Optional)</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="wedding_date" className="flex items-center gap-2">
                  Wedding Date
                  <span className="text-sm text-gray-500">(Optional)</span>
                </Label>
                <Input
                  id="wedding_date"
                  type="date"
                  {...form.register('wedding_date')}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="venue_preference" className="flex items-center gap-2">
                  Venue Preference
                  <span className="text-sm text-gray-500">(Optional)</span>
                </Label>
                <Input
                  id="venue_preference"
                  {...form.register('venue_preference')}
                  placeholder="Enter venue preference if known"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="guest_count" className="flex items-center gap-2">
                  Guest Count
                  <span className="text-sm text-gray-500">(Optional)</span>
                </Label>
                <Input
                  id="guest_count"
                  type="number"
                  {...form.register('guest_count', { 
                    setValueAs: (v) => v === "" ? undefined : parseInt(v, 10)
                  })}
                  placeholder="Approximate number of guests"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="budget_range" className="flex items-center gap-2">
                  Budget Range
                  <span className="text-sm text-gray-500">(Optional)</span>
                </Label>
                <Select 
                  onValueChange={(value) => form.setValue('budget_range', value)}
                  defaultValue="unspecified"
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select budget range if known" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="unspecified">Not specified</SelectItem>
                    <SelectItem value="0-100000">Below 1L</SelectItem>
                    <SelectItem value="100000-200000">1L - 2L</SelectItem>
                    <SelectItem value="200000-500000">2L - 5L</SelectItem>
                    <SelectItem value="500000-1000000">5L - 10L</SelectItem>
                    <SelectItem value="1000000+">Above 10L</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="col-span-2 space-y-2">
                <Label htmlFor="description" className="flex items-center gap-2">
                  Description
                  <span className="text-sm text-gray-500">(Optional)</span>
                </Label>
                <Textarea
                  id="description"
                  {...form.register('description')}
                  placeholder="Enter any additional details about the event if available"
                  rows={4}
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Lead Information */}
        <Card>
          <CardContent className="pt-6">
            <h2 className="text-xl font-semibold mb-4">Lead Information</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <FormField
                  control={form.control}
                  name="lead_source"
                  render={({ field }) => (
                    <FormItem className="space-y-2">
                      <Label>Lead Source *</Label>
                      <Select
                        value={field.value || ""}
                        onValueChange={field.onChange}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Select lead source" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="Instagram">Instagram</SelectItem>
                          <SelectItem value="Facebook">Facebook</SelectItem>
                          <SelectItem value="Website">Website</SelectItem>
                          <SelectItem value="WhatsApp">WhatsApp</SelectItem>
                          <SelectItem value="Referral">Referral</SelectItem>
                          <SelectItem value="Other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="location">Location</Label>
                <Input
                  id="location"
                  {...form.register('location')}
                  placeholder="Enter location"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="priority">Priority</Label>
                <Select
                  onValueChange={(value) => form.setValue('priority', value as 'low' | 'medium' | 'high')}
                  defaultValue="medium"
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select priority" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="low">Low</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="high">High</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="col-span-2 space-y-2">
                <Label htmlFor="notes">Notes</Label>
                <Textarea
                  id="notes"
                  {...form.register('notes')}
                  placeholder="Enter any additional notes"
                  rows={4}
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Form Actions */}
        <div className="flex justify-end space-x-4">
          <Button
            type="button"
            variant="outline"
            onClick={() => router.back()}
            disabled={isLoading}
          >
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={isLoading || !form.formState.isValid}
            className={cn(
              "min-w-[120px]",
              isLoading && "opacity-50 cursor-not-allowed"
            )}
          >
            {isLoading ? (
              <div className="flex items-center">
                <span className="mr-2">Creating...</span>
                {/* Add a loading spinner here if needed */}
              </div>
            ) : (
              "Create Lead"
            )}
          </Button>
        </div>
      </form>
    </Form>
  );
} 