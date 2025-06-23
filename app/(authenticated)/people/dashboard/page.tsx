'use client'

import { useState, useEffect } from 'react'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'

interface DashboardData {
  totalEmployees: number
  activeEmployees: number
  totalDepartments: number
  totalDesignations: number
  departmentDistribution: {
    department_name: string
    employee_count: number
  }[]
  designationStats: {
    designation_name: string
    department_name: string
    employee_count: number
  }[]
  recentHires: {
    id: number
    employee_id: string
    first_name: string
    last_name: string
    department_name: string
    designation_name: string
    hire_date: string
  }[]
}

export default function PeopleDashboard() {
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [timeRange, setTimeRange] = useState('30')

  useEffect(() => {
    fetchDashboardData()
  }, [timeRange])

  const fetchDashboardData = async () => {
    try {
      const response = await fetch(`/api/people/dashboard?days=${timeRange}`)
      const result = await response.json()
      if (result.success) {
        setData(result.data)
      } else {
        console.error('Failed to fetch dashboard data:', result.error)
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="p-8">
        <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-4">
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="p-6 bg-white rounded-lg shadow-sm">
              <Skeleton className="h-4 w-[150px] mb-4" />
              <Skeleton className="h-8 w-[100px]" />
            </div>
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-semibold">People Dashboard</h1>
        <Select value={timeRange} onValueChange={setTimeRange}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Last 30 days" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="7">Last 7 days</SelectItem>
            <SelectItem value="30">Last 30 days</SelectItem>
            <SelectItem value="90">Last 90 days</SelectItem>
            <SelectItem value="180">Last 6 months</SelectItem>
            <SelectItem value="365">Last 1 year</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Key Metrics */}
      <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-4 mb-8">
        <div className="p-6 bg-white rounded-lg shadow-sm">
          <h3 className="text-sm font-medium text-gray-500">Total Employees</h3>
          <div className="mt-2">
            <span className="text-3xl font-semibold">{data?.totalEmployees || 0}</span>
            <p className="text-sm text-gray-500 mt-1">
              {data?.activeEmployees || 0} active
            </p>
          </div>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm">
          <h3 className="text-sm font-medium text-gray-500">Departments</h3>
          <div className="mt-2">
            <span className="text-3xl font-semibold">{data?.totalDepartments || 0}</span>
          </div>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm">
          <h3 className="text-sm font-medium text-gray-500">Designations</h3>
          <div className="mt-2">
            <span className="text-3xl font-semibold">{data?.totalDesignations || 0}</span>
          </div>
        </div>
        <div className="p-6 bg-white rounded-lg shadow-sm">
          <h3 className="text-sm font-medium text-gray-500">New Hires</h3>
          <div className="mt-2">
            <span className="text-3xl font-semibold">{data?.recentHires?.length || 0}</span>
            <p className="text-sm text-gray-500 mt-1">
              in the last {timeRange} days
            </p>
          </div>
        </div>
      </div>

      {/* Department Distribution */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Department Distribution</h2>
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="space-y-4">
            {data?.departmentDistribution?.map((dept) => (
              <div key={dept.department_name} className="flex items-center">
                <div className="w-[200px] text-sm">{dept.department_name}</div>
                <div className="flex-1 relative h-2 bg-gray-100 rounded overflow-hidden">
                  <div 
                    className="absolute left-0 top-0 h-full bg-blue-500 rounded"
                    style={{ 
                      width: `${(dept.employee_count / (data?.totalEmployees || 1)) * 100}%` 
                    }}
                  />
                </div>
                <div className="w-[100px] text-right">
                  <span className="text-sm font-medium ml-4">{dept.employee_count}</span>
                  <span className="text-xs text-gray-500 ml-1">
                    ({((dept.employee_count / (data?.totalEmployees || 1)) * 100).toFixed(1)}%)
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Designation Distribution */}
      <div>
        <h2 className="text-lg font-semibold mb-4">Designation Distribution</h2>
        <div className="grid gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
          {data?.designationStats?.map((stat) => (
            <div
              key={`${stat.department_name}-${stat.designation_name}`}
              className="bg-white rounded-lg shadow-sm p-6 flex flex-col"
            >
              <div className="flex-1">
                <h4 className="font-medium text-gray-900">{stat.designation_name}</h4>
                <p className="text-sm text-gray-500 mt-1">{stat.department_name}</p>
              </div>
              <div className="mt-4 flex items-baseline">
                <span className="text-2xl font-semibold">{stat.employee_count}</span>
                <span className="ml-2 text-sm text-gray-500">employees</span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Recent Hires */}
      {data?.recentHires?.length ? (
        <div className="mt-8">
          <h2 className="text-lg font-semibold mb-4">Recent Hires</h2>
          <div className="bg-white rounded-lg shadow-sm divide-y">
            {data.recentHires.slice(0, 5).map((hire) => (
              <div key={hire.id} className="p-4 flex items-center justify-between">
                <div>
                  <div className="font-medium">
                    {hire.first_name} {hire.last_name}
                  </div>
                  <div className="text-sm text-gray-500">
                    {hire.designation_name} • {hire.department_name}
                  </div>
                </div>
                <div className="text-sm text-gray-500">
                  {new Date(hire.hire_date).toLocaleDateString()}
                </div>
              </div>
            ))}
          </div>
        </div>
      ) : null}
    </div>
  )
} 