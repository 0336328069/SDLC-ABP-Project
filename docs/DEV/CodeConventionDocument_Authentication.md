# Code Convention and Standards Document - Authentication Feature

## 1. Executive Summary

This document outlines the code conventions and standards for the Authentication feature within the enterprise web application. The project leverages a robust technology stack including .NET 9.0 with ABP Framework 8.3.0 for the backend and Next.js 14+ with React 18+ for the frontend. The architectural approach is based on Domain-Driven Design (DDD) and Clean Architecture, implemented as a modular monolith. The team comprises a mix of senior, middle, and junior developers, with strong expertise in the Microsoft .NET ecosystem and modern web development practices. The adoption strategy emphasizes adherence to these standards to ensure code quality, maintainability, and efficient collaboration.

## 2. Source Code Standards by Platform

### 2.1 Backend Development Conventions

**Programming Language Standards:**
- **Language:** C# 12.
- **Naming Conventions:**
  - Classes, interfaces, enums, public methods, and properties: PascalCase.
  - Local variables, method parameters: camelCase.
  - Private fields: camelCase with an underscore prefix (e.g., `_myField`).
- **Code Formatting:** Adhere to `.editorconfig` settings. Use `dotnet format` for automated formatting.
- **Asynchronous Programming:** Utilize `async/await` for all I/O-bound operations to ensure responsiveness and scalability.

**Architectural Patterns:**
- **Domain-Driven Design (DDD):** Focus on modeling the Authentication domain accurately. Entities and Value Objects should reside in `AbpApp.Domain`.
- **Clean Architecture:** Strict separation of concerns between layers (Domain, Application, Infrastructure, Presentation).
- **Modular Monolith:** Authentication logic should be encapsulated within its own modules/folders within the ABP Framework structure.
- **Repository Pattern:** Data access operations should be abstracted through repositories defined in the Domain layer and implemented in the EntityFrameworkCore layer.

**API Development and Data Access Conventions:**
- **RESTful API:** Design APIs to be RESTful, using standard HTTP methods (GET, POST, PUT, DELETE) and status codes.
- **API Versioning:** Implement API versioning (TBD: specific versioning strategy, e.g., URL, header, or media type).
- **DTOs:** Use Data Transfer Objects (DTOs) for all data exchanged between API controllers and application services, defined in `AbpApp.Application.Contracts/Authentication/`.
- **AutoMapper:** Use AutoMapper for mapping between entities and DTOs, configured in `AbpApp.Application/Authentication/`.
- **Entity Framework Core 9.0:** Use EF Core for database interactions. Leverage migrations for schema changes.
- **Database Migrations:** Generate migrations using `dotnet ef migrations add [MigrationName]` and apply with `dotnet ef database update`.

**Error Handling and Logging Standards:**
- **Exception Handling:** Use structured exception handling. Catch specific exceptions and rethrow custom exceptions where appropriate. Avoid catching generic `Exception`.
- **Logging:** Use Serilog for structured logging. Log important events, errors, and warnings. Ensure sensitive information is not logged.
  - **Minimum Level:** Information (configurable via `appsettings.json`).
- **API Error Responses:** Return consistent, informative error responses from API endpoints, typically using problem details (RFC 7807) or custom error DTOs.

### 2.2 Frontend Development Conventions

**Language/Framework Standards:**
- **Language:** TypeScript 5.3+.
- **Framework:** Next.js 14+ with App Router, React 18.3+.
- **Naming Conventions:**
  - Components: PascalCase (e.g., `AuthForm.tsx`).
  - Hooks: `use` prefix (e.g., `useAuth`).
  - Variables, functions: camelCase.
- **Code Formatting:** Adhere to Prettier and ESLint rules. Use `npm run lint` and `npm run format`.

**Component Architecture:**
- **Functional Components:** Prefer functional components with React Hooks.
- **Reusability:** Design components for reusability. Place shared components in `components/` and authentication-specific components in `components/auth/`.
- **State Management:**
  - **Client State:** Use Zustand for global client-side state management (e.g., `stores/auth-store.ts`).
  - **Server State:** Use TanStack Query v5 (`useQuery`, `useMutation`) for managing server-side data fetching, caching, and synchronization.
- **Data Fetching:** Use Axios for HTTP requests to the backend API.
- **Form Handling:** Use React Hook Form with Zod for form validation and submission.

