# BACKEND API AUTHENTICATION - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về Clean Architecture và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **Framework**: ABP Framework 9.2.2 (.NET 9.0)
- **Language**: C# 12
- **Architecture**: Modular Monolith với Clean Architecture và Domain-Driven Design (DDD)
- **Project Structure**: Single-Project ABP template structure
- **API Location**: Controllers/Authentication/
- **Namespace Pattern**: AbpApp.{LayerName}.{Feature}
- **Build Command**: `dotnet build`

**Database**: SQL Server 2019+ (or PostgreSQL 15+) với Entity Framework Core 9.0

### Input Documents đã phân tích:
- **API_Swagger_Authentication.yaml**: 4 endpoints (register, login, request-password-reset, reset-password) với comprehensive DTOs
- **PRD_Authentication.md**: User personas (An-Explorer, Bình-Loyal, Chi-Forgetful), business flows, retention goals (15% after 7 days)
- **SRS&DM_Authentication.md**: Functional requirements (FR-REG, FR-LOG, FR-RP, FR-OUT), security requirements (Bcrypt, HTTPS, session timeouts)
- **US_Authentication.md**: Detailed acceptance criteria với Given-When-Then scenarios for all authentication flows
- **ImplementPlan_Authentication.md**: Complete technical implementation with .NET 9.0 + ABP Framework 8.3.0, Redis caching, JWT tokens
- **CodeConventionDocument_Authentication.md**: Naming conventions, architectural patterns, security practices, testing standards

### API Endpoints Available:
1. **POST /api/app/authentication/register** - User registration with email/password
2. **POST /api/app/authentication/login** - User login returning JWT token
3. **POST /api/app/authentication/request-password-reset** - Password reset request via email
4. **POST /api/app/authentication/reset-password** - Password reset with token
5. **POST /api/app/authentication/logout** - User logout/session termination

## 3. MỤC TIÊU BACKEND API

### 3.1 API CONTROLLERS

#### AuthenticationController
- RESTful endpoints cho Authentication operations
- HTTP Methods: POST for all authentication operations (security best practice)
- Authorization: Anonymous cho register/login/password-reset, Authenticated cho logout
- Files: 
  - `Controllers/Authentication/AuthenticationController.cs`

#### Controller Characteristics:
- Inherits from `AbpController` base class
- Uses `IAuthenticationAppService` dependency injection
- Implements async methods với `CancellationToken` support
- Returns consistent API responses using ABP's result wrapping
- Proper HTTP status codes (200, 201, 400, 401, 404, 500)

### 3.2 API MODELS (REQUEST/RESPONSE DTOS)

#### Request DTOs
- **RegisterDto**: Email, Password, ConfirmPassword với validation attributes
- **LoginDto**: Email, Password for authentication
- **PasswordResetRequestDto**: Email for reset request
- **ResetPasswordDto**: Token, NewPassword, ConfirmNewPassword

#### Response DTOs
- **AppUserDto**: Id, Email, IsEmailConfirmed, CreationTime
- **LoginResponseDto**: AccessToken, RefreshToken, ExpiresIn, User
- Standard ABP response wrapping for success/error scenarios

#### Files Organization
- `Services/Dtos/RegisterDto.cs`
- `Services/Dtos/LoginDto.cs`
- `Services/Dtos/PasswordResetRequestDto.cs`
- `Services/Dtos/ResetPasswordDto.cs`
- `Services/Dtos/AppUserDto.cs`
- `Services/Dtos/LoginResponseDto.cs`

### 3.3 API CONTRACTS

#### IAuthenticationAppService
- Application service interface defining authentication operations
- Methods: RegisterAsync, LoginAsync, RequestPasswordResetAsync, ResetPasswordAsync, LogoutAsync
- File: `Services/IAuthenticationAppService.cs`

#### Service Interface Methods:
```csharp
Task<AppUserDto> RegisterAsync(RegisterDto input);
Task<LoginResponseDto> LoginAsync(LoginDto input);
Task RequestPasswordResetAsync(PasswordResetRequestDto input);
Task ResetPasswordAsync(ResetPasswordDto input);
Task LogoutAsync();
```

