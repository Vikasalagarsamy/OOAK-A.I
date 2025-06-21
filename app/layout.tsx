import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import React from 'react'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'OOAK.AI - AI-Powered Wedding Photography Platform',
  description: 'India\'s first fully automated, AI-powered wedding photography platform. Zero human intervention, maximum automation.',
  keywords: ['wedding photography', 'AI', 'automation', 'India', 'wedding tech'],
  authors: [{ name: 'OOAK.AI Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <div className="min-h-screen bg-background">
          <main className="relative">
            {children}
          </main>
        </div>
      </body>
    </html>
  )
} 