# TechStack Documentation - Authentication Domain v1.0

## Project Overview
**Domain:** Authentication  
**Version:** v1.0  
**Last Updated:** July 22, 2025  
**Project Type:** Enterprise Web Application with SDLC Automation

---

## Repository Information

### Main Repository
- **Repository URL:** https://github.com/0336328069/SDLC-ABP-Project
- **Repository Type:** MainRepo (Enterprise SDLC Project)
- **Repository Status:** ✅ **Active Repository** - Existing codebase with established development workflow

### Feature Repository/Branch
- **Feature Repository:** https://github.com/0336328069/SDLC-ABP-Project
- **Feature Branch:** `feature/authentication-v1.0`
- **Feature Path:** `src/AbpApp.Domain/Authentication/`, `src/AbpApp.Application/Authentication/`
- **Branch Status:** 🚧 **Feature Development** - Active feature branch for Authentication domain

### Branch Strategy (Current)
- **Main Branch:** `main` - Production-ready code
- **Development Branch:** `develop` - Integration branch for all features
- **Feature Branches:** `feature/{domain}-v{version}` (e.g., `feature/authentication-v1.0`)
- **Hotfix Branches:** `hotfix/{issue-number}` - Critical production fixes
- **Release Branches:** `release/v{major.minor}` - Release preparation

### Repository Configuration
- **Access Level:** Private repository (team access only)
- **Clone Strategy:** Automatic clone/pull before each workflow execution
- **Commit Strategy:** Automated commits for generated artifacts (docs, code, tests)
- **Branch Protection:** Main branch requires PR approval and passing CI/CD
- **Merge Strategy:** Squash and merge for feature branches

### Current Development Status
- **Active Branch for Authentication:** `feature/authentication-v1.0`
- **Last Commit:** TBD (will be updated during development)
- **Development Phase:** Feature Implementation
- **Integration Status:** Ready for SDLC automation workflows

### Repository Workflow Integration
- **CI/CD Pipeline:** GitHub Actions integrated
- **Automated Documentation:** Docs generated and committed automatically
- **Code Generation:** AI-generated code committed to feature branches
- **Quality Gates:** Automated testing and code quality checks before merge

---

## Backend Technology Stack

### Core Framework
- **.NET 9.0** - Primary backend framework
- **ABP Framework 8.3.0** - Application framework with DDD, Clean Architecture
- **C# 12** - Programming language

### Architecture Patterns
- **Domain-Driven Design (DDD)**
- **Clean Architecture**
- **Modular Monolith**
- **Repository Pattern**

### Database & ORM
- **SQL Server 2019+** (default, LocalDB for dev)
- **PostgreSQL 15+** (optional, configurable)
- **Entity Framework Core 9.0** - ORM
- **Database Migration:** Entity Framework Core Migrations
- **Redis 7.0** - Caching and session storage

### Authentication & Security
- **ABP Identity** - User management and authentication
- **JWT Bearer Tokens** - API authentication
- **IdentityServer4/Duende** - OAuth 2.0 / OpenID Connect
- **ABP Permission System** - Authorization
- **ASP.NET Core Identity** - Core identity management

### API & Communication
- **ASP.NET Core Web API** - REST API
- **Swagger/OpenAPI 3.0** - API documentation (Swashbuckle)
- **AutoMapper** - Object mapping

### Logging & Monitoring
- **Serilog** - Structured logging (file & console)

### Messaging
- **RabbitMQ** - Message broker

### Multi-tenancy & Background Jobs
- **ABP MultiTenancy**
- **ABP BackgroundJobs**

### Testing
- **dotnet test**
- **xUnit**
- **Moq**

---

## Backend Project Structure

- `AbpApp.Domain.Shared`: Shared constants, enums, localization
- `AbpApp.Domain`: Domain entities, business logic
- `AbpApp.Application.Contracts`: Service interfaces, DTOs
- `AbpApp.Application`: Application services, AutoMapper
- `AbpApp.EntityFrameworkCore`: Data access, migrations
- `AbpApp.HttpApi`: API controllers
- `AbpApp.HttpApi.Host`: API host, startup, middleware
- `tools/AbpApp.DbMigrator`: Migration & seeding tool

---

## Frontend Technology Stack

### Core Framework
- **Next.js 14+** - React framework with App Router
- **React 18.3+** - Frontend library
- **TypeScript 5.3+** - Programming language

