import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Sidebar } from '@/components/ui/sidebar'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'OOAK AI - Wedding Tech Platform',
  description: 'India\'s first AI-powered wedding photography platform',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <div className="flex min-h-screen bg-background">
          {/* Fixed sidebar */}
          <aside className="fixed left-0 top-0 z-30 h-screen w-64 border-r bg-background">
            <Sidebar />
          </aside>
          
          {/* Main content area with padding for sidebar */}
          <main className="flex-1 ml-64">
            {/* Header area */}
            <header className="sticky top-0 z-20 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
              <div className="flex h-14 items-center px-6">
                <h1 className="text-xl font-semibold">OOAK AI</h1>
              </div>
            </header>

            {/* Scrollable content area */}
            <div className="relative">
              <div className="p-6">
                {children}
              </div>
            </div>
          </main>
        </div>
      </body>
    </html>
  )
} 