### 3.4 MAPPING & ORCHESTRATION

#### DTO Mapping
- API DTO → Application DTO → Domain Entity
- AutoMapper configuration in `Services/AbpAppAutoMapperProfile.cs`
- Mapping profiles: AppUser ↔ AppUserDto, PasswordResetToken mappings

#### Service Orchestration
- Controller → Application Service → Domain Service → Repository
- Dependency injection: IAuthenticationAppService, IAuthenticationDomainService
- Domain events integration: UserRegisteredEventData, PasswordResetRequestedEventData

### 3.5 EXCEPTION HANDLING & LOGGING

#### Global Exception Filter
- Handle business exceptions (UserFriendlyException)
- HTTP status code mapping: Business exceptions → 400, Validation → 422, Auth → 401
- Error response format: ABP's ProblemDetails implementation

#### Logging Strategy
- Serilog structured logging
- Request/Response logging for security events
- Business error logging with context information
- Performance monitoring for authentication operations

### 3.6 UNIT TESTS / INTEGRATION TESTS

#### Unit Tests
- Controller endpoint tests with mocked application services
- Mock setup using NSubstitute or Moq
- Test scenarios: Success cases, validation failures, business rule violations

#### Integration Tests
- End-to-end API tests using ABP's testing infrastructure
- Authentication scenarios with real JWT token validation
- Database integration testing with in-memory database

## 4. YÊU CẦU IMPLEMENTATION

### API Implementation Best Practices
- **DO**: Follow RESTful design principles với consistent URL patterns
- **DO**: Use proper HTTP verbs (POST) và status codes for security operations
- **DO**: Implement proper authorization với ABP Permission System
- **DO**: Validate all input using Data Annotations và FluentValidation
- **DO**: Return consistent error responses using ABP's exception handling
- **DO**: Follow ABP Framework naming conventions và module structure
- **DO NOT**: Expose domain logic in controllers - delegate to application services
- **DO NOT**: Return sensitive data (passwords, internal tokens) in responses
- **DO NOT**: Create additional features beyond Authentication functionality

### Controller Characteristics cho Authentication
- Async methods: All API endpoints với proper async/await usage
- CancellationToken support: Optional parameter in all methods
- Authorization attributes: [AllowAnonymous] for public endpoints, [Authorize] for protected
- Validation attributes: [Valid] model binding validation
- Exception handling: Global exception filter handles all business exceptions

### Security Requirements
- Password hashing: BCrypt with cost factor 12 (handled by ASP.NET Core Identity)
- HTTPS enforcement: All authentication endpoints require HTTPS
- Session management: JWT Bearer tokens với 24-hour expiration
- Password reset tokens: 60-minute expiration with one-time use
- Account lockout: 5 failed attempts locks account for 15 minutes

## 5. OUTPUT FORMAT

**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

1. **Controller Files**: `Controllers/Authentication/AuthenticationController.cs`
2. **DTO Files**: `Services/Dtos/*.cs` (6 DTO files)
3. **Contract Files**: `Services/IAuthenticationAppService.cs`
4. **Mapping Files**: Updated `Services/AbpAppAutoMapperProfile.cs`
5. **Test Files**: `AbpAppApplicationTests/Authentication/AuthenticationControllerTests.cs`

Each file must be complete, compilable code following ABP Framework conventions và Clean Architecture principles.

## 6. API QUALITY STANDARDS

API Quality Checklist:
- [ ] RESTful design với proper HTTP verbs (POST for authentication operations)
- [ ] Correct HTTP status codes (200, 201, 400, 401, 404, 500)
- [ ] Content-Type headers set correctly (application/json)
- [ ] URL conventions: /api/app/authentication/[action]
- [ ] Consistent error structure using ABP's ProblemDetails
- [ ] Business exceptions với meaningful messages (UserFriendlyException)
- [ ] JWT Bearer token authentication implemented
- [ ] Permission-based authorization với ABP Permission System
- [ ] Input validation và sanitization using Data Annotations
- [ ] HTTPS enforcement in production
- [ ] Async programming với CancellationToken support
- [ ] Constructor dependency injection following ABP patterns
- [ ] Clean architecture layer separation (Controller → AppService → DomainService)