### UI/UX Libraries
- **Tailwind CSS 3.4** - Utility-first CSS framework
- **Radix UI** - Component library
- **Lucide React** - Icons

### State Management & Data Fetching
- **Zustand** - Client state management
- **TanStack Query v5** - Server state management
- **Axios** - HTTP client

### Form Handling & Validation
- **React Hook Form**
- **Zod**
- **@hookform/resolvers**

### Authentication (Frontend)
- **NextAuth.js v4** - Authentication for Next.js

### Component Library & Testing
- **Storybook**
- **Jest**
- **React Testing Library**

### Linting/Formatting
- **ESLint**
- **Prettier**

### Bundler & Theming
- **Next.js built-in (Webpack/SWC)**
- **next-themes**

### Utilities
- **clsx**, **dayjs**, **framer-motion**

---

## Frontend Project Structure

- `app/`: Next.js App Router
- `components/`: Shared React components
- `lib/`: Utility functions, API clients
- `styles/`: Tailwind CSS, global styles

---

## DevOps & Infrastructure

### Containerization
- **Docker**
- **Docker Compose**

### Web Server/Proxy
- **Nginx** (qua Docker)

### CI/CD
- **GitHub Actions** (optional, can be integrated)
- **n8n** (workflow automation)

### Setup Automation
- **Bash script (`scripts/setup.sh`)**