**Styling Methodologies and Performance Patterns:**
- **Styling:** Tailwind CSS 3.4 for utility-first styling. Radix UI for unstyled, accessible components.
- **Performance:** Implement code splitting and lazy loading for large components/pages. Optimize image assets. Leverage Next.js SSR/SSG capabilities for SEO and initial load performance.

### 2.3 Mobile Development Conventions (if applicable)

- **TBD: Mobile development is not explicitly part of the current tech stack for this feature. If mobile applications are introduced, specific conventions for platforms like iOS (Swift/SwiftUI) or Android (Kotlin/Jetpack Compose) will be defined.**

### 2.4 Database Development Conventions

**Schema Design and Query Development Standards:**
- **Database:** SQL Server 2019+ (default), PostgreSQL 15+ (optional).
- **ORM:** Entity Framework Core 9.0.
- **Naming Conventions:**
  - Tables: PascalCase, plural (e.g., `Users`, `Roles`).
  - Columns: PascalCase (e.g., `UserName`, `EmailAddress`).
  - Primary Keys: `Id` (e.g., `UserId`).
  - Foreign Keys: `[RelatedEntity]Id` (e.g., `RoleId`).
- **Migrations:** All schema changes must be applied via EF Core Migrations. Manual database changes are strictly prohibited.

**Data Access Patterns and ORM Configuration:**
- **Repository Pattern:** All database interactions should go through the defined repositories within the ABP Framework.
- **Query Optimization:** Write efficient LINQ queries. Avoid N+1 problems. Use `Include` and `ThenInclude` for eager loading where necessary. Consider raw SQL for complex, performance-critical queries only when absolutely necessary and with proper justification.
- **Transaction Management:** Use EF Core's built-in transaction management for atomic operations.

## 3. Code Organization and Architecture Standards

**Project Structure and Layer Organization:**
- **Backend:** Follow the ABP Framework's modular structure.
  - `src/AbpApp.Domain.Shared`: Shared constants, enums, localization resources.
  - `src/AbpApp.Domain`: Core domain entities, aggregates, domain services, interfaces for repositories. Authentication-specific entities in `src/AbpApp.Domain/Authentication/`.
  - `src/AbpApp.Application.Contracts`: Application service interfaces, DTOs, permission definitions. Authentication-specific contracts and DTOs in `src/AbpApp.Application.Contracts/Authentication/`.
  - `src/AbpApp.Application`: Implementation of application services, AutoMapper profiles. Authentication application services in `src/AbpApp.Application/Authentication/`.
  - `src/AbpApp.EntityFrameworkCore`: EF Core `DbContext`, entity configurations, repository implementations.
  - `src/AbpApp.HttpApi`: API controllers. Authentication controllers in `src/AbpApp.HttpApi/Authentication/`.
  - `src/AbpApp.HttpApi.Host`: API host configuration, startup, middleware.
  - `tools/AbpApp.DbMigrator`: Database migration and seeding utility.
- **Frontend:** Follow Next.js App Router conventions.
  - `app/`: Next.js App Router pages. Authentication-related pages in `app/auth/`.
  - `components/`: Reusable UI components. Authentication-specific components in `components/auth/`.
  - `lib/`: Utility functions, API clients, authentication configuration, validators. Authentication API services in `lib/api/auth/`, authentication configuration in `lib/auth/`, authentication validation schemas in `lib/validators/auth/`.
  - `stores/`: Zustand stores. Authentication state management in `stores/auth-store.ts`.
  - `types/`: TypeScript type definitions. Authentication type definitions in `types/auth.ts`.
  - `styles/`: Global styles and Tailwind CSS configuration.

**File and Directory Naming Conventions:**
- **Backend:** Follow standard C# and ABP conventions (e.g., `[ModuleName]AppService.cs`, `I[ModuleName]AppService.cs`, `[EntityName]Dto.cs`).
- **Frontend:** Follow Next.js/React conventions (e.g., `page.tsx`, `layout.tsx`, `[ComponentName].tsx`, `use[HookName].ts`).

**Module/Component Organization:**
- Group related files within feature-specific directories (e.g., `Authentication` folders in backend layers, `auth` folders in frontend).
- Each module/component should have a clear responsibility and minimal dependencies on other modules.

**Shared Libraries and Common Code Structure:**
- **Backend:** Shared domain logic and constants in `AbpApp.Domain.Shared`.
- **Frontend:** Common utility functions in `lib/utils.ts`. Reusable UI components in `components/ui/`.

