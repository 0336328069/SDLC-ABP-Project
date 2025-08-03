# ABP Multi Layer - Folder Structure

## Tổng quan
Multi Layer Architecture tách biệt rõ ràng các concerns, phù hợp cho dự án enterprise và team lớn. Tuân thủ Clean Architecture và Domain Driven Design.

## Cấu trúc thư mục tổng thể

```
AbpApp/
├── src/                           # 📂 Source code chính
│   ├── AbpApp.Application/        # 🔧 Application Layer
│   ├── AbpApp.Application.Contracts/ # 📋 Application Interfaces & DTOs
│   ├── AbpApp.Domain/             # 🏛️ Domain Layer
│   ├── AbpApp.Domain.Shared/      # 📌 Domain Shared
│   ├── AbpApp.EntityFrameworkCore/ # 💾 Infrastructure Layer
│   ├── AbpApp.HttpApi/            # 🎯 HTTP API Layer
│   ├── AbpApp.HttpApi.Client/     # 📡 HTTP Client
│   ├── AbpApp.Web/                # 🌐 Web/UI Layer
│   └── AbpApp.DbMigrator/         # 🗄️ Database Migrator
├── test/                          # 🧪 Test Projects
│   ├── AbpApp.Application.Tests/
│   ├── AbpApp.Domain.Tests/
│   ├── AbpApp.EntityFrameworkCore.Tests/
│   ├── AbpApp.HttpApi.Tests/
│   ├── AbpApp.Web.Tests/
│   └── AbpApp.TestBase/
├── tools/                         # 🛠️ Tools & Utilities
│   └── AbpApp.DbMigrator/
├── docs/                          # 📚 Documentation
├── scripts/                       # 📝 Build & Deployment Scripts
└── AbpApp.sln                     # Solution file
```

---

## Chi tiết từng Layer

### 🔧 **AbpApp.Application/** - Application Services Layer
**Mục đích**: Chứa business logic, application use cases, coordinate giữa UI và Domain

```
AbpApp.Application/
├── Services/                      # Application Services
│   ├── Auth/                      # Authentication services
│   │   ├── AuthAppService.cs      # Login, logout, token management
│   │   ├── AccountAppService.cs   # Register, profile, email confirmation
│   │   └── PasswordAppService.cs  # Password reset, change password
│   ├── Users/                     # User management services
│   │   ├── UserAppService.cs      # CRUD operations for users
│   │   └── RoleAppService.cs      # Role management
│   └── Common/                    # Common services
│       ├── FileAppService.cs      # File upload/download
│       └── EmailAppService.cs     # Email sending
│
├── Specifications/                # Domain Specifications
│   ├── Users/
│   │   ├── ActiveUsersSpecification.cs
│   │   ├── LockedUsersSpecification.cs
│   │   └── UsersWithPagingSpecification.cs
│   └── Auth/
│       ├── ValidPasswordResetTokensSpecification.cs
│       └── ExpiredTokensSpecification.cs
│
├── BackgroundJobs/               # Background Jobs
│   ├── TokenCleanupJob.cs        # Cleanup expired tokens
│   ├── EmailSendingJob.cs        # Send queued emails
│   └── AuditLogCleanupJob.cs     # Cleanup old audit logs
│
├── EventHandlers/                # Domain Event Handlers
│   ├── UserRegisteredEventHandler.cs
│   ├── PasswordChangedEventHandler.cs
│   └── LoginFailedEventHandler.cs
│
├── Validators/                   # Business Validation
│   ├── Auth/
│   │   ├── RegisterDtoValidator.cs
│   │   └── ResetPasswordDtoValidator.cs
│   └── Users/
│       ├── CreateUserDtoValidator.cs
│       └── UpdateUserDtoValidator.cs
│
├── Mappings/                     # AutoMapper Profiles
│   ├── AuthMappingProfile.cs
│   ├── UserMappingProfile.cs
│   └── CommonMappingProfile.cs
│
├── Helpers/                      # Application Helpers
│   ├── SecurityHelper.cs
│   ├── EmailTemplateHelper.cs
│   └── ValidationHelper.cs
│
├── Extensions/                   # Extension Methods
│   ├── QueryableExtensions.cs
│   └── ServiceCollectionExtensions.cs
│
├── AbpAppApplicationModule.cs    # ABP Module Definition
└── AbpApp.Application.csproj     # Project File
```

### 📋 **AbpApp.Application.Contracts/** - Application Interfaces & DTOs
**Mục đích**: Định nghĩa contracts giữa layers, DTOs cho API

