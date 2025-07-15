/** @type {import('next').NextConfig} */
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
})

const nextConfig = {
  // Note: serverExternalPackages is for Next.js 15+, commenting out for v14
  
  // Experimental features
  experimental: {
    // optimizeCss: true, // Disabled due to critters dependency issue
  },

  // Performance optimizations
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },

  // Images configuration
  images: {
    domains: ['localhost', 'images.unsplash.com', 'via.placeholder.com'],
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  },

  // Security headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
          {
            key: 'Permissions-Policy',
            value: 'camera=(), microphone=(), geolocation=()',
          },
        ],
      },
    ]
  },

  // Redirects
  async redirects() {
    return [
      {
        source: '/admin',
        destination: '/admin/dashboard',
        permanent: true,
      },
    ]
  },

  // Rewrites for API proxy
  async rewrites() {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000';
    return [
      {
        source: '/api/:path*',
        destination: `${apiUrl}/api/:path*`,
      },
    ]
  },

  // Environment variables
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },

  // Output configuration
  output: 'standalone',

  // ESLint configuration
  eslint: {
    dirs: ['pages', 'components', 'lib', 'src'],
    ignoreDuringBuilds: false,
  },

  // TypeScript configuration
  typescript: {
    ignoreBuildErrors: false,
  },

  // Webpack configuration
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Bundle analyzer
    if (process.env.ANALYZE === 'true') {
      config.plugins.push(
        new webpack.BundleAnalyzerPlugin({
          analyzerMode: 'server',
          analyzerPort: isServer ? 8888 : 8889,
          openAnalyzer: true,
        })
      )
    }

    // Custom webpack rules
    config.module.rules.push({
      test: /\.svg$/,
      use: ['@svgr/webpack'],
    })

    return config
  },

  // Note: i18n is not supported in App Router
  // Use next-intl for internationalization instead

  // Trailing slash
  trailingSlash: false,

  // Powered by header
  poweredByHeader: false,

  // React strict mode
  reactStrictMode: true,

  // Note: swcMinify is deprecated, SWC is now default
}

module.exports = withBundleAnalyzer(nextConfig)