**Cross-platform Integration Patterns:**
- **API-driven:** Frontend and backend communicate exclusively via RESTful APIs.
- **Authentication:** JWT Bearer tokens for API authentication, managed by ABP Identity on the backend and NextAuth.js on the frontend.

**Authentication and Error Handling Across Components:**
- **Authentication:** Centralized authentication logic using ABP Identity and NextAuth.js. Ensure all protected routes/APIs enforce authentication.
- **Authorization:** Utilize ABP Permission System for fine-grained authorization on the backend. Frontend components should conditionally render based on user permissions.
- **Error Handling:** Implement consistent error handling across both frontend and backend. Frontend should display user-friendly error messages for API failures.

## 4. Security Implementation in Source Code

**Input Validation and Authentication Patterns:**
- **Input Validation:** Perform rigorous input validation at all layers (frontend, application services, domain services) to prevent common vulnerabilities like SQL Injection, XSS, and command injection.
  - **Backend:** Use data annotations and FluentValidation (if applicable, TBD: specific validation library beyond data annotations) in DTOs and domain models.
  - **Frontend:** Use Zod schemas with React Hook Form for client-side validation.
- **Authentication:**
  - **Backend:** Leverage ABP Identity, JWT Bearer Tokens, and IdentityServer4/Duende for robust authentication.
  - **Frontend:** Use NextAuth.js for secure authentication flows, including session management and token handling.

**Data Protection and Secure Coding Practices:**
- **HTTPS/TLS 1.3:** Enforce HTTPS for all communication in production environments.
- **CORS:** Properly configure Cross-Origin Resource Sharing (CORS) policies to restrict access to trusted origins.
- **Rate Limiting:** Implement API rate limiting to prevent abuse and denial-of-service attacks.
- **Password Hashing:** Store passwords using strong, industry-standard hashing algorithms (handled by ASP.NET Core Identity).
- **Sensitive Data Handling:** Encrypt sensitive data at rest and in transit. Avoid storing sensitive information in plain text.
- **Secure Configuration:** Store sensitive configuration (e.g., connection strings, API keys) securely using environment variables or a secrets management system (TBD: specific secrets management solution for production).

**Sensitive Data Handling, SQL Injection, XSS Prevention:**
- **SQL Injection:** Prevent SQL injection by using Entity Framework Core's parameterized queries. Never construct SQL queries using string concatenation with user input.
- **Cross-Site Scripting (XSS):** Sanitize all user-generated content before rendering it on the frontend to prevent XSS attacks. Use React's built-in escaping mechanisms.
- **Cross-Site Request Forgery (CSRF):** Implement CSRF protection, typically handled by NextAuth.js for frontend and ASP.NET Core's anti-forgery tokens for backend forms (if traditional forms are used).

## 5. Code Quality and Testing Standards

**Unit Testing Conventions and Coverage Requirements:**
- **Backend:**
  - **Frameworks:** xUnit for testing, Moq for mocking.
  - **Naming:** Test classes should end with `Tests` (e.g., `AuthenticationAppServiceTests`). Test methods should be descriptive (e.g., `MethodName_Scenario_ExpectedResult`).
  - **Location:** Tests should reside in a separate test project (e.g., `AbpApp.Application.Tests`).
  - **Coverage:** Aim for high unit test coverage (TBD: specific percentage target, e.g., 80%).
- **Frontend:**
  - **Frameworks:** Jest for testing, React Testing Library for component testing.
  - **Naming:** Test files should be `[ComponentName].test.tsx` or `[ModuleName].test.ts`.
  - **Location:** Tests should be co-located with the components/modules they test or in a dedicated `__tests__` directory.
  - **Coverage:** Aim for high unit test coverage (TBD: specific percentage target, e.g., 80%).

**Test-Driven Development (TDD) Practices:**
- Encourage TDD where appropriate, writing tests before implementing the code to drive design and ensure testability.

**Code Review Process and Collaboration Guidelines:**
- **Pull Requests (PRs):** All code changes must go through a PR process.
- **Reviewers:** A minimum of one reviewer is required for each PR.
- **Automated Checks:** PRs must pass all automated CI/CD checks (linting, formatting, tests) before merging.
- **Constructive Feedback:** Provide constructive and actionable feedback during code reviews.

