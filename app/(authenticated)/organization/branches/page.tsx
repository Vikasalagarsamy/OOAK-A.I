"use client";

import { useEffect, useState } from 'react';
import { BranchTable } from '@/components/organization/BranchTable';
import { Branch, BranchFormData } from '@/types/organization';

export default function BranchesPage() {
  const [branches, setBranches] = useState<Branch[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchBranches();
  }, []);

  const fetchBranches = async () => {
    try {
      const response = await fetch('/api/organization/branches');
      if (!response.ok) {
        throw new Error('Failed to fetch branches');
      }
      const data = await response.json();
      setBranches(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const handleAddBranch = async (data: BranchFormData) => {
    try {
      const response = await fetch('/api/organization/branches', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to add branch');
      }

      await fetchBranches();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to add branch');
    }
  };

  const handleEditBranch = async (id: number, data: BranchFormData) => {
    try {
      const response = await fetch(`/api/organization/branches/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to update branch');
      }

      await fetchBranches();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update branch');
    }
  };

  const handleDeleteBranch = async (id: number) => {
    try {
      const response = await fetch(`/api/organization/branches/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('Failed to delete branch');
      }

      await fetchBranches();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete branch');
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
      <BranchTable
        branches={branches}
        onAddBranch={handleAddBranch}
        onEditBranch={handleEditBranch}
        onDeleteBranch={handleDeleteBranch}
      />
    </div>
  );
} 