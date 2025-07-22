I will now generate the `ImplementPlan_Authentication_v1.0.md` file. This plan is derived strictly from the provided technical documentation, synthesizing the architecture, design, and conventions into a step-by-step guide for developers.

This command will write the implementation plan to `docs/DEV/ImplementPlan_Authentication_v1.0.md`.It appears I'm unable to write files directly. My apologies.

However, I have generated the complete implementation plan based on the provided documentation. Here is the content for `docs/DEV/ImplementPlan_Authentication_v1.0.md`. You can create the file and paste this content.

---

# Implementation Plan: Authentication v1.0

## 1. Executive Summary
This document outlines the step-by-step implementation plan for the **Authentication** feature. The technical strategy is to build a secure and robust authentication system using **ABP Framework v8.3.0** with **.NET 9.0** for the backend, and **Next.js 14+** for the frontend.

The architecture follows a layered, Domain-Driven Design (DDD) approach. The backend will expose RESTful APIs for user registration, login, and password management, secured by JWT Bearer tokens. The frontend will consume these APIs using NextAuth.js for session management, providing a seamless user experience. The target outcome is a fully functional, secure, and testable authentication module that aligns with the project's established conventions and technical stack.

## 2. Development Phases

### Phase 1: Backend - Core Infrastructure & Logic
- **Inputs:** `ERD_Authentication_v1.0.md`, `LowLevelDesign_Authentication_v1.0.md`.
- **Artifacts:**
    - Updated `AbpAppDbContext` with Identity entities.
    - `AuthenticationAppService` with DTOs and validators.
    - `AuthenticationController` exposing core endpoints.
- **Done Criteria:** Backend APIs for register and login are functional and can be tested via Swagger UI. Unit tests for the application service pass.

### Phase 2: Frontend - UI & API Integration
- **Inputs:** `API_Swagger_Authentication_v1.0.md`, `HighLevelDesign_Authentication_v1.0.md`.
- **Artifacts:**
    - `LoginForm.tsx`, `RegisterForm.tsx` components.
    - `auth.ts` API service layer.
    - `authStore.ts` Zustand store for state management.
    - `login` and `register` pages.
- **Done Criteria:** Users can register and log in through the Next.js UI. The JWT token is successfully stored and managed by the `authStore` and NextAuth.js.

### Phase 3: Backend & Frontend - Advanced Features
- **Inputs:** `API_Swagger_Authentication_v1.0.md`, `LowLevelDesign_Authentication_v1.0.md`.
- **Artifacts:**
    - Backend logic for "Forgot Password" and "Reset Password".
    - Frontend forms and pages for the password recovery flow.
    - Email sending integration for password reset links.
- **Done Criteria:** The full password recovery flow is functional and end-to-end testable.

### Phase 4: Testing & Refinement
- **Inputs:** `CodeConventionDocument_Authentication_v1.0.md`.
- **Artifacts:**
    - xUnit tests for `AuthenticationAppService`.
    - Jest/RTL tests for `LoginForm.tsx` and `RegisterForm.tsx`.
    - Integration tests for the API endpoints.
- **Done Criteria:** Code coverage meets project standards. All major user flows are covered by automated tests.

### Phase 5: Security & Deployment Hardening
- **Inputs:** `SystemArchitectureDesign_Authentication_v1.0.md`.
- **Artifacts:**
    - Rate limiting middleware implementation.
    - Finalized Docker configuration.
    - Production-ready environment variables.
- **Done Criteria:** The application is fully containerized and ready for deployment. Security measures are implemented and verified.

---

## 3. Backend Implementation Plan

### 3.1. Domain Layer (`AbpApp.Domain`)
- **Action:** No new entities are required. The plan will use the existing `IdentityUser` entity from the `Volo.Abp.Identity.Domain` package.
- **File:** `src/backend/src/AbpApp.Domain/Users/UserManager.cs`
- **Responsibility:** Extend `IdentityUserManager` if custom business rules for user management are needed (e.g., complex password policies not covered by default). For this feature, the base manager is sufficient.

