# Implementation Plan: AuthI have successfully created the implementation plan for the Authentication feature and saved it to `docs/DEV/ImplementPlan_Authentication.md`.
entication system for an enterprise web application. It will enable user identification, personalize user experiences, enhance platform security, and ensure data protection. The core functionalities include user registration, secure login, account recovery (password reset via email), and secure session management (logout).
- **Technical Architecture Overview**: The system will adhere to a Modular Monolith architecture, leveraging Domain-Driven Design (DDD) and Clean Architecture principles. The backend is built with .NET 9.0 and ABP Framework 8.3.0, exposing RESTful APIs. The frontend uses Next.js 14+ and React 18.3+. Data persistence is handled by SQL Server 2019+ (or PostgreSQL 15+) with EF Core 9.0, and Redis 7.0 for caching.
- **Key Technologies and Tools**:
    - **Backend**: .NET 9.0, ABP Framework 8.3.0, C# 12, SQL Server 2019+/PostgreSQL 15+, Entity Framework Core 9.0, Redis 7.0, ABP Identity, JWT Bearer Tokens, IdentityServer4/Duende, ABP Permission System, ASP.NET Core Web API, Swagger/OpenAPI 3.0, Serilog, RabbitMQ.
    - **Frontend**: Next.js 14+, React 18.3+, TypeScript 5.3+, NextAuth.js v4, Tailwind CSS 3.4, Radix UI, Lucide React, Zustand, TanStack Query v5, Axios, React Hook Form, Zod.
    - **DevOps**: Docker, Docker Compose, Nginx, GitHub Actions, n8n, Husky, lint-staged, ESLint, Prettier, dotnet format.
- **Implementation Timeline and Phases**: The implementation strategy is phased over approximately 8 weeks:
    - **Phase 1 (Weeks 1-2)**: Foundation & Technical Deep Dive.
    - **Phase 2 (Weeks 3-5)**: Core Authentication Implementation (Register, Login, Logout).
    - **Phase 3 (Weeks 6-8)**: Password Reset & NFRs Validation.

## 2. Development Phases
- **Phase 1: Domain Layer**
    - Define `AppUser` (extending `AbpUser`) in `src/AbpApp.Domain/Users/AppUser.cs`.
    - Define `PasswordResetToken` entity in `src/AbpApp.Domain/Authentication/PasswordResetToken.cs`.
    - Define `IPasswordResetTokenRepository` interface in `src/AbpApp.Domain/Authentication/IPasswordResetTokenRepository.cs`.
    - Define `AuthenticationDomainService` interface and implementation in `src/AbpApp.Domain/Authentication/AuthenticationDomainService.cs`.
    - Define domain events like `UserRegisteredEventData` in `src/AbpApp.Domain.Shared/Authentication/UserRegisteredEventData.cs`.
- **Phase 2: Application Layer**
    - Define DTOs (`RegisterDto`, `PasswordResetRequestDto`, `AppUserDto`, etc.) in `src/AbpApp.Application.Contracts/Authentication/Dtos/`.
    - Define `IAuthenticationAppService` interface in `src/AbpApp.Application.Contracts/Authentication/IAuthenticationAppService.cs`.
    - Implement `AuthenticationAppService` in `src/AbpApp.Application/Authentication/AuthenticationAppService.cs`.
    - Configure AutoMapper profile in `src/AbpApp.Application/Authentication/AuthenticationApplicationAutoMapperProfile.cs`.
- **Phase 3: Infrastructure Layer**
    - Implement `PasswordResetTokenRepository` in `src/AbpApp.EntityFrameworkCore/Authentication/EfCorePasswordResetTokenRepository.cs`.
    - Add `DbSet<PasswordResetToken>` to `AbpAppDbContext.cs` in `src/AbpApp.EntityFrameworkCore/AbpAppDbContext.cs`.
    - Generate and apply EF Core Migrations for `PasswordResetToken` entity.
    - Configure Redis for caching and session storage.
- **Phase 4: Presentation Layer**
    - Develop frontend pages for registration, login, and password reset in `src/frontend/app/auth/`.
    - Create reusable authentication components in `src/frontend/components/auth/`.
    - Integrate NextAuth.js for client-side authentication.
    - Implement API integration using Axios and TanStack Query.
    - Implement form handling with React Hook Form and Zod.
