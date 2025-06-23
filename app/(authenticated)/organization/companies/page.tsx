"use client";

import { useEffect, useState } from 'react';
import { CompanyTable } from '@/components/organization/CompanyTable';
import { Company, CompanyFormData } from '@/types/organization';

export default function CompaniesPage() {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchCompanies();
  }, []);

  const fetchCompanies = async () => {
    try {
      const response = await fetch('/api/organization/companies');
      if (!response.ok) {
        throw new Error('Failed to fetch companies');
      }
      const data = await response.json();
      if (!data.success) {
        throw new Error(data.error || 'Failed to fetch companies');
      }
      setCompanies(data.companies || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const handleAddCompany = async (data: CompanyFormData) => {
    try {
      const response = await fetch('/api/organization/companies', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to add company');
      }

      await fetchCompanies();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to add company');
    }
  };

  const handleEditCompany = async (id: number, data: CompanyFormData) => {
    try {
      const response = await fetch(`/api/organization/companies/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to update company');
      }

      await fetchCompanies();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update company');
    }
  };

  const handleDeleteCompany = async (id: number) => {
    try {
      const response = await fetch(`/api/organization/companies/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('Failed to delete company');
      }

      await fetchCompanies();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete company');
    }
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <div className="p-6">
      <CompanyTable
        companies={companies}
        onAddCompany={handleAddCompany}
        onEditCompany={handleEditCompany}
        onDeleteCompany={handleDeleteCompany}
      />
    </div>
  );
} 