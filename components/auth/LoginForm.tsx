'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { signIn } from 'next-auth/react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription } from '@/components/ui/alert';

export default function LoginForm() {
  const [credentials, setCredentials] = useState({
    username: '',
    password: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();
  const searchParams = useSearchParams();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const callbackUrl = searchParams.get('callbackUrl') || '/dashboard';
      console.log('Login attempt:', {
        username: credentials.username,
        callbackUrl,
        timestamp: new Date().toISOString()
      });
      
      const result = await signIn('credentials', {
        username: credentials.username.trim().toUpperCase(),
        password: credentials.password,
        redirect: false,
        callbackUrl,
      });

      console.log('Login result:', {
        ok: result?.ok,
        error: result?.error,
        url: result?.url,
        status: result?.status,
        timestamp: new Date().toISOString()
      });

      if (!result) {
        console.error('No result from signIn');
        setError('An unexpected error occurred');
        return;
      }

      if (result.error) {
        console.error('Login error:', result.error);
        setError('Invalid employee ID or password');
        return;
      }

      if (result.url) {
        console.log('Login successful, redirecting to:', result.url);
        // Use window.location for a full page reload
        window.location.href = result.url;
      } else {
        console.error('No URL in successful login result');
        setError('An unexpected error occurred');
      }
    } catch (error) {
      console.error('Login error:', error);
      setError('An error occurred during login');
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

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo Section */}
        <div className="text-center mb-8">
          <div className="mx-auto w-20 h-20 bg-gradient-to-r from-purple-600 to-pink-600 rounded-full flex items-center justify-center mb-4 shadow-lg">
            <span className="text-white font-bold text-2xl">O</span>
          </div>
          <h1 className="text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent mb-2">
            OOAK
          </h1>
          <p className="text-gray-600 text-lg">Employee Portal</p>
          <p className="text-gray-500 text-sm mt-2">India's Premier Wedding Photography Platform</p>
        </div>

        {/* Login Card */}
        <Card className="p-8 shadow-2xl border-0 bg-white/80 backdrop-blur-sm">
          <div className="text-center mb-6">
            <h2 className="text-2xl font-semibold text-gray-800">Welcome Back</h2>
            <p className="text-gray-600 mt-1">Sign in to your account</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="username" className="text-sm font-medium text-gray-700">
                Employee ID
              </Label>
              <Input
                id="username"
                name="username"
                type="text"
                required
                value={credentials.username}
                onChange={handleChange}
                placeholder="Enter your employee ID (e.g., EMP-25-0001)"
                className="h-12 text-base border-gray-300 focus:border-purple-500 focus:ring-purple-500"
                disabled={loading}
                autoCapitalize="characters"
                pattern="^EMP-\d{2}-\d{4}$"
                title="Please enter a valid employee ID (e.g., EMP-25-0001)"
                aria-label="Employee ID"
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
                aria-label="Password"
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
              aria-label={loading ? "Signing in..." : "Sign In"}
            >
              {loading ? (
                <div className="flex items-center justify-center">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                  Signing in...
                </div>
              ) : (
                'Sign In'
              )}
            </Button>
          </form>

          {/* Help Section */}
          <div className="mt-8 pt-6 border-t border-gray-200">
            <div className="text-center">
              <p className="text-xs text-gray-500">
                Need help? Contact your system administrator
              </p>
            </div>
          </div>
        </Card>

        {/* Footer */}
        <div className="text-center mt-6">
          <p className="text-xs text-gray-500">
            Secured by Advanced Authentication
          </p>
        </div>
      </div>
    </div>
  );
} 