- **Phase 5: Testing & Deployment**
    - Write unit tests for backend domain services and application services using xUnit and Moq.
    - Write unit tests for frontend components and utility functions using Jest and React Testing Library.
    - Implement integration tests for API endpoints.
    - Configure CI/CD pipelines using GitHub Actions for automated build, test, and deployment.
    - Conduct performance testing to validate NFRs.

## 3. Backend Implementation

### Domain Layer
- **Entity classes**:
    - `AppUser`: Extends `Volo.Abp.Identity.IdentityUser`.
        - File Path: `src/backend/src/AbpApp.Domain/Users/AppUser.cs`
        - Code:
        ```csharp
        // src/AbpApp.Domain/Users/AppUser.cs
        using Volo.Abp.Identity;

        namespace AbpApp.Users;

        public class AppUser : IdentityUser
        {
            private AppUser()
            {
                // Private constructor for ORM
            }
        }
        ```
    - `PasswordResetToken`:
        - File Path: `src/backend/src/AbpApp.Domain/Authentication/PasswordResetToken.cs`
        - Code:
        ```csharp
        // src/AbpApp.Domain/Authentication/PasswordResetToken.cs
        using System;
        using Volo.Abp.Domain.Entities.Auditing;

        namespace AbpApp.Authentication;

        public class PasswordResetToken : FullAuditedAggregateRoot<Guid>
        {
            public Guid UserId { get; private set; }
            public string ResetTokenHash { get; private set; }
            public DateTime ExpirationTimeUtc { get; private set; }
            public bool IsUsed { get; private set; }

            private PasswordResetToken() { /* For ORM */ }

            public PasswordResetToken(Guid id, Guid userId, string resetTokenHash, DateTime expirationTimeUtc) : base(id)
            {
                UserId = userId;
                ResetTokenHash = resetTokenHash;
                ExpirationTimeUtc = expirationTimeUtc;
                IsUsed = false;
            }

            public void MarkAsUsed()
            {
                IsUsed = true;
            }
        }
        ```
- **Value objects**: TBD: While concepts like `EmailAddress` or `Password` could be modeled as Value Objects, the provided documents do not mandate this. This can be considered a future refactoring.
- **Domain services**:
    - `IAuthenticationDomainService`: Interface for `AuthenticationDomainService`.
        - File Path: `src/backend/src/AbpApp.Domain/Authentication/IAuthenticationDomainService.cs`
        - Code: TBD: Interface definition.
    - `AuthenticationDomainService`:
        - File Path: `src/backend/src/AbpApp.Domain/Authentication/AuthenticationDomainService.cs`
        - Code:
        ```csharp
        // src/AbpApp.Domain/Authentication/AuthenticationDomainService.cs
        using System.Threading.Tasks;
        using AbpApp.Users;
        using Volo.Abp.Domain.Services;

        namespace AbpApp.Authentication;

        public class AuthenticationDomainService : DomainService, IAuthenticationDomainService
        {
            // ... repository injections

            public async Task<PasswordResetToken> GeneratePasswordResetTokenAsync(AppUser user)
            {
                // 1. Generate a secure, random token string.
                // 2. Hash the token string using a secure hasher (e.g., from ASP.NET Core Identity).
                // 3. Create a new PasswordResetToken entity with 60-minute expiry.
                // 4. Save the entity via its repository.
                // 5. Return the entity (with the raw token for sending via email).
                // TBD: Implementation details of token generation and hashing.
                return null;
            }
        }
        ```
- **Repository interfaces**:
    - `IPasswordResetTokenRepository`:
        - File Path: `src/backend/src/AbpApp.Domain/Authentication/IPasswordResetTokenRepository.cs`
        - Code:
        ```csharp
        // src/AbpApp.Domain/Authentication/IPasswordResetTokenRepository.cs
        using System;
        using System.Threading.Tasks;
        using Volo.Abp.Domain.Repositories;

        namespace AbpApp.Authentication;

        public interface IPasswordResetTokenRepository : IRepository<PasswordResetToken, Guid>
        {
            Task<PasswordResetToken> FindByTokenHashAsync(string tokenHash);
        }
        ```

