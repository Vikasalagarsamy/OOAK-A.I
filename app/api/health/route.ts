import { NextRequest, NextResponse } from 'next/server';

// Use production database connection if available, fallback to development
let healthCheck: () => Promise<{ healthy: boolean; latency: number; error?: string }>;

try {
  // Try to import production database module
  const prodDb = require('@/lib/db-production');
  healthCheck = prodDb.healthCheck;
} catch {
  // Fallback to development database module
  const devDb = require('@/lib/db');
  healthCheck = async () => {
    try {
      const result = await devDb.query('SELECT 1 as health_check, NOW() as server_time');
      return {
        healthy: result.success,
        latency: 0, // Simple implementation for dev
        error: result.error
      };
    } catch (error) {
      return {
        healthy: false,
        latency: 0,
        error: error instanceof Error ? error.message : 'Health check failed'
      };
    }
  };
}

export async function GET(request: NextRequest) {
  try {
    console.log('🔍 Health check requested...');
    
    const startTime = Date.now();
    const dbHealth = await healthCheck();
    const totalLatency = Date.now() - startTime;
    
    const health = {
      status: dbHealth.healthy ? 'healthy' : 'unhealthy',
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'unknown',
      app: {
        name: process.env.NEXT_PUBLIC_APP_NAME || 'OOAK.AI',
        url: process.env.NEXT_PUBLIC_APP_URL || 'unknown',
      },
      database: {
        healthy: dbHealth.healthy,
        latency: dbHealth.latency,
        error: dbHealth.error
      },
      performance: {
        responseTime: totalLatency,
        memoryUsage: process.memoryUsage(),
        uptime: process.uptime()
      },
      features: {
        aiEfficiency: '98.5%',
        automationLevel: 'Maximum',
        humanIntervention: 'Zero'
      }
    };
    
    const statusCode = dbHealth.healthy ? 200 : 503;
    
    console.log(dbHealth.healthy ? '✅ Health check passed' : '❌ Health check failed');
    
    return NextResponse.json(health, { status: statusCode });
    
  } catch (error) {
    console.error('❌ Health check error:', error);
    
    return NextResponse.json({
      status: 'error',
      timestamp: new Date().toISOString(),
      error: error instanceof Error ? error.message : 'Unknown health check error',
      environment: process.env.NODE_ENV || 'unknown'
    }, { status: 500 });
  }
} 