```
AbpApp.Application.Contracts/
├── Services/                     # Service Interfaces
│   ├── Auth/
│   │   ├── IAuthAppService.cs
│   │   ├── IAccountAppService.cs
│   │   └── IPasswordAppService.cs
│   ├── Users/
│   │   ├── IUserAppService.cs
│   │   └── IRoleAppService.cs
│   └── Common/
│       ├── IFileAppService.cs
│       └── IEmailAppService.cs
│
├── DTOs/                         # Data Transfer Objects
│   ├── Auth/
│   │   ├── Input/                # Request DTOs
│   │   │   ├── LoginDto.cs
│   │   │   ├── RegisterDto.cs
│   │   │   ├── ResetPasswordDto.cs
│   │   │   ├── ChangePasswordDto.cs
│   │   │   └── RefreshTokenDto.cs
│   │   └── Output/               # Response DTOs
│   │       ├── LoginResultDto.cs
│   │       ├── UserProfileDto.cs
│   │       └── TokenInfoDto.cs
│   ├── Users/
│   │   ├── Input/
│   │   │   ├── CreateUserDto.cs
│   │   │   ├── UpdateUserDto.cs
│   │   │   ├── GetUsersDto.cs
│   │   │   └── SetUserRolesDto.cs
│   │   └── Output/
│   │       ├── UserDto.cs
│   │       ├── UserListDto.cs
│   │       └── RoleDto.cs
│   └── Common/
│       ├── PagedAndSortedResultRequestDto.cs
│       ├── PagedResultDto.cs
│       ├── FileUploadDto.cs
│       └── ErrorDto.cs
│
├── Permissions/                  # Permission Names
│   ├── AuthPermissions.cs
│   ├── UserPermissions.cs
│   └── CommonPermissions.cs
│
├── Constants/                    # Application Constants
│   ├── AuthConstants.cs
│   ├── ValidationConstants.cs
│   └── CacheKeys.cs
│
├── Enums/                        # Application Enums
│   ├── UserStatus.cs
│   ├── LoginResult.cs
│   └── FileType.cs
│
└── AbpApp.Application.Contracts.csproj
```

### 🏛️ **AbpApp.Domain/** - Domain Layer (Business Core)
**Mục đích**: Core business logic, entities, domain services, business rules

```
AbpApp.Domain/
├── Entities/                     # Domain Entities
│   ├── Identity/                 # Identity Entities
│   │   ├── AppUser.cs           # User aggregate root
│   │   ├── AppRole.cs           # Role entity
│   │   └── UserClaim.cs         # User claims
│   ├── Authentication/           # Authentication Domain
│   │   ├── PasswordResetToken.cs # Password reset tokens
│   │   ├── RefreshToken.cs      # JWT refresh tokens
│   │   ├── LoginAttempt.cs      # Failed login tracking
│   │   └── UserSession.cs       # Active user sessions
│   ├── Audit/                    # Auditing Domain
│   │   ├── AuditLog.cs          # Action audit logs
│   │   └── SecurityEvent.cs     # Security events
│   └── Common/                   # Common Entities
│       ├── BaseAuditedEntity.cs # Base audited entity
│       └── FileUpload.cs        # File metadata
│
├── Services/                     # Domain Services
│   ├── Auth/
│   │   ├── IPasswordManager.cs  # Password management interface
│   │   ├── PasswordManager.cs   # Password hashing, validation
│   │   ├── ITokenManager.cs     # Token management interface
│   │   ├── TokenManager.cs      # Token generation, validation
│   │   └── AuthDomainService.cs # Authentication domain logic
│   ├── Users/
│   │   ├── IUserManager.cs      # User management interface
│   │   ├── UserManager.cs       # User business rules
│   │   └── UserDomainService.cs # User domain logic
│   └── Common/
│       ├── IEmailDomainService.cs
│       └── EmailDomainService.cs
│
├── Repositories/                 # Repository Interfaces
│   ├── IUserRepository.cs        # User repository interface
│   ├── IPasswordResetTokenRepository.cs # Token repository interface
│   ├── IRefreshTokenRepository.cs # Refresh token repository
│   ├── ILoginAttemptRepository.cs # Login attempt repository
│   └── IAuditLogRepository.cs    # Audit repository interface
│
├── Events/                       # Domain Events
│   ├── UserRegisteredEvent.cs
│   ├── PasswordChangedEvent.cs
│   ├── LoginFailedEvent.cs
│   ├── AccountLockedEvent.cs
│   └── TokenExpiredEvent.cs
│
├── Specifications/               # Business Specifications
│   ├── Users/
│   │   ├── ActiveUsersSpecification.cs
│   │   ├── LockedUsersSpecification.cs
│   │   └── RecentUsersSpecification.cs
│   └── Auth/
│       ├── ValidTokensSpecification.cs
│       └── ExpiredTokensSpecification.cs
│
├── ValueObjects/                 # Value Objects
│   ├── Email.cs                 # Email value object
│   ├── Password.cs              # Password value object
│   └── TokenInfo.cs             # Token information
│
├── Exceptions/                   # Domain Exceptions
│   ├── Auth/
│   │   ├── InvalidCredentialsException.cs
│   │   ├── AccountLockedException.cs
│   │   ├── TokenExpiredException.cs
│   │   └── WeakPasswordException.cs
│   ├── Users/
│   │   ├── DuplicateEmailException.cs
│   │   └── UserNotFoundException.cs
│   └── Common/
│       ├── DomainException.cs
│       └── BusinessRuleException.cs
│
├── Constants/                    # Domain Constants
│   ├── DomainConstants.cs
│   ├── BusinessRules.cs
│   └── SecurityConstants.cs
│
├── Extensions/                   # Domain Extensions
│   ├── UserExtensions.cs
│   └── TokenExtensions.cs
│
├── AbpAppDomainModule.cs        # ABP Module Definition
└── AbpApp.Domain.csproj         # Project File
```

