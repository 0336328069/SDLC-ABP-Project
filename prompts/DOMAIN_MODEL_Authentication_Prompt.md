# DOMAIN MODEL AUTHENTICATION - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về Domain-Driven Design và ABP Framework.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **Framework**: ABP Framework 9.2.2 (.NET 9.0)
- **Language**: C# 12
- **Architecture**: Modular Monolith with DDD and Clean Architecture
- **Project Structure**: Single-tier ABP application with embedded layers
- **Domain Location**: D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities
- **Namespace Pattern**: AbpApp.{FeatureName}
- **Build Command**: dotnet build D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\AbpApp.csproj

**Database**: SQL Server with Entity Framework Core 9.0

### Input Documents đã phân tích:
- **ImplementPlan_Authentication.md**: Comprehensive authentication system with user registration, login, password reset, and session management using ABP Identity, JWT tokens, and Redis caching
- **PRD_Authentication_v1.0.md**: User authentication requirements including registration, login, password reset flows with security and UX considerations
- **Codebase Analysis**: ABP Framework 9.2.2 with Entity Framework Core, SQL Server, OpenIddict for OAuth/OpenID Connect, and LeptonX Lite theme

### Cấu trúc Code hiện tại:
```
AbpApp/
├── Entities/                           # Domain entities location
├── Data/                              # EF Core configurations
│   ├── AbpAppDbContext.cs
│   ├── AbpAppDbContextFactory.cs
│   └── Migrations/
├── Services/                          # Application services
├── Permissions/                       # Permission definitions
├── ObjectMapping/                     # AutoMapper profiles
└── AbpAppModule.cs                   # Main module configuration
```

### Conventions được sử dụng:
- **Namespace**: AbpApp.{FeatureName} (e.g., AbpApp.Authentication)
- **File Extension**: .cs
- **Entity Base Classes**: FullAuditedAggregateRoot<Guid>, FullAuditedEntity<Guid>
- **Repository Interfaces**: IRepository<TEntity, TKey> from ABP Framework
- **Domain Services**: Inherit from DomainService
- **Aggregate Roots**: Use Guid as primary key
- **Database**: SQL Server with EF Core migrations

## 3. MỤC TIÊU DOMAIN MODEL
Tạo các thành phần cốt lõi của Domain Model cho Authentication feature. *Lưu ý: Domain Services không thuộc phạm vi của prompt này.*

### 3.1 AGGREGATE ROOTS & ENTITIES

#### AppUser (Aggregate Root - Extend existing ABP Identity)
- **Inheritance**: Extends Volo.Abp.Identity.IdentityUser from ABP Framework
- **Purpose**: Represents authenticated users in the system
- **Properties**: 
  - Inherits all properties from IdentityUser (Id, UserName, Email, PasswordHash, etc.)
  - Additional custom properties can be added if needed
- **Business Rules**: 
  - Email must be unique and valid
  - Password must meet complexity requirements (8+ chars, upper, lower, digit)
  - Account can be locked after 5 failed login attempts
- **Namespace**: AbpApp.Users
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Users\AppUser.cs`

#### PasswordResetToken (Aggregate Root)
- **Primary Key**: `Guid Id`
- **Properties**:
  - `Guid UserId` - Foreign key to AppUser
  - `string ResetTokenHash` - Hashed version of the reset token
  - `DateTime ExpirationTimeUtc` - Token expiration time (60 minutes from creation)
  - `bool IsUsed` - Whether token has been consumed
- **Business Rules**:
  - Token expires after 60 minutes
  - Token can only be used once
  - Token hash must be unique and secure
- **Methods**:
  - `MarkAsUsed()` - Mark token as consumed
- **Audit**: Implement `FullAuditedAggregateRoot<Guid>` for creation/modification tracking
- **Namespace**: AbpApp.Authentication
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\PasswordResetToken.cs`

### 3.2 VALUE OBJECTS  

#### EmailAddress (Value Object)
- **Purpose**: Encapsulate email validation logic and ensure data consistency
- **Properties**: `string Value`
- **Methods**: 
  - `IsValid()` - Validate email format using regex
  - `GetDomain()` - Extract domain from email
- **Validation Rules**: Must be valid email format, not null or empty
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\ValueObjects\EmailAddress.cs`

#### Password (Value Object)
- **Purpose**: Encapsulate password complexity rules and hashing logic
- **Properties**: `string Value` (hashed)
- **Methods**:
  - `ValidateComplexity()` - Check password meets security requirements
  - `Hash()` - Hash password using BCrypt
  - `Verify(string plaintext)` - Verify plaintext against hash
- **Business Rules**: 8+ characters, uppercase, lowercase, digit
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\ValueObjects\Password.cs`

