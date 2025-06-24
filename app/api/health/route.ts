import { NextRequest, NextResponse } from 'next/server';
import { healthCheck } from '@/lib/db';

// Timeout promise wrapper
const withTimeout = <T>(promise: Promise<T>, timeoutMs: number): Promise<T> => {
  return Promise.race([
    promise,
    new Promise<T>((_, reject) => 
      setTimeout(() => reject(new Error(`Operation timed out after ${timeoutMs}ms`)), timeoutMs)
    )
  ]);
};

export const dynamic = 'force-dynamic';
export const maxDuration = 300;

export async function GET(request: NextRequest) {
  try {
    console.log('🔍 Health check requested...');
    
    const startTime = Date.now();
    
    // Add timeout to database health check
    const dbHealth = await withTimeout(healthCheck(), 5000);
    const totalLatency = Date.now() - startTime;
    
    const health = {
      status: dbHealth.healthy ? 'healthy' : 'unhealthy',
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'unknown',
      app: {
        name: process.env.NEXT_PUBLIC_APP_NAME || 'OOAK.AI',
        version: '1.0.0',
        url: process.env.NEXT_PUBLIC_APP_URL || 'unknown',
      },
      database: {
        healthy: dbHealth.healthy,
        latency: dbHealth.latency,
        error: dbHealth.error,
        connectionPool: {
          totalCount: 20,
          minCount: 5,
          idleTimeoutMs: 60000
        }
      },
      performance: {
        responseTime: totalLatency,
        memoryUsage: {
          heapUsed: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
          heapTotal: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
          external: Math.round(process.memoryUsage().external / 1024 / 1024),
        },
        uptime: Math.round(process.uptime())
      },
      features: {
        aiEfficiency: '98.5%',
        automationLevel: 'Maximum',
        humanIntervention: 'Zero'
      }
    };
    
    const statusCode = dbHealth.healthy ? 200 : 503;
    
    console.log(dbHealth.healthy ? '✅ Health check passed' : '❌ Health check failed');
    
    return NextResponse.json(health, { 
      status: statusCode,
      headers: {
        'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      }
    });
    
  } catch (error) {
    console.error('❌ Health check error:', error);
    
    return NextResponse.json({
      status: 'error',
      timestamp: new Date().toISOString(),
      error: error instanceof Error ? error.message : 'Unknown health check error',
      environment: process.env.NODE_ENV || 'unknown',
      type: error instanceof Error ? error.name : 'UnknownError'
    }, { 
      status: 500,
      headers: {
        'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      }
    });
  }
} 