### 3.2. Application.Contracts Layer (`AbpApp.Application.Contracts`)
- **Action:** Define DTOs and the application service interface.
- **Folder:** `src/backend/src/AbpApp.Application.Contracts/Authentication/`
- **Files:**
    - `IAuthenticationAppService.cs`:
        ```csharp
        public interface IAuthenticationAppService : IApplicationService
        {
            Task<AuthResultDto> RegisterAsync(RegisterDto input);
            Task<AuthResultDto> LoginAsync(LoginDto input);
        }
        ```
    - `Dto/RegisterDto.cs`:
        ```csharp
        public class RegisterDto { /* Properties from LowLevelDesign */ }
        ```
    - `Dto/LoginDto.cs`:
        ```csharp
        public class LoginDto { /* Properties from LowLevelDesign */ }
        ```
    - `Dto/AuthResultDto.cs`:
        ```csharp
        public class AuthResultDto { /* Properties from LowLevelDesign */ }
        ```

### 3.3. Application Layer (`AbpApp.Application`)
- **Action:** Implement the business logic for authentication.
- **Folder:** `src/backend/src/AbpApp.Application/Authentication/`
- **Files:**
    - `AuthenticationAppService.cs`:
        - Implement `IAuthenticationAppService`.
        - Inject `IdentityUserManager`, `SignInManager<IdentityUser>`, and `IConfiguration`.
        - Use `_userManager.CreateAsync` for registration.
        - Use `_signInManager.CheckPasswordSignInAsync` for login.
        - Implement `GenerateJwtTokenAsync` method as detailed in `LowLevelDesign`.
    - `Validators/RegisterDtoValidator.cs`:
        - Implement `AbstractValidator<RegisterDto>`.
        - Add rules for Email, Password (length, complexity), and ConfirmPassword as specified in `LowLevelDesign`.
    - `AuthenticationApplicationAutoMapperProfile.cs`:
        - Create mapping from `IdentityUser` to `UserInfoDto`.

### 3.4. HttpApi Layer (`AbpApp.HttpApi`)
- **Action:** Create the controller to expose endpoints.
- **File:** `src/backend/src/AbpApp.HttpApi/Controllers/AuthenticationController.cs`
- **Responsibility:**
    - Inject `IAuthenticationAppService`.
    - Create `POST` methods for `/api/auth/register` and `/api/auth/login`.
    - Map HTTP requests to the `AuthenticationAppService`.
    - Ensure `[AllowAnonymous]` attribute is used on public endpoints.

## 4. Frontend Implementation Plan

### 4.1. API Service Layer
- **Action:** Create a service to interact with the backend authentication API.
- **File:** `src/frontend/lib/api/auth.ts`
- **Responsibility:**
    - Implement `authApi.login` and `authApi.register` methods using an `ApiClient` (e.g., Axios).
    - Define TypeScript interfaces for requests and responses (`LoginRequest`, `AuthResponse`) matching the API Swagger.

### 4.2. State Management (Zustand)
- **Action:** Create a store to manage authentication state globally.
- **File:** `src/frontend/stores/authStore.ts`
- **Responsibility:**
    - Define `AuthState` interface (`user`, `token`, `isAuthenticated`).
    - Implement `login` and `logout` actions to update the state.
    - Persist state to `localStorage` to keep the user logged in across sessions.

### 4.3. UI Components
- **Action:** Build reusable UI components for authentication forms.
- **Folder:** `src/frontend/components/auth/`
- **Files:**
    - `LoginForm.tsx`:
        - Use `react-hook-form` with `zodResolver` for validation.
        - Define `loginSchema` with Zod based on `LowLevelDesign`.
        - Use `useMutation` from `@tanstack/react-query` to call `authApi.login`.
        - On success, call `authStore.login` and redirect.
        - Handle and display API errors.
    - `RegisterForm.tsx`:
        - Similar structure to `LoginForm.tsx`, but for the registration endpoint.

### 4.4. Pages (App Router)
- **Action:** Create pages for authentication routes.
- **Folders:**
    - `src/frontend/app/auth/login/page.tsx`
    - `src/frontend/app/auth/register/page.tsx`
