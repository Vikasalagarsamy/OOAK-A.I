/** @type {import('next').NextConfig} */
const nextConfig = {
  env: {
    CUSTOM_KEY: 'OOAK-AI-Platform',
  },
  async rewrites() {
    return {
      beforeFiles: [
        {
          source: '/dashboard',
          destination: '/(authenticated)/dashboard',
        },
        {
          source: '/admin/:path*',
          destination: '/(authenticated)/admin/:path*',
        }
      ]
    };
  },
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET, POST, PUT, DELETE, OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
        ],
      },
    ];
  },
  output: 'standalone',
}

module.exports = nextConfig; 