### 3.3 REPOSITORY INTERFACES

#### IPasswordResetTokenRepository
- **Inheritance**: Extends `IRepository<PasswordResetToken, Guid>`
- **Custom Methods**:
  ```csharp
  Task<PasswordResetToken> FindByTokenHashAsync(string tokenHash);
  Task<List<PasswordResetToken>> GetValidTokensForUserAsync(Guid userId);
  Task<List<PasswordResetToken>> GetExpiredTokensAsync();
  Task DeleteExpiredTokensAsync();
  ```
- **Purpose**: Provide data access abstraction for password reset tokens
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\IPasswordResetTokenRepository.cs`

#### IAppUserRepository (Optional - if custom queries needed)
- **Inheritance**: Extends `IRepository<AppUser, Guid>`
- **Custom Methods**:
  ```csharp
  Task<AppUser> FindByEmailAsync(string email);
  Task<List<AppUser>> GetLockedUsersAsync();
  Task<List<AppUser>> GetUsersWithFailedLoginsAsync(int threshold);
  ```
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Users\IAppUserRepository.cs`

### 3.4 SPECIFICATION PATTERN

#### ValidPasswordResetTokensForUserSpecification
- **Purpose**: Find all valid (not expired, not used) tokens for a specific user
- **Criteria**: UserId = provided userId AND ExpirationTimeUtc > DateTime.UtcNow AND IsUsed = false
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Specifications\ValidPasswordResetTokensForUserSpecification.cs`

#### ExpiredPasswordResetTokensSpecification
- **Purpose**: Find all expired tokens for cleanup operations
- **Criteria**: ExpirationTimeUtc < DateTime.UtcNow
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Specifications\ExpiredPasswordResetTokensSpecification.cs`

#### PasswordResetTokenByHashSpecification
- **Purpose**: Find token by its hash value for reset operations
- **Criteria**: ResetTokenHash = provided hash AND IsUsed = false
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Specifications\PasswordResetTokenByHashSpecification.cs`

#### LockedUsersSpecification
- **Purpose**: Find users with locked accounts
- **Criteria**: LockoutEnd > DateTime.UtcNow (from IdentityUser)
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Users\Specifications\LockedUsersSpecification.cs`

#### UsersWithFailedLoginsSpecification
- **Purpose**: Find users with recent failed login attempts above threshold
- **Criteria**: AccessFailedCount >= threshold (from IdentityUser)
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Users\Specifications\UsersWithFailedLoginsSpecification.cs`

### 3.5 DOMAIN EVENTS

#### UserRegisteredEventData
- **Trigger**: When a new user successfully registers
- **Properties**: 
  - `Guid UserId` - ID of newly registered user
  - `string Email` - User's email address
  - `DateTime RegistrationTime` - When registration occurred
- **Purpose**: Notify other bounded contexts about new user registration
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Events\UserRegisteredEventData.cs`

#### PasswordResetRequestedEventData
- **Trigger**: When user requests password reset
- **Properties**:
  - `Guid UserId` - User requesting reset
  - `string Email` - User's email for sending reset link
  - `string ResetToken` - Plain text token for email (not the hash)
  - `DateTime RequestTime` - When request was made
- **Purpose**: Trigger email sending for password reset
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Events\PasswordResetRequestedEventData.cs`

#### PasswordResetCompletedEventData
- **Trigger**: When user successfully resets password using token
- **Properties**:
  - `Guid UserId` - User who reset password
  - `DateTime ResetTime` - When reset was completed
- **Purpose**: Log security event and notify relevant systems
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Events\PasswordResetCompletedEventData.cs`