- **Responsibility:** Render the `LoginForm` and `RegisterForm` components respectively.

## 5. Database Migration Plan
- **Action:** The project uses ABP Identity, which already defines the necessary tables (`AbpUsers`, `AbpUserTokens`). A migration is needed to create these tables in the database.
- **Tool:** `dotnet-ef`
- **Steps:**
    1. Open a terminal in `src/backend/src/AbpApp.EntityFrameworkCore/`.
    2. Run the command to add a migration:
       ```bash
       dotnet ef migrations add Initial_Authentication_Module
       ```
    3. Verify the generated migration file includes `CREATE TABLE AbpUsers`.
    4. Run the command to apply the migration to the database:
       ```bash
       dotnet ef database update
       ```

## 6. Testing Strategy

### 6.1. Backend (xUnit)
- **Folder:** `src/backend/test/AbpApp.Application.Tests/Authentication/`
- **File:** `AuthenticationAppService_Tests.cs`
- **Test Cases:**
    - `RegisterAsync_WithValidInput_ShouldCreateUserAndReturnToken`
    - `RegisterAsync_WithExistingEmail_ShouldThrowBusinessException`
    - `LoginAsync_WithValidCredentials_ShouldReturnToken`
    - `LoginAsync_WithInvalidCredentials_ShouldThrowBusinessException`
    - `LoginAsync_WithLockedOutUser_ShouldThrowBusinessException`

### 6.2. Frontend (Jest + React Testing Library)
- **Folder:** `src/frontend/components/auth/`
- **Files:**
    - `LoginForm.test.tsx`
    - `RegisterForm.test.tsx`
- **Test Cases:**
    - `should submit form with valid credentials`
    - `should display validation errors for invalid input`
    - `should display API error message on failed login`

## 7. Security Implementation
- **JWT Generation:** Implemented in `AuthenticationAppService.GenerateJwtTokenAsync`. The secret key must be configured in `appsettings.json` under `Jwt:SecretKey`.
- **Password Hashing:** Handled automatically by `IdentityUserManager` which uses ASP.NET Core Identity's default hasher (PBKDF2).
- **Rate Limiting:**
    - Implement `RateLimitingMiddleware` as detailed in `LowLevelDesign`.
    - Register the middleware in `AbpAppHttpApiHostModule.cs`.
    - Use `IDistributedCache` (Redis) for storing request counts.
- **Authorization:** Secure controllers/methods by default. Use `[AllowAnonymous]` for public endpoints like login/register.

## 8. Performance Optimization
- **Redis Caching:** The architecture includes Redis. For authentication, it's primarily used for rate limiting and storing lockout information. User session data or permissions can be cached to reduce database queries.
- **Asynchronous Operations:** All I/O-bound operations (database calls, API requests) must be implemented asynchronously using `async/await` as per the code conventions.

## 9. Deployment Checklist
- **Environment Variables:**
    - `ConnectionStrings:Default`: SQL Server connection string.
    - `Redis:Configuration`: Redis connection string.
    - `Jwt:SecretKey`: A strong, unique secret for signing JWTs.
    - `Jwt:Issuer`: Token issuer URL.
    - `Jwt:Audience`: Token audience URL.
- **Build Process:**
    - Backend: `dotnet publish -c Release`
    - Frontend: `npm run build`
- **Containerization:**
    - Use the existing `docker-compose.yml` to build and run the services.
    - Ensure Nginx is correctly configured as a reverse proxy for the backend and frontend services.

## 10. Validation Criteria
- **Technical Criteria:**
    - A new user can register via `POST /api/auth/register`.
    - A registered user can log in via `POST /api/auth/login` and receive a valid JWT.
    - Invalid login attempts are tracked, and the account is locked after 5 failed attempts.
    - Frontend forms show validation errors for incorrect input (e.g., invalid email format, weak password).
    - All unit tests for backend and frontend must pass.
- **Business Acceptance Criteria:**
    - A new user can create an account and immediately log in.
    - A user cannot create an account with an email that is already in use.
    - A user is clearly notified of incorrect login credentials.
    - The user's session is maintained after refreshing the browser.