### Application Layer
- **Application services**:
    - `IAuthenticationAppService`:
        - File Path: `src/backend/src/AbpApp.Application.Contracts/Authentication/IAuthenticationAppService.cs`
        - Code: TBD: Interface definition.
    - `AuthenticationAppService`:
        - File Path: `src/backend/src/AbpApp.Application/Authentication/AuthenticationAppService.cs`
        - Code:
        ```csharp
        // src/AbpApp.Application/Authentication/AuthenticationAppService.cs
        using System.Threading.Tasks;
        using AbpApp.Authentication.Dtos;
        using Volo.Abp.Application.Services;

        namespace AbpApp.Authentication;

        public class AuthenticationAppService : ApplicationService, IAuthenticationAppService
        {
            // ... constructor with dependencies

            public async Task<AppUserDto> RegisterAsync(RegisterDto input)
            {
                // 1. Validate input DTO (handled by framework).
                // 2. Call IdentityUserManager to create a new user (FR-REG-08).
                //    - This handles password hashing (NFR-SEC-01) and uniqueness checks (FR-REG-04).
                // 3. Sign in the user (FR-REG-09).
                // 4. Map the new user entity to AppUserDto and return.
                return null;
            }

            public async Task RequestPasswordResetAsync(PasswordResetRequestDto input)
            {
                // 1. Find user by email. If not found, return without error (FR-RP-04).
                // 2. Use AuthenticationDomainService to generate a reset token (FR-RP-05, FR-RP-06).
                // 3. Publish a PasswordResetRequestedEvent (FR-RP-07).
            }
        }
        ```
- **DTOs**:
    - `RegisterDto`:
        - File Path: `src/backend/src/AbpApp.Application.Contracts/Authentication/Dtos/RegisterDto.cs`
        - Code:
        ```csharp
        // src/AbpApp.Application.Contracts/Authentication/Dtos/RegisterDto.cs
        using System.ComponentModel.DataAnnotations;

        namespace AbpApp.Authentication.Dtos;

        public class RegisterDto
        {
            [Required]
            [EmailAddress]
            public string Email { get; set; }

            [Required]
            [StringLength(100, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters long.")]
            // FR-REG-05: Regex for complexity
            [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$", ErrorMessage = "Password must contain at least one uppercase letter, one lowercase letter, and one number.")]
            public string Password { get; set; }

            [Required]
            [Compare(nameof(Password), ErrorMessage = "Passwords do not match.")]
            public string ConfirmPassword { get; set; }
        }
        ```
    - `PasswordResetRequestDto`: TBD: Define properties for email.
    - `AppUserDto`: TBD: Define properties for user data.
- **AutoMapper profiles**:
    - `AuthenticationApplicationAutoMapperProfile`:
        - File Path: `src/backend/src/AbpApp.Application/Authentication/AuthenticationApplicationAutoMapperProfile.cs`
        - Code:
        ```csharp
        // src/AbpApp.Application/Authentication/AuthenticationApplicationAutoMapperProfile.cs
        using AutoMapper;
        using AbpApp.Authentication.Dtos;
        using AbpApp.Users;

        namespace AbpApp.Authentication;

        public class AuthenticationApplicationAutoMapperProfile : Profile
        {
            public AuthenticationApplicationAutoMapperProfile()
            {
                CreateMap<AppUser, AppUserDto>();
                // Add other mappings here...
            }
        }
        ```

### Infrastructure Layer
- **Repository implementations**:
    - `EfCorePasswordResetTokenRepository`: Implement `IPasswordResetTokenRepository`.
        - File Path: `src/backend/src/AbpApp.EntityFrameworkCore/Authentication/EfCorePasswordResetTokenRepository.cs`
        - Code: TBD: Implementation details.
- **EF Core configurations**:
    - Add `DbSet<PasswordResetToken>` to `AbpAppDbContext.cs`.
        - File Path: `src/backend/src/AbpApp.EntityFrameworkCore/AbpAppDbContext.cs`
        - Code: TBD: Add `public DbSet<PasswordResetToken> PasswordResetTokens { get; set; }`
    - Configure `PasswordResetToken` entity mapping in `AbpAppDbContextModelCreatingExtensions.cs` (TBD: if a separate file is used for entity configurations).
