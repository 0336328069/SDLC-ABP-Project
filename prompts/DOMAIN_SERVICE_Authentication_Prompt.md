# DOMAIN SERVICE AUTHENTICATION - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về Domain-Driven Design và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **Framework**: ABP Framework 9.2.2 (.NET 9.0)
- **Language**: C# 12
- **Architecture**: Modular Monolith with DDD and Clean Architecture
- **Project Structure**: Single-tier ABP application with embedded layers
- **Services Location**: D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Services
- **Namespace Pattern**: AbpApp.{FeatureName}
- **Build Command**: dotnet build D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\AbpApp.csproj

**Database**: SQL Server with Entity Framework Core 9.0

### Input Documents đã phân tích:
- **BussinessLogic_Authentication.md**: Comprehensive business logic for Authentication domain including entities (AppUser, PasswordResetToken), value objects (EmailAddress, Password), specifications, domain events, and security workflows
- **ImplementPlan_Authentication.md**: Technical implementation plan for Authentication system with ABP Framework, JWT tokens, and secure password management using BCrypt
- **PRD_Authentication_v1.0.md**: Business requirements for user registration, login, password reset, and logout flows with security and UX considerations

### Domain Model Components Available:
- **Entities**: AppUser (extends IdentityUser), PasswordResetToken (aggregate root)
- **Value Objects**: EmailAddress, Password (with BCrypt hashing)
- **Repository Interfaces**: IPasswordResetTokenRepository, IAppUserRepository
- **Specifications**: ValidPasswordResetTokensForUserSpecification, ExpiredPasswordResetTokensSpecification, PasswordResetTokenByHashSpecification, LockedUsersSpecification, UsersWithFailedLoginsSpecification
- **Domain Events**: UserRegisteredEventData, PasswordResetRequestedEventData, PasswordResetCompletedEventData, UserLoginEventData, UserLogoutEventData

## 3. MỤC TIÊU DOMAIN SERVICES

### 3.1 DOMAIN SERVICE CLASSES

#### IAuthenticationDomainService & AuthenticationDomainService
- Cross-aggregate business logic cho Authentication system
- Methods được identify từ business workflows:
  ```csharp
  Task<PasswordResetToken> GeneratePasswordResetTokenAsync(Guid userId, CancellationToken cancellationToken = default);
  Task<bool> ValidatePasswordResetTokenAsync(string tokenHash, CancellationToken cancellationToken = default);
  Task CompletePasswordResetAsync(string tokenHash, string newPassword, CancellationToken cancellationToken = default);
  Task<bool> IsAccountLockedAsync(Guid userId, CancellationToken cancellationToken = default);
  Task HandleFailedLoginAttemptAsync(Guid userId, CancellationToken cancellationToken = default);
  Task ClearFailedLoginAttemptsAsync(Guid userId, CancellationToken cancellationToken = default);
  Task CleanupExpiredTokensAsync(CancellationToken cancellationToken = default);
  ```
- Repository dependencies: IPasswordResetTokenRepository, IAppUserRepository
- Files: 
  - `Services/Authentication/IAuthenticationDomainService.cs`
  - `Services/Authentication/AuthenticationDomainService.cs`

#### IPasswordSecurityManager & PasswordSecurityManager
- Password-related security operations and token management
- Methods for secure token generation, validation, and cleanup:
  ```csharp
  Task<(string PlainToken, string TokenHash)> GenerateSecureTokenAsync();
  Task<bool> ValidateTokenHashAsync(string tokenHash);
  Task InvalidateUserTokensAsync(Guid userId, CancellationToken cancellationToken = default);
  Task<TimeSpan> GetTokenExpirationTimeAsync();
  ```
- Files:
  - `Services/Authentication/IPasswordSecurityManager.cs`
  - `Services/Authentication/PasswordSecurityManager.cs`

### 3.2 BUSINESS LOGIC IMPLEMENTATION

Core business rules implementation:

#### Password Reset Token Management
- Logic: Generate cryptographically secure tokens, hash for storage, enforce 60-minute expiration
- Validation: Token uniqueness, expiration time, single-use enforcement
- Exception: TokenExpiredException, TokenAlreadyUsedException, InvalidTokenException

#### Account Security Operations
- Logic: Account lockout after 5 failed attempts, automatic unlock after time period
- Validation: Failed attempt counting, lockout status checking
- Exception: AccountLockedException, TooManyAttemptsException

#### Cross-Aggregate Operations
- User Registration with Token Generation: Coordinate AppUser creation with initial security setup
- Repository coordination: Atomic operations across User and PasswordResetToken repositories
- Transaction boundaries: Use Unit of Work pattern for consistency

### 3.3 REPOSITORY USAGE

Repository pattern implementation:

#### Constructor Injection
```csharp
private readonly IPasswordResetTokenRepository _tokenRepository;
private readonly IAppUserRepository _userRepository;
private readonly IUnitOfWorkManager _unitOfWorkManager;
private readonly IClock _clock;
private readonly ILogger<AuthenticationDomainService> _logger;
```

#### Repository Operations
- FindByTokenHashAsync: Retrieve token by hash for validation
- GetValidTokensForUserAsync: Find active tokens for cleanup
- CreateAsync: Store new password reset tokens
- Transaction handling: Use UnitOfWork for multi-repository operations