**Version Control and Repository Management:**
- **Version Control System:** Git.
- **Repository:** GitHub (`https://github.com/0336328069/SDLC-ABP-Project`).
- **Branching Strategy:** Git Flow-like model.
  - `main`: Production-ready code.
  - `develop`: Integration branch for all features.
  - `feature/{domain}-v{version}`: Feature branches (e.g., `feature/authentication-v1.0`).
  - `hotfix/{issue-number}`: Critical production fixes.
  - `release/v{major.minor}`: Release preparation.
- **Merge Strategy:** Squash and merge for feature branches into `develop`.

**Commit Message Conventions:**
- **Format:** Conventional Commits (TBD: specific conventional commit types to enforce, e.g., `feat:`, `fix:`, `chore:`).
- **Clarity:** Commit messages should be clear, concise, and explain the "why" behind the change, not just the "what."

## 6. Documentation Standards for Source Code

**Code Documentation Requirements and API Documentation:**
- **Backend (.NET):** Use XML Documentation Comments for all public classes, methods, and properties. This enables IntelliSense and auto-generation of API documentation (e.g., Swagger).
- **Frontend (TypeScript):** Use JSDoc comments for complex functions, components, and interfaces, especially for shared utilities and API clients.

**Architecture Documentation and Decision Records:**
- **High-Level Design:** Maintain `docs/DEV/HighLevelDesign_Authentication.md`.
- **System Architecture Design:** Maintain `docs/DEV/System_Architecture_Design_Authentication.md`.
- **ERD:** Maintain `docs/DEV/ERD_Authentication.md`.
- **Decision Records:** Document significant architectural decisions and their rationale (TBD: specific format or location for Architectural Decision Records - ADRs).

**Inline Comments, Function/Class Documentation, README Standards:**
- **Inline Comments:** Use sparingly, only for explaining complex logic or non-obvious code sections. Avoid commenting on "what" the code does; focus on "why."
- **Function/Class Documentation:** Every public function/method and class should have a clear summary of its purpose, parameters, and return values.
- **README Standards:**
  - `README.md` at the project root: Project overview, setup instructions, quick start.
  - `README.md` in major component/module directories (e.g., `src/backend/src/AbpApp.Domain/Authentication/README.md`): Module-specific details, purpose, and usage.

## 7. Development Environment and Tools

**IDE Configuration and Code Formatting Standards:**
- **IDEs:** Visual Studio 2022 (for .NET) and VS Code (for frontend).
- **EditorConfig:** Ensure `.editorconfig` is configured and respected by all IDEs for consistent indentation, line endings, and other basic formatting rules.
- **Automated Formatting:** Use `dotnet format` for C# and Prettier for TypeScript/JavaScript to automatically format code.

**Linting Rules and Automated Quality Checks:**
- **Backend:** Integrate `dotnet format` into CI/CD pipelines. Consider static analysis tools (TBD: specific static analysis tool like SonarQube).
- **Frontend:** Use ESLint for linting TypeScript/JavaScript code. Configure rules to enforce best practices and identify potential issues. Integrate ESLint into CI/CD.
- **Pre-commit Hooks:** Utilize Husky and lint-staged to run linters and formatters automatically before commits, ensuring code quality at the source.

**Build Tools, Dependency Management, Environment Variables:**
- **Build Tools:**
  - **Backend:** .NET SDK (`dotnet build`).
  - **Frontend:** Next.js built-in (Webpack/SWC).
- **Dependency Management:**
  - **Backend:** NuGet for .NET packages.
  - **Frontend:** npm/yarn for Node.js packages.
- **Environment Variables:**
  - **Backend (.NET):** Configure `appsettings.json` and `appsettings.Development.json`. Use environment variables for sensitive data and environment-specific settings (e.g., `ConnectionStrings__Default`, `AuthServer__Authority`, `Redis__Configuration`).
  - **Frontend (Next.js):** Use `NEXT_PUBLIC_` prefix for public environment variables. Store sensitive variables securely (e.g., `NEXTAUTH_SECRET`, `NEXTAUTH_URL`, `NEXT_PUBLIC_API_URL`).
- **Containerization:** Use Docker and Docker Compose for consistent development environments and local deployment. Nginx for local web serving/proxying via Docker Compose.

**TBD: Specific guidelines for managing and accessing environment variables in production environments (e.g., Azure Key Vault, Kubernetes Secrets).**
