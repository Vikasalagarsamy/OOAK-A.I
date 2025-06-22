'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { LoginCredentials } from '@/types/auth';

export default function LoginForm() {
  const [credentials, setCredentials] = useState<LoginCredentials>({
    employee_id: '',
    password: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      console.log('Attempting login with:', credentials.employee_id);
      
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(credentials),
        credentials: 'include',
      });

      const data = await response.json();
      console.log('Login response:', data);

      if (data.success) {
        console.log('Login successful, redirecting...');
        // Force a hard navigation to avoid client-side routing issues
        window.location.href = '/dashboard';
      } else {
        setError(data.message || 'Login failed');
      }
    } catch (error) {
      console.error('Login error:', error);
      setError('Network error. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setCredentials(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const fillTestCredentials = (employeeId: string) => {
    setCredentials({
      employee_id: employeeId,
      password: 'password123',
    });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo Section */}
        <div className="text-center mb-8">
          <div className="mx-auto w-20 h-20 bg-gradient-to-r from-purple-600 to-pink-600 rounded-full flex items-center justify-center mb-4 shadow-lg">
            <span className="text-white font-bold text-2xl">O</span>
          </div>
          <h1 className="text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent mb-2">
            OOAK.AI
          </h1>
          <p className="text-gray-600 text-lg">Employee Portal</p>
          <p className="text-gray-500 text-sm mt-2">India's First AI-Powered Wedding Photography Platform</p>
        </div>

        {/* Login Card */}
        <Card className="p-8 shadow-2xl border-0 bg-white/80 backdrop-blur-sm">
          <div className="text-center mb-6">
            <h2 className="text-2xl font-semibold text-gray-800">Welcome Back</h2>
            <p className="text-gray-600 mt-1">Sign in to your account</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="employee_id" className="text-sm font-medium text-gray-700">
                Employee ID
              </Label>
              <Input
                id="employee_id"
                name="employee_id"
                type="text"
                required
                value={credentials.employee_id}
                onChange={handleChange}
                placeholder="Enter your employee ID"
                className="h-12 text-base border-gray-300 focus:border-purple-500 focus:ring-purple-500"
                disabled={loading}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="password" className="text-sm font-medium text-gray-700">
                Password
              </Label>
              <Input
                id="password"
                name="password"
                type="password"
                required
                value={credentials.password}
                onChange={handleChange}
                placeholder="Enter your password"
                className="h-12 text-base border-gray-300 focus:border-purple-500 focus:ring-purple-500"
                disabled={loading}
              />
            </div>

            {error && (
              <Alert className="border-red-200 bg-red-50">
                <AlertDescription className="text-red-800">
                  {error}
                </AlertDescription>
              </Alert>
            )}

            <Button
              type="submit"
              disabled={loading}
              className="w-full h-12 text-base bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white font-semibold rounded-lg transition-all duration-200 shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <div className="flex items-center">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                  Signing in...
                </div>
              ) : (
                'Sign In'
              )}
            </Button>
          </form>

          {/* Test Credentials */}
          <div className="mt-8 pt-6 border-t border-gray-200">
            <div className="text-center mb-4">
              <p className="text-sm font-medium text-gray-700 mb-3">Quick Test Login:</p>
              <div className="grid grid-cols-1 gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => fillTestCredentials('EMP-25-0027')}
                  className="text-xs hover:bg-purple-50 hover:border-purple-300"
                  disabled={loading}
                >
                  Sales Head (Full Access)
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => fillTestCredentials('EMP-25-0039')}
                  className="text-xs hover:bg-blue-50 hover:border-blue-300"
                  disabled={loading}
                >
                  Sales Executive (Limited)
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => fillTestCredentials('EMP-25-0008')}
                  className="text-xs hover:bg-green-50 hover:border-green-300"
                  disabled={loading}
                >
                  Accounts Manager (Basic)
                </Button>
              </div>
            </div>
            <div className="text-xs text-gray-500 text-center space-y-1">
              <p><strong>Password for all:</strong> password123</p>
              <p>Click any button above to auto-fill credentials</p>
            </div>
          </div>
        </Card>

        {/* Footer */}
        <div className="text-center mt-6">
          <p className="text-xs text-gray-500">
            Powered by AI • Secured by Advanced Authentication
          </p>
        </div>
      </div>
    </div>
  );
} 