### 📌 **AbpApp.Domain.Shared/** - Shared Domain
**Mục đích**: Shared constants, enums, được sử dụng ở nhiều layers

```
AbpApp.Domain.Shared/
├── Constants/                    # Shared Constants
│   ├── AbpAppConstants.cs       # Application constants
│   ├── AuthConstants.cs         # Authentication constants
│   ├── ValidationConstants.cs   # Validation constants
│   └── CacheConstants.cs        # Cache key constants
│
├── Enums/                        # Shared Enums
│   ├── UserStatus.cs            # User status enum
│   ├── LoginResult.cs           # Login result enum
│   ├── TokenType.cs             # Token type enum
│   └── AuditAction.cs           # Audit action enum
│
├── Localization/                 # Localization Resources
│   ├── AbpAppResource.cs        # Localization resource
│   └── Resources/
│       ├── en.json              # English translations
│       ├── vi.json              # Vietnamese translations
│       └── zh.json              # Chinese translations
│
├── Extensions/                   # Extension Methods
│   ├── StringExtensions.cs
│   ├── DateTimeExtensions.cs
│   └── EnumExtensions.cs
│
├── AbpAppDomainSharedModule.cs  # ABP Module Definition
└── AbpApp.Domain.Shared.csproj  # Project File
```

### 💾 **AbpApp.EntityFrameworkCore/** - Infrastructure Layer
**Mục đích**: Data access implementation, EF Core context, repositories

```
AbpApp.EntityFrameworkCore/
├── EntityConfigurations/         # EF Entity Configurations
│   ├── Identity/
│   │   ├── AppUserConfiguration.cs
│   │   └── AppRoleConfiguration.cs
│   ├── Authentication/
│   │   ├── PasswordResetTokenConfiguration.cs
│   │   ├── RefreshTokenConfiguration.cs
│   │   └── LoginAttemptConfiguration.cs
│   └── Common/
│       ├── AuditLogConfiguration.cs
│       └── FileUploadConfiguration.cs
│
├── Repositories/                 # Repository Implementations
│   ├── Users/
│   │   └── EfCoreUserRepository.cs
│   ├── Authentication/
│   │   ├── EfCorePasswordResetTokenRepository.cs
│   │   ├── EfCoreRefreshTokenRepository.cs
│   │   └── EfCoreLoginAttemptRepository.cs
│   └── Common/
│       └── EfCoreAuditLogRepository.cs
│
├── Migrations/                   # EF Core Migrations
│   ├── 20240101120000_Initial.cs
│   ├── 20240102130000_AddPasswordReset.cs
│   ├── 20240103140000_AddRefreshTokens.cs
│   └── 20240104150000_AddAuditTables.cs
│
├── Seed/                         # Database Seeding
│   ├── AbpAppDbContextSeed.cs   # Main seed orchestrator
│   ├── Identity/
│   │   ├── UserSeed.cs          # Seed users
│   │   └── RoleSeed.cs          # Seed roles
│   └── Common/
│       └── PermissionSeed.cs    # Seed permissions
│
├── Extensions/                   # EF Extensions
│   ├── DbContextExtensions.cs
│   └── QueryableExtensions.cs
│
├── AbpAppDbContext.cs           # Main DbContext
├── AbpAppDbContextFactory.cs    # Design-time factory
├── AbpAppEntityFrameworkCoreModule.cs # ABP Module
└── AbpApp.EntityFrameworkCore.csproj # Project File
```