- **Database setup**:
    - Generate initial migration for `PasswordResetTokens` table: `dotnet ef migrations add AddPasswordResetTokenEntity -p src/backend/src/AbpApp.EntityFrameworkCore -s tools/AbpApp.DbMigrator`
    - Apply migrations: `dotnet ef database update -p src/backend/src/AbpApp.EntityFrameworkCore -s tools/AbpApp.DbMigrator`
    - Configure connection strings in `appsettings.json` and `appsettings.Development.json` for SQL Server/PostgreSQL.
    - Configure Redis connection in `appsettings.json`.

### API Layer
- **Controllers with endpoints**:
    - `AuthenticationController`:
        - File Path: `src/backend/src/AbpApp.HttpApi/Controllers/AuthenticationController.cs`
        - HTTP Methods, Routes, Authorization:
            - `POST /api/app/authentication/register`: `RegisterDto` input, returns `AppUserDto`.
            - `POST /api/app/authentication/login`: `LoginDto` input, returns JWT token.
            - `POST /api/app/authentication/request-password-reset`: `PasswordResetRequestDto` input.
            - `POST /api/app/authentication/reset-password`: `ResetPasswordDto` input.
            - `POST /api/app/authentication/logout`: No input, invalidates session.
        - Code: TBD: Controller implementation.

## 4. Frontend Implementation

### Components
- **React/Next.js components**:
    - `RegisterForm.tsx`: Handles user registration.
        - File Path: `src/frontend/components/auth/RegisterForm.tsx`
        - Props: `onSubmit` callback.
        - State: Form fields (email, password, confirm password), loading, error.
    - `LoginForm.tsx`: Handles user login.
        - File Path: `src/frontend/components/auth/LoginForm.tsx`
        - Props: `onSubmit` callback.
        - State: Form fields (email, password), loading, error.
    - `ForgotPasswordForm.tsx`: Handles password reset request.
        - File Path: `src/frontend/components/auth/ForgotPasswordForm.tsx`
        - Props: `onSubmit` callback.
        - State: Form field (email), loading, success message, error.
    - `ResetPasswordForm.tsx`: Handles new password submission after reset token validation.
        - File Path: `src/frontend/components/auth/ResetPasswordForm.tsx`
        - Props: `onSubmit` callback, `token` (from URL).
        - State: Form fields (new password, confirm new password), loading, success message, error.
    - `AuthLayout.tsx`: Layout component for authentication pages.
        - File Path: `src/frontend/app/auth/layout.tsx`
        - Props: `children`.
- **Pages**:
    - `register/page.tsx`: Uses `RegisterForm`.
        - File Path: `src/frontend/app/auth/register/page.tsx`
    - `login/page.tsx`: Uses `LoginForm`.
        - File Path: `src/frontend/app/auth/login/page.tsx`
    - `forgot-password/page.tsx`: Uses `ForgotPasswordForm`.
        - File Path: `src/frontend/app/auth/forgot-password/page.tsx`
    - `reset-password/page.tsx`: Uses `ResetPasswordForm`, extracts token from URL.
        - File Path: `src/frontend/app/auth/reset-password/page.tsx`

### API Integration
- **HTTP client setup**:
    - Use Axios for API calls.
    - Create an Axios instance with base URL and interceptors for error handling.
    - File Path: `src/frontend/lib/api/axios.ts` (TBD: if not already existing)
- **Error handling**:
    - Implement global error handling for API responses (e.g., using Axios interceptors).
    - Display user-friendly error messages using `toast-provider.tsx`.
- **Loading states**:
    - Manage loading states for API calls using TanStack Query's `isLoading` or local component state.

### State Management
- **Global state**:
    - Use Zustand for global authentication state (e.g., `isAuthenticated`, `user`, `token`).
    - File Path: `src/frontend/stores/auth-store.ts`
- **Local state**:
    - Manage form input and component-specific UI states using React's `useState`.
- **Data flow**:
    - Frontend components dispatch actions to update Zustand store or trigger API calls via TanStack Query.
    - TanStack Query manages server-side data fetching, caching, and revalidation.

### UI/UX
- **Styling**:
    - Use Tailwind CSS for utility-first styling.
    - Use Radix UI for accessible, unstyled components (e.g., Button, Input, Form).
    - Use Lucide React for icons.
- **Responsive design**:
    - Apply Tailwind's responsive utility classes for different screen sizes.
- **Accessibility**:
    - Leverage Radix UI's built-in accessibility features.
    - Ensure proper ARIA attributes and semantic HTML.

## 5. Database & Security

