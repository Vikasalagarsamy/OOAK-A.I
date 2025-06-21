import React from 'react';
import { Users, Calendar, DollarSign, TrendingUp, Phone, Mail, Camera, Package } from 'lucide-react';

export default function Dashboard() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex h-16 justify-between items-center">
            <div className="flex items-center">
              <Camera className="h-8 w-8 text-blue-600" />
              <h1 className="ml-3 text-2xl font-bold text-gray-900">OOAK.AI</h1>
              <span className="ml-2 text-sm bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                AI-Powered
              </span>
            </div>
            <nav className="flex space-x-8">
              <a href="#dashboard" className="text-blue-600 font-medium">Dashboard</a>
              <a href="#leads" className="text-gray-500 hover:text-gray-900">Leads</a>
              <a href="#clients" className="text-gray-500 hover:text-gray-900">Clients</a>
              <a href="#bookings" className="text-gray-500 hover:text-gray-900">Bookings</a>
              <a href="#ai-insights" className="text-gray-500 hover:text-gray-900">AI Insights</a>
            </nav>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
        {/* Welcome Section */}
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900">Welcome to OOAK.AI</h2>
          <p className="mt-2 text-gray-600">
            India's first fully automated, AI-powered wedding photography platform
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="ooak-card p-6">
            <div className="flex items-center">
              <div className="p-3 bg-blue-100 rounded-lg">
                <Users className="h-6 w-6 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Leads</p>
                <p className="text-2xl font-bold text-gray-900">Loading...</p>
              </div>
            </div>
          </div>

          <div className="ooak-card p-6">
            <div className="flex items-center">
              <div className="p-3 bg-green-100 rounded-lg">
                <Calendar className="h-6 w-6 text-green-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Active Bookings</p>
                <p className="text-2xl font-bold text-gray-900">Loading...</p>
              </div>
            </div>
          </div>

          <div className="ooak-card p-6">
            <div className="flex items-center">
              <div className="p-3 bg-yellow-100 rounded-lg">
                <DollarSign className="h-6 w-6 text-yellow-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Revenue</p>
                <p className="text-2xl font-bold text-gray-900">Loading...</p>
              </div>
            </div>
          </div>

          <div className="ooak-card p-6">
            <div className="flex items-center">
              <div className="p-3 bg-purple-100 rounded-lg">
                <TrendingUp className="h-6 w-6 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">AI Efficiency</p>
                <p className="text-2xl font-bold text-gray-900">98.5%</p>
              </div>
            </div>
          </div>
        </div>

        {/* Action Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
          {/* Quick Actions */}
          <div className="ooak-card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
            <div className="space-y-3">
              <button className="w-full flex items-center p-3 text-left bg-blue-50 hover:bg-blue-100 rounded-lg transition-colors">
                <Phone className="h-5 w-5 text-blue-600 mr-3" />
                <span className="text-blue-700 font-medium">View Recent Calls</span>
              </button>
              <button className="w-full flex items-center p-3 text-left bg-green-50 hover:bg-green-100 rounded-lg transition-colors">
                <Mail className="h-5 w-5 text-green-600 mr-3" />
                <span className="text-green-700 font-medium">Check AI Communications</span>
              </button>
              <button className="w-full flex items-center p-3 text-left bg-purple-50 hover:bg-purple-100 rounded-lg transition-colors">
                <Package className="h-5 w-5 text-purple-600 mr-3" />
                <span className="text-purple-700 font-medium">Track Deliverables</span>
              </button>
            </div>
          </div>

          {/* AI Insights */}
          <div className="ooak-card p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">AI Insights</h3>
            <div className="space-y-4">
              <div className="p-4 bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg">
                <p className="text-sm text-gray-600">Lead Conversion Rate</p>
                <p className="text-2xl font-bold text-gray-900">73.2%</p>
                <p className="text-xs text-green-600">↑ 12% from last month</p>
              </div>
              <div className="p-4 bg-gradient-to-r from-green-50 to-blue-50 rounded-lg">
                <p className="text-sm text-gray-600">Avg. Response Time</p>
                <p className="text-2xl font-bold text-gray-900">2.3 min</p>
                <p className="text-xs text-green-600">↓ 45% faster than humans</p>
              </div>
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="ooak-card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
          <div className="space-y-4">
            <div className="flex items-center p-3 bg-gray-50 rounded-lg">
              <div className="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
              <span className="text-sm text-gray-600">
                AI processed new lead from Mumbai - Wedding in December 2024
              </span>
              <span className="ml-auto text-xs text-gray-400">2 minutes ago</span>
            </div>
            <div className="flex items-center p-3 bg-gray-50 rounded-lg">
              <div className="w-2 h-2 bg-blue-500 rounded-full mr-3"></div>
              <span className="text-sm text-gray-600">
                Quotation sent automatically to client Priya & Rahul
              </span>
              <span className="ml-auto text-xs text-gray-400">15 minutes ago</span>
            </div>
            <div className="flex items-center p-3 bg-gray-50 rounded-lg">
              <div className="w-2 h-2 bg-purple-500 rounded-full mr-3"></div>
              <span className="text-sm text-gray-600">
                Wedding deliverables uploaded to cloud storage
              </span>
              <span className="ml-auto text-xs text-gray-400">1 hour ago</span>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
          <div className="text-center text-gray-500">
            <p>© 2024 OOAK.AI - India's First Fully Automated Wedding Photography Platform</p>
            <p className="mt-2 text-sm">Powered by AI • Zero Human Intervention • Maximum Automation</p>
          </div>
        </div>
      </footer>
    </div>
  );
} 