### 🎯 **AbpApp.HttpApi/** - HTTP API Layer
**Mục đích**: REST API controllers, HTTP-specific logic

```
AbpApp.HttpApi/
├── Controllers/                  # API Controllers
│   ├── Auth/
│   │   ├── AuthController.cs    # Login, logout, refresh
│   │   ├── AccountController.cs # Register, profile, confirmation
│   │   └── PasswordController.cs # Password reset, change
│   ├── Users/
│   │   ├── UserController.cs    # User CRUD operations
│   │   └── RoleController.cs    # Role management
│   ├── Common/
│   │   ├── FileController.cs    # File upload/download
│   │   └── HealthController.cs  # Health check
│   └── AbpAppControllerBase.cs  # Base controller
│
├── Filters/                      # Action Filters
│   ├── ValidationFilter.cs      # Model validation
│   ├── AuditFilter.cs           # Action auditing
│   ├── RateLimitFilter.cs       # Rate limiting
│   └── SecurityHeadersFilter.cs # Security headers
│
├── Middlewares/                  # Custom Middlewares
│   ├── ErrorHandlingMiddleware.cs # Global error handling
│   ├── RequestLoggingMiddleware.cs # Request logging
│   └── SecurityMiddleware.cs     # Security enhancements
│
├── Extensions/                   # API Extensions
│   ├── ServiceCollectionExtensions.cs
│   └── ApplicationBuilderExtensions.cs
│
├── AbpAppHttpApiModule.cs       # ABP Module Definition
└── AbpApp.HttpApi.csproj        # Project File
```

### 📡 **AbpApp.HttpApi.Client/** - HTTP Client
**Mục đích**: Generated client proxies cho external applications

```
AbpApp.HttpApi.Client/
├── ClientProxies/               # Generated Client Proxies
│   ├── AuthClientProxy.cs
│   ├── UserClientProxy.cs
│   └── FileClientProxy.cs
│
├── Extensions/
│   └── ServiceCollectionExtensions.cs
│
├── AbpAppHttpApiClientModule.cs
└── AbpApp.HttpApi.Client.csproj
```

### 🌐 **AbpApp.Web/** - Web/UI Layer
**Mục đích**: User interface, web pages, client-side assets

```
AbpApp.Web/
├── Pages/                       # Razor Pages
│   ├── Auth/
│   │   ├── Login.cshtml
│   │   ├── Register.cshtml
│   │   └── ForgotPassword.cshtml
│   ├── Users/
│   │   ├── Index.cshtml         # User list
│   │   ├── Create.cshtml        # Create user
│   │   └── Edit.cshtml          # Edit user
│   └── Shared/
│       ├── _Layout.cshtml
│       └── _ViewImports.cshtml
│
├── Controllers/                 # MVC Controllers
│   ├── HomeController.cs
│   └── ErrorController.cs
│
├── Models/                      # View Models
│   ├── Auth/
│   │   ├── LoginViewModel.cs
│   │   └── RegisterViewModel.cs
│   └── Users/
│       └── UserViewModel.cs
│
├── wwwroot/                     # Static Files
│   ├── css/
│   │   ├── site.css
│   │   └── bootstrap.min.css
│   ├── js/
│   │   ├── site.js
│   │   └── app.js
│   ├── images/
│   ├── fonts/
│   └── uploads/
│
├── Components/                  # View Components
│   ├── Navigation/
│   └── UserProfile/
│
├── Extensions/
│   └── ServiceCollectionExtensions.cs
│
├── AbpAppWebModule.cs
└── AbpApp.Web.csproj
```

---

## 🧪 **test/** - Test Projects

### **AbpApp.Application.Tests/**
```
AbpApp.Application.Tests/
├── Services/
│   ├── Auth/
│   │   ├── AuthAppServiceTests.cs
│   │   └── PasswordAppServiceTests.cs
│   └── Users/
│       └── UserAppServiceTests.cs
├── Specifications/
├── Validators/
└── AbpAppApplicationTestModule.cs
```