#### UserLoginEventData
- **Trigger**: When user successfully logs in
- **Properties**:
  - `Guid UserId` - User who logged in
  - `string IpAddress` - Login IP address
  - `DateTime LoginTime` - When login occurred
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Events\UserLoginEventData.cs`

#### UserLogoutEventData
- **Trigger**: When user logs out
- **Properties**:
  - `Guid UserId` - User who logged out
  - `DateTime LogoutTime` - When logout occurred
- **File**: `D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\Entities\Authentication\Events\UserLogoutEventData.cs`

## 4. YÊU CẦU KỸ THUẬT

### Framework Requirements
- Use ABP Framework 9.2.2 conventions and base classes
- Implement proper Entity Framework Core 9.0 configurations
- Follow ABP's Domain-Driven Design patterns
- Use Guid as primary keys for all aggregate roots
- Implement proper auditing using ABP's audit interfaces

### Security Requirements
- Password hashing using BCrypt with cost factor 12
- Token hashing using secure hashing algorithm (SHA-256 or better)
- Input validation using Data Annotations and ABP validation
- Proper authorization attributes where needed

### Performance Requirements
- Use AsNoTracking() for read-only specification queries
- Implement proper database indexes on frequently queried fields
- Use async/await pattern consistently
- Optimize queries to avoid N+1 problems

### Code Quality Requirements
- Follow C# naming conventions and ABP Framework patterns
- Include proper XML documentation comments
- Implement proper error handling and logging
- Use readonly fields and immutability where appropriate

## 5. ĐỊNH DẠNG OUTPUT

### OUTPUT REQUIREMENTS

#### Code Files
Tạo tất cả các file code theo structure đã định nghĩa:
1. **Entities**: Aggregate roots và child entities
2. **Value Objects**: Business logic encapsulation
3. **Repository Interfaces**: Data access abstractions
4. **Specifications**: Query optimization patterns
5. **Domain Events**: Business event definitions

#### Documentation Files
1. **`BussinessLogic_Authentication.md`**: Chi tiết business logic và rules
   - Location: `docs/DEV/BussinessLogic_Authentication.md`
   - Content: Business rules, entity behaviors, workflows, invariants
   
2. **Domain Model Overview**: Tổng quan về domain model được tạo

#### File Organization
- Tuân thủ project structure đã detect
- Sử dụng correct namespaces và naming conventions
- Include proper using statements và dependencies

## 6. BUSINESS LOGIC DOCUMENTATION
Tạo file `BussinessLogic_Authentication.md` với nội dung:
- **Business Rules**: Các quy tắc nghiệp vụ được implement trong domain model
- **Entity Behaviors**: Mô tả các hành vi và methods của entities
- **Value Object Logic**: Giải thích logic được encapsulate trong value objects
- **Domain Event Scenarios**: Khi nào domain events được trigger
- **Invariants**: Các điều kiện phải luôn đúng trong domain
- **Validation Rules**: Các rule validation được áp dụng
- **Business Workflows**: Luồng xử lý nghiệp vụ chính

## 7. VALIDATION CHECKLIST

### Entity Validation
- [ ] All aggregate roots inherit from proper ABP base classes
- [ ] Primary keys are consistently Guid type
- [ ] Audit properties are properly configured
- [ ] Business rules are enforced in entity methods
- [ ] Proper encapsulation with private setters

### Value Object Validation
- [ ] Immutable design with readonly properties
- [ ] Proper validation in constructor
- [ ] Equality comparison implemented correctly
- [ ] Business logic encapsulated appropriately

### Repository Validation
- [ ] Interfaces extend IRepository<TEntity, TKey>
- [ ] Custom methods return appropriate types
- [ ] Async patterns used consistently
- [ ] Proper naming conventions followed

### Specification Validation
- [ ] Inherit from Specification<T> base class
- [ ] Proper criteria implementation
- [ ] Performance considerations applied
- [ ] Reusable and composable design

### Domain Events Validation
- [ ] Proper event data structure
- [ ] Clear event naming conventions
- [ ] Appropriate trigger scenarios
- [ ] Required properties included

## 8. CONTEXT TỪNG USER STORY

### User Registration Flow (FR-REG)
- **Entities Involved**: AppUser
- **Value Objects**: EmailAddress, Password
- **Domain Events**: UserRegisteredEventData
- **Business Rules**: Email uniqueness, password complexity
- **Specifications**: None specific for registration

### User Login Flow (FR-LOG)
- **Entities Involved**: AppUser
- **Value Objects**: EmailAddress, Password
- **Domain Events**: UserLoginEventData
- **Business Rules**: Account lockout after 5 failures
- **Specifications**: LockedUsersSpecification, UsersWithFailedLoginsSpecification

### Password Reset Flow (FR-RP)
- **Entities Involved**: AppUser, PasswordResetToken
- **Value Objects**: EmailAddress, Password
- **Domain Events**: PasswordResetRequestedEventData, PasswordResetCompletedEventData
- **Business Rules**: Token expiration (60 minutes), single use tokens
- **Specifications**: ValidPasswordResetTokensForUserSpecification, PasswordResetTokenByHashSpecification

### User Logout Flow (FR-OUT)
- **Entities Involved**: AppUser
- **Domain Events**: UserLogoutEventData
- **Business Rules**: Session invalidation
- **Specifications**: None specific for logout

## 9. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp`):
```bash
dotnet build D:\AI\129719-GenCode\SDLC-ABP-Project\src\backend\AbpApp\AbpApp.csproj
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.