### Migration Strategy
- **Database schema changes**:
    - Use EF Core Migrations to manage schema changes for `PasswordResetToken` entity.
    - Command: `dotnet ef migrations add AddPasswordResetTokenEntity -p src/backend/src/AbpApp.EntityFrameworkCore -s tools/AbpApp.DbMigrator`
- **Seed data**: TBD: If any initial user accounts or roles need to be seeded, implement in `AbpAppDbMigratorModule.cs` or a separate seed class.

### Authentication
- **JWT implementation**:
    - Backend: ABP Framework handles JWT token generation and validation using `IdentityServer4/Duende` and `ASP.NET Core Identity`.
    - Frontend: NextAuth.js handles JWT token storage (HTTP-only cookies) and attachment to API requests.
- **User management**:
    - Backend: ABP Identity module provides user registration, login, and account management functionalities.
    - Frontend: Forms for registration, login, and password reset interact with backend APIs.

### Authorization
- **Role-based access**:
    - Backend: ABP Permission System for defining and enforcing permissions based on roles.
    - Frontend: Conditionally render UI elements or routes based on user roles/permissions obtained from the backend.

### Data Protection
- **Encryption**:
    - Passwords: Hashed using Bcrypt with a cost factor of 12 (NFR-SEC-01) by ASP.NET Core Identity.
    - Password Reset Tokens: Hashed before storage in `PasswordResetToken.ResetTokenHash`.
    - Data in transit: HTTPS (TLS 1.2+) enforced (NFR-SEC-02).
- **Validation**:
    - Input validation at frontend (Zod, React Hook Form) and backend (Data Annotations, ABP's validation system).
- **Audit logging**:
    - ABP Framework's built-in auditing features will automatically log changes to entities.
    - Serilog configured for structured logging of application events and errors.

## 6. Testing & Deployment

### Unit Testing
- **Test framework**:
    - Backend: xUnit, Moq.
    - Frontend: Jest, React Testing Library.
- **Coverage requirements**: Aim for high unit test coverage (TBD: specific percentage target, e.g., 80%).
- **Test examples**:
    - **Backend**:
        - `AuthenticationAppServiceTests.cs`: Test `RegisterAsync`, `RequestPasswordResetAsync` methods.
        - `AuthenticationDomainServiceTests.cs`: Test `GeneratePasswordResetTokenAsync` method.
        - `PasswordResetTokenTests.cs`: Test `MarkAsUsed` method.
    - **Frontend**:
        - `RegisterForm.test.tsx`: Test form submission, validation, error display.
        - `LoginForm.test.tsx`: Test login success/failure scenarios.
        - `auth-store.test.ts`: Test Zustand store state updates.

### Integration Testing
- **API testing**:
    - Use `Microsoft.AspNetCore.Mvc.Testing` for in-memory integration tests of backend API endpoints.
    - Test registration, login, password reset, and logout flows end-to-end.
- **Database testing**:
    - Integration tests to verify data persistence and retrieval through EF Core.

### Performance
- **Optimization strategies**:
    - Database indexing on frequently queried columns (`NormalizedEmail`, `NormalizedUserName`, `UserId`, `ResetTokenHash`).
    - Caching with Redis for session data and frequently accessed user profiles.
    - Efficient LINQ queries, avoiding N+1 problems.
    - Frontend: Code splitting, lazy loading, image optimization, Next.js SSR/SSG.
- **Monitoring**:
    - Serilog for logging performance metrics.
    - TBD: Integrate with a monitoring tool (e.g., Prometheus, Grafana) for real-time performance tracking.

### Deployment
- **Environment setup**:
    - Docker and Docker Compose for local development.
    - TBD: Specific cloud provider for production deployment (e.g., Azure).
- **CI/CD pipeline**:
    - GitHub Actions for automated build, test, and deployment.
    - Workflow for `develop` branch (auto-deploy to Development environment).
    - Workflow for `main` branch (manual deployment to Production environment).
- **Monitoring**:
    - Serilog for application logging.
    - TBD: Implement health checks for services.

## Quality Assurance Checklist:
- [ ] All sections have concrete implementation details
- [ ] File paths and class names are specified
- [ ] Method signatures include parameters and return types
- [ ] Technology stack matches TechStack.md
- [ ] Security requirements are addressed
- [ ] Testing strategy is comprehensive
- [ ] Deployment process is clear