### **AbpApp.Domain.Tests/**
```
AbpApp.Domain.Tests/
├── Entities/
├── Services/
├── Specifications/
├── ValueObjects/
└── AbpAppDomainTestModule.cs
```

### **AbpApp.EntityFrameworkCore.Tests/**
```
AbpApp.EntityFrameworkCore.Tests/
├── Repositories/
├── Migrations/
└── AbpAppEntityFrameworkCoreTestModule.cs
```

### **AbpApp.HttpApi.Tests/**
```
AbpApp.HttpApi.Tests/
├── Controllers/
├── Integration/
└── AbpAppHttpApiTestModule.cs
```

### **AbpApp.TestBase/**
```
AbpApp.TestBase/
├── AbpAppTestBase.cs
├── AbpAppTestBaseModule.cs
└── TestData/
```

---

## 🛠️ **tools/** - Tools & Utilities

### **AbpApp.DbMigrator/**
```
AbpApp.DbMigrator/
├── Program.cs
├── DbMigratorHostedService.cs
├── AbpAppDbMigratorModule.cs
├── appsettings.json
└── AbpApp.DbMigrator.csproj
```

---

## Dependency Flow (Quan trọng!)

```
┌─────────────────┐    ┌─────────────────┐
│   Web Layer     │────│  HttpApi Layer  │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────┬───────────┘
                     │
         ┌─────────────────┐
         │ Application     │
         │ Contracts       │
         └─────────────────┘
                     │
         ┌─────────────────┐
         │ Application     │
         │ Layer          │
         └─────────────────┘
                     │
         ┌─────────────────┐
         │ Domain Layer    │
         └─────────────────┘
                     │
         ┌─────────────────┐
         │ Domain Shared   │
         └─────────────────┘
```

**Quy tắc Dependency:**
- ✅ Outer layers có thể depend vào inner layers
- ❌ Inner layers KHÔNG được depend vào outer layers
- ✅ Application layer depend vào Domain
- ❌ Domain KHÔNG depend vào Application
- ✅ Infrastructure implement interfaces từ Domain

---

## Ưu điểm Multi Layer

### 🎯 **Separation of Concerns**
- Mỗi layer có trách nhiệm rõ ràng
- Dễ maintain và mở rộng
- Testability cao

### 🔧 **Scalability**
- Team có thể work parallel trên các layer khác nhau
- Dễ thêm features mới
- Performance optimization riêng từng layer

### 🛡️ **Security & Stability**
- Dependency inversion principle
- Business logic được protect ở Domain layer
- Easy to implement cross-cutting concerns

### 🧪 **Testing**
- Unit test riêng từng layer
- Integration test
- End-to-end test

---

## Nhược điểm Multi Layer

### 📈 **Complexity**
- Learning curve cao
- Over-engineering cho dự án nhỏ
- Nhiều boilerplate code

### ⏱️ **Development Time**
- Setup initial phức tạp
- Cần hiểu rõ architecture
- Nhiều file và folder để maintain

---

## Khi nào sử dụng Multi Layer

### ✅ **Phù hợp khi:**
- 👥 Team lớn (5+ developers)
- 📊 Enterprise applications
- 🔄 Requirements thay đổi thường xuyên
- 🎯 Long-term maintenance
- 🧪 High testability requirements
- 🌐 Microservices architecture
- 📱 Multiple UI clients (Web, Mobile, Desktop)

### ❌ **Không phù hợp khi:**
- 👤 Solo developer hoặc team nhỏ
- ⏱️ Prototype hoặc POC
- 📊 Simple CRUD applications
- 🚀 Tight deadline
- 💰 Limited budget

---

## Best Practices

### 🎯 **General**
- Tuân thủ SOLID principles
- Use dependency injection
- Implement proper logging
- Apply security best practices

### 📊 **Domain Layer**
- Rich domain models
- Business rules trong entities
- Domain events cho loose coupling
- Specification pattern cho complex queries

### 🔧 **Application Layer**
- Thin application services
- Use DTOs cho data transfer
- Implement proper validation
- Handle cross-cutting concerns

### 💾 **Infrastructure Layer**
- Repository pattern với generic base
- Unit of Work pattern
- Proper indexing và query optimization
- Migration scripts cho production

### 🎯 **API Layer**
- RESTful API design
- Proper HTTP status codes
- API versioning
- Rate limiting và throttling
- Comprehensive documentation (Swagger)

### 🌐 **Web Layer**
- Responsive design
- Client-side validation
- Proper error handling
- Performance optimization (bundling, minification)