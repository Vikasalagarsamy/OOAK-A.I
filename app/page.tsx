import { redirect } from 'next/navigation';
import { cookies } from 'next/headers';

export default function RootPage() {
  const cookieStore = cookies();
  const authToken = cookieStore.get('ooak_auth_token');

  if (authToken) {
    redirect('/dashboard');
  } else {
    redirect('/login');
  }

  // This will never be rendered
  return null;
} 