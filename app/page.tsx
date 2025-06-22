import { query } from '@/lib/db';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Building2, Users, Phone, MessageSquare, TrendingUp, Calendar } from 'lucide-react';

async function getDashboardData() {
  try {
    // Get real business metrics from your local database
    const [
      companiesResult,
      branchesResult,
      employeesResult,
      leadsResult,
      quotationsResult,
      whatsappResult,
      callsResult,
      eventsResult
    ] = await Promise.all([
      query('SELECT COUNT(*) as count FROM companies'),
      query('SELECT COUNT(*) as count FROM branches'),
      query('SELECT COUNT(*) as count FROM employees'),
      query('SELECT COUNT(*) as count FROM leads WHERE leads.id IS NOT NULL'),
      query('SELECT COUNT(*) as count FROM quotations'),
      query('SELECT COUNT(*) as count FROM whatsapp_messages'),
      query('SELECT COUNT(*) as count FROM call_transcriptions'),
      query('SELECT COUNT(*) as count FROM events')
    ]);

    // Get recent activities
    const recentActivities = await query(`
      SELECT * FROM activities 
      ORDER BY created_at DESC 
      LIMIT 5
    `);

    // Get branch distribution
    const branchData = await query(`
      SELECT b.name, COUNT(e.id) as employee_count
      FROM branches b
      LEFT JOIN employee_companies ec ON b.id = ec.branch_id
      LEFT JOIN employees e ON ec.employee_id = e.id
      GROUP BY b.id, b.name
      ORDER BY employee_count DESC
    `);

    return {
      companies: parseInt(companiesResult.rows[0].count),
      branches: parseInt(branchesResult.rows[0].count),
      employees: parseInt(employeesResult.rows[0].count),
      leads: parseInt(leadsResult.rows[0].count),
      quotations: parseInt(quotationsResult.rows[0].count),
      whatsappMessages: parseInt(whatsappResult.rows[0].count),
      callTranscriptions: parseInt(callsResult.rows[0].count),
      events: parseInt(eventsResult.rows[0].count),
      recentActivities: recentActivities.rows,
      branchData: branchData.rows
    };
  } catch (error) {
    console.error('Dashboard data error:', error);
    return {
      companies: 0,
      branches: 0,
      employees: 0,
      leads: 0,
      quotations: 0,
      whatsappMessages: 0,
      callTranscriptions: 0,
      events: 0,
      recentActivities: [],
      branchData: []
    };
  }
}

export default async function Dashboard() {
  const data = await getDashboardData();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            OOAK.AI Development Dashboard
          </h1>
          <p className="text-lg text-gray-600">
            India's First Fully Automated AI-Powered Wedding Photography Platform
          </p>
          <Badge variant="secondary" className="mt-2">
            🚀 Development Environment - Real Business Data
          </Badge>
        </div>

        {/* Real Business Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card className="border-l-4 border-l-blue-500">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Companies</CardTitle>
              <Building2 className="h-4 w-4 text-blue-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.companies}</div>
              <p className="text-xs text-muted-foreground">
                OOAK AI, ONE OF A KIND, WEDDINGS BY OOAK, YOUR PERFECT STORY
              </p>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-green-500">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Active Branches</CardTitle>
              <Building2 className="h-4 w-4 text-green-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.branches}</div>
              <p className="text-xs text-muted-foreground">
                Chennai, Coimbatore, Bangalore, Hyderabad, Dubai
              </p>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-purple-500">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Team Members</CardTitle>
              <Users className="h-4 w-4 text-purple-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.employees}</div>
              <p className="text-xs text-muted-foreground">
                Across all departments and branches
              </p>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-orange-500">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Active Leads</CardTitle>
              <TrendingUp className="h-4 w-4 text-orange-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.leads}</div>
              <p className="text-xs text-muted-foreground">
                Real leads for testing
              </p>
            </CardContent>
          </Card>
        </div>

        {/* AI & Communication Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Quotations</CardTitle>
              <Calendar className="h-4 w-4 text-indigo-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.quotations}</div>
              <p className="text-xs text-muted-foreground">
                Real quotation data
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">WhatsApp Messages</CardTitle>
              <MessageSquare className="h-4 w-4 text-green-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.whatsappMessages}</div>
              <p className="text-xs text-muted-foreground">
                Client communications
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Call Transcriptions</CardTitle>
              <Phone className="h-4 w-4 text-red-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.callTranscriptions}</div>
              <p className="text-xs text-muted-foreground">
                AI training data
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Business Events</CardTitle>
              <Calendar className="h-4 w-4 text-blue-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{data.events}</div>
              <p className="text-xs text-muted-foreground">
                Activity tracking
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Branch Distribution */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <Card>
            <CardHeader>
              <CardTitle>Branch Distribution</CardTitle>
              <CardDescription>Employee count by branch</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {data.branchData.map((branch: any, index: number) => (
                  <div key={index} className="flex items-center justify-between">
                    <span className="text-sm font-medium">{branch.name}</span>
                    <Badge variant="outline">{branch.employee_count} employees</Badge>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Development Status</CardTitle>
              <CardDescription>Current development progress</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-sm">Database Setup</span>
                  <Badge className="bg-green-500">✅ Complete</Badge>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm">Data Population</span>
                  <Badge className="bg-green-500">✅ Complete</Badge>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm">Development Environment</span>
                  <Badge className="bg-green-500">✅ Ready</Badge>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm">Feature Development</span>
                  <Badge className="bg-blue-500">🔄 In Progress</Badge>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Recent Activities */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Business Activities</CardTitle>
            <CardDescription>Latest activities from your business data</CardDescription>
          </CardHeader>
          <CardContent>
            {data.recentActivities.length > 0 ? (
              <div className="space-y-3">
                {data.recentActivities.map((activity: any, index: number) => (
                  <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                    <div>
                      <p className="text-sm font-medium">{activity.title || 'Business Activity'}</p>
                      <p className="text-xs text-gray-500">
                        {activity.description || 'Activity description'}
                      </p>
                    </div>
                    <Badge variant="secondary">
                      {new Date(activity.created_at).toLocaleDateString()}
                    </Badge>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-gray-500">No recent activities found</p>
            )}
          </CardContent>
        </Card>

        {/* Development Instructions */}
        <Card className="mt-8 border-2 border-dashed border-blue-300 bg-blue-50">
          <CardHeader>
            <CardTitle className="text-blue-800">🚀 Ready for Feature Development</CardTitle>
            <CardDescription className="text-blue-600">
              Your OOAK.AI platform is now ready with real business data
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <h4 className="font-semibold text-blue-800 mb-2">Next Steps:</h4>
                <ul className="text-sm text-blue-700 space-y-1">
                  <li>• Build lead management with real leads</li>
                  <li>• Create client communication hub</li>
                  <li>• Implement AI automation features</li>
                  <li>• Add employee management system</li>
                </ul>
              </div>
              <div>
                <h4 className="font-semibold text-blue-800 mb-2">Development Commands:</h4>
                <ul className="text-sm text-blue-700 space-y-1">
                  <li>• <code>npm run dev</code> - Development server</li>
                  <li>• <code>npm run db:populate</code> - Sync data</li>
                  <li>• <code>npm run db:backup</code> - Backup changes</li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
} 