### Pre-commit
- **Husky**, **lint-staged** (JS/TS, C#)

### Linting/Formatting
- **ESLint**, **Prettier**, **dotnet format**

### Monitoring
- **Serilog** (có thể tích hợp Seq)

---

## Development Tools & Environment

### Code Quality & Standards
- **ESLint**
- **Prettier**
- **EditorConfig**
- **Husky**
- **lint-staged**

### Package Management
- **NuGet** (.NET)
- **npm/yarn** (Node.js)

### IDE & Extensions
- **Visual Studio 2022** / **VS Code**
- **Cursor** (AI-assisted development)
- **ReSharper** (.NET productivity tool)

---

## Testing Framework

### Backend Testing
- **xUnit**
- **Moq**
- **dotnet test**

### Frontend Testing
- **Jest**
- **React Testing Library**

---

## Project Structure & Conventions

### Backend Project Structure
```
src/
├── AbpApp.Domain/              # Domain entities, domain services
│   └── Authentication/         # Authentication domain logic
├── AbpApp.Domain.Shared/       # Shared domain constants, enums
├── AbpApp.Application.Contracts/ # Application service interfaces, DTOs
│   └── Authentication/         # Authentication contracts and DTOs
├── AbpApp.Application/         # Application services implementation
│   └── Authentication/         # Authentication app services
├── AbpApp.EntityFrameworkCore/ # EF Core configuration, repositories
├── AbpApp.HttpApi/            # API controllers
│   └── Authentication/         # Authentication controllers
├── AbpApp.HttpApi.Host/       # API hosting configuration
└── AbpApp.DbMigrator/         # Database migration utility
```

### Frontend Project Structure
```
src/
├── app/                       # Next.js App Router pages
│   └── auth/                  # Authentication pages
├── components/                # Reusable UI components
│   └── auth/                  # Authentication components
├── lib/                       # Utility libraries
│   ├── api/                   # API clients and services
│   │   └── auth/              # Authentication API services
│   ├── auth/                  # Authentication configuration
│   ├── utils/                 # Helper utilities
│   └── validators/            # Zod schemas
│       └── auth/              # Authentication validation schemas
├── stores/                    # Zustand stores
│   └── auth-store.ts          # Authentication state management
├── types/                     # TypeScript type definitions
│   └── auth.ts                # Authentication type definitions
└── styles/                    # Global styles and Tailwind config
```

---

## Environment Configuration

### Required Environment Variables

#### Backend (.NET)
```bash
# Database
ConnectionStrings__Default=Server=(localdb)\MSSQLLocalDB;Database=AbpApp;Trusted_Connection=true;TrustServerCertificate=true
# or for PostgreSQL
# ConnectionStrings__Default=Host=localhost;Database=AbpApp;Username=postgres;Password=yourpassword

# Authentication
AuthServer__Authority=https://localhost:44300
AuthServer__RequireHttpsMetadata=false

# Redis
Redis__Configuration=localhost:6379

# Logging
Serilog__MinimumLevel=Information
```

#### Frontend (Next.js)
```bash
# API Configuration
NEXT_PUBLIC_API_URL=https://localhost:44300
NEXTAUTH_SECRET=your-nextauth-secret
NEXTAUTH_URL=http://localhost:3000
```

---

## Development Workflow

### Version Control Workflow
1. **Feature Development:** Create feature branch from `develop`
2. **Development Phase:** Implement features in feature branch
3. **Code Review:** Create Pull Request to `develop` branch
4. **Quality Assurance:** Automated testing and manual QA
5. **Integration:** Merge approved features to `develop`
6. **Release Preparation:** Create release branch from `develop`
7. **Production Deployment:** Merge release branch to `main`

### Code Review Process
1. Feature development in feature branch
2. Pull Request to develop branch
3. Code review required (minimum 1 reviewer)
4. Automated testing must pass
5. Merge to develop after approval

### Deployment Process
1. **Development:** Auto-deploy from develop branch
2. **Staging:** Manual deployment from develop
3. **Production:** Manual deployment from main branch

---

## Integration Points

### SDLC Automation (n8n)
- **BA Document Processing** - Automatic processing of PRD, SRS&DM, US, Vision files
- **Technical Feasibility Analysis** - Automated analysis of project requirements
- **Code Generation** - AI-assisted code generation based on technical specifications
- **Testing Automation** - Automated test generation and execution
- **Repository Management** - Automated clone, commit, and push operations

### AI Integration
- **Gemini CLI** - For code generation and documentation
- **Claude** - Alternative AI for complex analysis tasks
- **Cursor** - AI pair programming in development environment

---

## Performance & Scalability

### Backend Performance
- **Response Time Target:** < 200ms for API endpoints
- **Concurrent Users:** Support 1000+ concurrent users
- **Caching Strategy:** Redis for session data, memory caching for static data
- **Database Optimization:** Proper indexing, query optimization

### Frontend Performance
- **Core Web Vitals:** Target excellent scores
- **Bundle Size:** Code splitting and lazy loading
- **SEO Optimization:** Next.js SSR/SSG capabilities

---

## Security Considerations

### Backend Security
- **HTTPS/TLS 1.3** enforced in production
- **CORS** properly configured
- **Rate Limiting** implemented
- **Input Validation** at all layers
- **SQL Injection Protection** via Entity Framework
- **Authentication & Authorization** via ABP Identity

### Frontend Security
- **XSS Protection** via Content Security Policy
- **CSRF Protection** via NextAuth.js
- **Secure Cookie Configuration**
- **Environment Variable Security**

---

## Maintenance & Updates

### Regular Updates
- **Security patches** - Monthly or as needed
- **Framework updates** - Quarterly review
- **Dependencies** - Automated security updates via Dependabot

### Technical Debt Management
- **Code Quality Metrics** tracked via SonarQube
- **Performance Monitoring** continuous
- **Refactoring Sprints** scheduled quarterly

---

## Team Skills & Requirements

### Required Skills
- **Backend:** C#, .NET, Entity Framework, SQL, ABP Framework
- **Frontend:** TypeScript, React, Next.js, Tailwind CSS
- **DevOps:** Docker, CI/CD, n8n workflow automation
- **Version Control:** Git, GitHub, branch management
- **Testing:** Unit testing, integration testing, E2E testing

### Team Capacity
- **Senior Full-stack Developers:** 2
- **Backend Developers:** 1
- **Frontend Developers:** 1
- **DevOps Engineer:** 0.5 (shared resource)
- **QA Engineer:** 1

---

## Documentation Standards

### Repository Documentation
- **README.md** - Project setup and quick start guide
- **CONTRIBUTING.md** - Development guidelines and contribution process
- **CHANGELOG.md** - Version history and release notes
- **API Documentation** - Auto-generated via Swagger/OpenAPI

### Code Documentation
- **XML Documentation Comments** for all public APIs (.NET)
- **JSDoc Comments** for complex TypeScript functions
- **README.md** files for each major component/module

### API Documentation
- **Swagger/OpenAPI** auto-generated from code
- **Postman Collections** for manual testing
- **API versioning** strategy documented

---

*This techstack document should be updated whenever major technology decisions are made, repository changes occur, or new tools are introduced to the project. Repository information should be validated and updated with each major release or branch restructuring.*