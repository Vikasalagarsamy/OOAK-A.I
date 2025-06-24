/** @type {import('next').NextConfig} */
const nextConfig = {
  env: {
    CUSTOM_KEY: 'OOAK-AI-Platform',
  },
  poweredByHeader: false,
  compress: true,
  generateEtags: true,
  async rewrites() {
    return [
      {
        source: '/dashboard',
        destination: '/authenticated/dashboard'
      },
      {
        source: '/admin/menu-permissions',
        destination: '/authenticated/admin/menu-permissions'
      },
      {
        source: '/admin/:path*',
        destination: '/authenticated/admin/:path*'
      }
    ];
  },
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET, POST, PUT, DELETE, OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
          { key: 'X-DNS-Prefetch-Control', value: 'on' },
          { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
          { key: 'X-XSS-Protection', value: '1; mode=block' },
          { key: 'X-Frame-Options', value: 'SAMEORIGIN' },
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'Referrer-Policy', value: 'origin-when-cross-origin' },
        ],
      },
    ];
  },
  output: 'standalone',
  experimental: {
    serverActions: {
      allowedOrigins: ['workspace.ooak.photography'],
    },
  },
  logging: {
    level: 'info',
  },
}

module.exports = nextConfig; 