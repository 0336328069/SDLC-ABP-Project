# ABP Enterprise Application

Một ứng dụng enterprise-grade được xây dựng trên ABP Framework với modern frontend stack.

## 🚀 Tech Stack

### Backend - ABP Framework
- **.NET 8** - Latest LTS version
- **ABP Framework** - Enterprise application framework
- **Domain Driven Design (DDD)** - Clean architecture
- **CQRS + MediatR** - Command Query Responsibility Segregation
- **Entity Framework Core** - ORM với Code First
- **Redis** - Caching và distributed cache
- **RabbitMQ** - Message broker cho domain events
- **PostgreSQL** - Primary database
- **AutoMapper** - Object mapping
- **FluentValidation** - Input validation
- **Serilog** - Structured logging
- **OpenAPI/Swagger** - API documentation

### Frontend - Next.js
- **Next.js 15** - React framework với App Router
- **React 19** - Latest version với concurrent features
- **TypeScript 5** - Full type coverage
- **TailwindCSS 3.4** - Utility-first CSS framework
- **Atomic Design** - Component architecture
- **React Query (TanStack Query)** - Server state management
- **Zustand** - Client state management
- **React Hook Form** - Form handling
- **Zod** - Schema validation
- **Framer Motion** - Animation library

### Development Tools
- **Docker & Docker Compose** - Containerization
- **ESLint + Prettier** - Code formatting
- **Husky** - Git hooks
- **Conventional Commits** - Commit standards
- **GitHub Actions** - CI/CD pipeline

## 🏗️ Architecture

```
src/
├── backend/
│   ├── src/
│   │   ├── AbpApp.Domain/           # Domain layer (Entities, Domain Services)
│   │   ├── AbpApp.Domain.Shared/    # Shared domain concepts
│   │   ├── AbpApp.Application/      # Application layer (App Services, DTOs)
│   │   ├── AbpApp.Application.Contracts/ # Application interfaces
│   │   ├── AbpApp.HttpApi/          # HTTP API layer (Controllers)
│   │   ├── AbpApp.HttpApi.Client/   # HTTP client
│   │   ├── AbpApp.HttpApi.Host/     # API hosting
│   │   └── AbpApp.EntityFrameworkCore/ # Data access layer
│   ├── test/
│   └── docker/
└── frontend/
    ├── apps/
    │   └── web/                     # Next.js application
    ├── packages/
    │   ├── ui/                      # Shared UI components
    │   ├── config/                  # Shared configurations
    │   └── types/                   # Shared TypeScript types
    └── docker/
```

## 🎯 Features

### ABP Framework Features
- ✅ **Multi-tenancy** - SaaS ready architecture
- ✅ **Authentication & Authorization** - JWT + Permission system
- ✅ **Audit Logging** - Automatic entity change tracking
- ✅ **Localization (i18n)** - Multi-language support
- ✅ **Background Jobs** - Hangfire integration
- ✅ **Event Bus** - Domain events với RabbitMQ
- ✅ **Caching** - Redis distributed cache
- ✅ **Settings Management** - Dynamic configuration
- ✅ **Feature Management** - Feature flags
- ✅ **Email & SMS** - Notification system

### Frontend Features
- ✅ **Server-Side Rendering (SSR)** - SEO optimization
- ✅ **Static Site Generation (SSG)** - Performance optimization
- ✅ **Progressive Web App (PWA)** - Mobile-first experience
- ✅ **Dark/Light Theme** - User preference
- ✅ **Responsive Design** - Mobile-first approach
- ✅ **Type-safe API Client** - Auto-generated từ OpenAPI
- ✅ **Real-time Updates** - SignalR integration
- ✅ **Offline Support** - Service Worker
- ✅ **Accessibility (a11y)** - WCAG 2.1 compliant

## 🚦 Quick Start

### Prerequisites
- **.NET 8 SDK**
- **Node.js 20+**
- **Docker & Docker Compose**
- **PostgreSQL 15+**
- **Redis 7+**

### Development Setup

1. **Clone repository**
```bash
git clone <repository-url>
cd abp-enterprise-app
```

2. **Backend setup**
```bash
cd src/backend
dotnet restore
dotnet ef database update
dotnet run --project src/AbpApp.HttpApi.Host
```

3. **Frontend setup**
```bash
cd src/frontend
npm install
npm run dev
```

4. **Docker setup (Recommended)**
```bash
docker-compose up -d
```

### Environment Variables

Copy `.env.example` to `.env` và cấu hình:

```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/abpapp"

# Redis
REDIS_URL="redis://localhost:6379"

# JWT
JWT_SECRET="your-super-secret-jwt-key"
JWT_ISSUER="AbpApp"

# Email
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USERNAME="your-email@gmail.com"
SMTP_PASSWORD="your-app-password"
```

## 📚 Documentation

- [Architecture Guide](docs/architecture.md)
- [Development Guide](docs/development.md)
- [API Documentation](docs/api.md)
- [Deployment Guide](docs/deployment.md)
- [Contributing Guide](docs/contributing.md)

## 🔧 Scripts

```bash
# Backend
npm run backend:dev          # Start backend development
npm run backend:build        # Build backend
npm run backend:test         # Run backend tests
npm run backend:migrate      # Run database migrations

# Frontend
npm run frontend:dev         # Start frontend development
npm run frontend:build       # Build frontend
npm run frontend:test        # Run frontend tests
npm run frontend:lint        # Lint frontend code

# Docker
npm run docker:up            # Start all services
npm run docker:down          # Stop all services
npm run docker:build         # Build all images
npm run docker:logs          # View logs

# Database
npm run db:seed              # Seed database with sample data
npm run db:reset             # Reset database
npm run db:backup            # Backup database
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Team

- **Architecture** - ABP Framework + Clean Architecture
- **Backend** - .NET 8 + Entity Framework Core
- **Frontend** - Next.js 15 + React 19
- **DevOps** - Docker + GitHub Actions