## 7. SECURITY & VALIDATION REQUIREMENTS

### Input Validation
- **Email validation**: RFC 5322 compliance using [EmailAddress] attribute
- **Password complexity**: Minimum 8 characters, uppercase, lowercase, number using regex validation
- **Password confirmation**: Must match original password
- **Token validation**: Secure token verification for password reset

### Authentication & Authorization
- **Anonymous access**: Register, Login, Password Reset operations
- **Authenticated access**: Logout operation requires valid JWT token
- **Rate limiting**: Implement request throttling for authentication endpoints
- **Account lockout**: Automatic lockout after 5 failed login attempts

### Security Best Practices
- **Password hashing**: BCrypt with salt, never store plaintext passwords
- **Token security**: JWT tokens với proper expiration và secure storage
- **HTTPS enforcement**: All authentication data transmitted over TLS 1.2+
- **Audit logging**: Log all authentication events for security monitoring

## 8. BUSINESS WORKFLOWS MAPPING

### Workflow 1: User Registration Flow
- Use Case: US_Authentication.md - User Story 1
- API Endpoint: POST /api/app/authentication/register
- HTTP Method: POST
- Request DTO: RegisterDto (Email, Password, ConfirmPassword)
- Response DTO: AppUserDto
- Business Rules: Email uniqueness, password complexity, automatic login after registration

### Workflow 2: User Login Flow
- Use Case: US_Authentication.md - User Story 2
- API Endpoint: POST /api/app/authentication/login
- HTTP Method: POST
- Request DTO: LoginDto (Email, Password)
- Response DTO: LoginResponseDto (AccessToken, User info)
- Business Rules: Credential validation, account lockout after 5 failures, session creation

### Workflow 3: Password Reset Request Flow
- Use Case: US_Authentication.md - User Story 3 (Part 1)
- API Endpoint: POST /api/app/authentication/request-password-reset
- HTTP Method: POST
- Request DTO: PasswordResetRequestDto (Email)
- Response DTO: Void (success/error message only)
- Business Rules: Email existence check, token generation, email dispatch

### Workflow 4: Password Reset Completion Flow
- Use Case: US_Authentication.md - User Story 3 (Part 2)
- API Endpoint: POST /api/app/authentication/reset-password
- HTTP Method: POST
- Request DTO: ResetPasswordDto (Token, NewPassword, ConfirmNewPassword)
- Response DTO: Void (success message)
- Business Rules: Token validation, password complexity, token invalidation after use

### Workflow 5: User Logout Flow
- Use Case: US_Authentication.md - User Story 4
- API Endpoint: POST /api/app/authentication/logout
- HTTP Method: POST
- Request DTO: None
- Response DTO: Void
- Business Rules: Session termination, token invalidation

## 9. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend`):
```bash
dotnet build
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.

## 10. ADDITIONAL REQUIREMENTS

### ABP Framework Integration
- Use ABP's built-in services: IIdentityUserManager, IIdentityUserRepository
- Implement proper dependency injection using ABP's DI container
- Follow ABP's module structure và naming conventions
- Use ABP's localization system for error messages
- Implement audit logging using ABP's audit system

### Performance Considerations
- Database indexing on email columns for fast lookups
- Redis caching for session data và frequent user queries
- Async operations để avoid blocking threads
- Proper connection pooling và EF Core optimization
- Rate limiting để prevent brute force attacks

### Monitoring & Observability
- Structured logging using Serilog với authentication context
- Health checks for authentication dependencies
- Metrics collection for authentication success/failure rates
- Error tracking và performance monitoring
- Security event logging for compliance requirements

### Documentation Requirements  
- XML documentation comments for all public APIs
- OpenAPI/Swagger documentation với examples
- README updates for authentication setup
- API documentation with authentication flows
- Security documentation for deployment teams