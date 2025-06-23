import { Metadata } from 'next';
import CreateLeadForm from '@/components/leads/CreateLeadForm';

export const metadata: Metadata = {
  title: 'Create Lead - OOAK AI',
  description: 'Create a new lead in the OOAK AI system',
};

export default function CreateLeadPage() {
  return (
    <div className="container mx-auto py-6 px-4 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-2xl font-semibold text-gray-900">Create New Lead</h1>
        <p className="mt-2 text-sm text-gray-700">
          Enter the lead details below to create a new lead in the system.
        </p>
      </div>
      
      <div className="bg-white shadow rounded-lg">
        <CreateLeadForm />
      </div>
    </div>
  );
} 