### 3.4 UNIT TESTS

Complete test coverage:

#### Test Classes
- `AuthenticationDomainServiceTests.cs`: Test token generation, validation, password reset workflows
- `PasswordSecurityManagerTests.cs`: Test token security operations, cleanup processes

#### Test Scenarios
- Happy Path Tests: Successful token generation, valid password reset, account unlock
- Validation Tests: Expired token handling, invalid token rejection, password complexity
- Exception Tests: Proper exception throwing for business rule violations
- Edge Cases: Concurrent token operations, cleanup edge cases, performance scenarios

#### Mock Dependencies
```csharp
Mock<IPasswordResetTokenRepository> mockTokenRepo;
Mock<IAppUserRepository> mockUserRepo;
Mock<IUnitOfWorkManager> mockUowManager;
Mock<IClock> mockClock;
Mock<ILogger<AuthenticationDomainService>> mockLogger;
```

## 4. YÊU CẦU IMPLEMENTATION

### Domain Service Best Practices
- **DO**: Define trong domain layer với DomainService base class
- **DO**: Name với DomainService suffix cho Authentication
- **DO**: Methods chỉ mutate data, không GET operations
- **DO**: Accept domain objects: AppUser, PasswordResetToken, EmailAddress, Password
- **DO**: Throw BusinessException: AuthenticationBusinessException, TokenBusinessException
- **DO**: Follow ABP Framework domain service patterns
- **DO NOT**: Return DTOs, chỉ return: domain objects, primitive types, Task<void>
- **DO NOT**: Involve authentication logic (that's for application layer)
- **DO NOT**: Create additional features beyond Authentication

### Method Characteristics cho Authentication
- Async methods: All repository operations and cross-aggregate workflows
- CancellationToken support for all async operations
- Business operation names: GeneratePasswordResetToken, ValidateToken, CompletePasswordReset
- Domain parameters: Guid userId, string tokenHash, Password newPassword
- Exception handling: Catch repository exceptions, throw domain exceptions

## 5. OUTPUT FORMAT

**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

1. **Interface File**: `Services/Authentication/IAuthenticationDomainService.cs`
2. **Implementation File**: `Services/Authentication/AuthenticationDomainService.cs`
3. **Security Manager Interface**: `Services/Authentication/IPasswordSecurityManager.cs`
4. **Security Manager Implementation**: `Services/Authentication/PasswordSecurityManager.cs` 
5. **Unit Test File**: `Tests/Authentication/AuthenticationDomainServiceTests.cs`
6. **Security Manager Test File**: `Tests/Authentication/PasswordSecurityManagerTests.cs`

Each file must be complete, compilable C# code following ABP Framework conventions.

## 6. VALIDATION CHECKLIST

Domain Service Quality Checklist:
- [ ] Cross-aggregate business logic properly implemented
- [ ] Methods chỉ mutate data, không có GET operations
- [ ] Business exceptions với domain error codes: AUTH_001, AUTH_002, AUTH_003
- [ ] Repository injection: IPasswordResetTokenRepository, IAppUserRepository
- [ ] Unit tests cover: token generation, validation, expiration, cleanup scenarios
- [ ] Naming convention: AuthenticationDomainService, PasswordSecurityManager
- [ ] Stateless service design with proper dependency injection
- [ ] Aggregate boundaries respected: User aggregate vs PasswordResetToken aggregate
- [ ] No infrastructure dependencies (email, caching, etc.)
- [ ] Business rules from PRD implemented: 60-minute expiration, single-use tokens, account lockout
- [ ] Domain events published: None (domain services don't publish events directly)

## 7. BUSINESS WORKFLOWS MAPPING

Business workflows implementation mapping:

#### Workflow 1: Password Reset Request
- User Story: User requests password reset via email
- Domain Service Method: GeneratePasswordResetTokenAsync
- Business Rules: 60-minute expiration, secure token generation, cleanup old tokens
- Repository Operations: Create new token, invalidate existing tokens
- Domain Events: None (published by application service)

#### Workflow 2: Password Reset Completion
- User Story: User completes password reset using token
- Domain Service Method: ValidatePasswordResetTokenAsync, CompletePasswordResetAsync
- Business Rules: Token validation, single-use enforcement, password complexity
- Repository Operations: Find token by hash, mark as used, update user password
- Domain Events: None (published by application service)

#### Workflow 3: Account Security Management
- User Story: System manages account lockout and security
- Domain Service Method: HandleFailedLoginAttemptAsync, IsAccountLockedAsync
- Business Rules: 5-attempt lockout, automatic unlock timing
- Repository Operations: Update failed attempt count, check lockout status
- Domain Events: None (security events published by application service)

#### Workflow 4: Token Cleanup
- User Story: System maintains token hygiene
- Domain Service Method: CleanupExpiredTokensAsync
- Business Rules: Remove expired tokens, maintain database efficiency
- Repository Operations: Bulk delete expired tokens using specifications
- Domain Events: None (maintenance operation)

## 8. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp`):
```bash
dotnet build D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\AbpApp.csproj
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.