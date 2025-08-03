# ABP Single Layer - Folder Structure

## Tổng quan

Single Layer Architecture tổ chức tất cả code trong một project duy nhất, phù hợp cho dự án nhỏ và medium size.

## Cấu trúc thư mục

```
AbpApp/
├── Controllers/                    # 🎯 API Controllers - REST Endpoints
│   ├── Auth/                      # Authentication related controllers
│   │   ├── AuthController.cs      # Login, logout, refresh token
│   │   ├── AccountController.cs   # Register, confirm email, profile
│   │   └── PasswordController.cs  # Password reset, change password
│   ├── User/                      # User management controllers
│   │   ├── UserController.cs      # CRUD operations for users
│   │   └── RoleController.cs      # Role management
│   └── Common/                    # Common controllers
│       ├── FileController.cs      # File upload/download
│       └── HealthController.cs    # Health check endpoints
│
├── Services/                      # 🔧 Application Services - Business Logic
│   ├── Interfaces/                # Service contracts
│   │   ├── IAuthService.cs        # Authentication service interface
│   │   ├── IUserService.cs        # User service interface
│   │   ├── IEmailService.cs       # Email service interface
│   │   └── IFileService.cs        # File service interface
│   ├── Implementations/           # Service implementations
│   │   ├── AuthService.cs         # Authentication business logic
│   │   ├── UserService.cs         # User management business logic
│   │   ├── EmailService.cs        # Email sending logic
│   │   └── FileService.cs         # File handling logic
│   └── BackgroundServices/        # Background jobs
│       ├── TokenCleanupService.cs # Cleanup expired tokens
│       └── EmailQueueService.cs   # Process email queue
│
├── Entities/                      # 📊 Domain Entities - Database Models
│   ├── Identity/                  # Identity related entities
│   │   ├── AppUser.cs            # User entity with ABP identity
│   │   ├── AppRole.cs            # Role entity
│   │   └── UserToken.cs          # User tokens (refresh, reset)
│   ├── Authentication/            # Authentication entities
│   │   ├── PasswordResetToken.cs # Password reset tokens
│   │   ├── LoginAttempt.cs       # Failed login tracking
│   │   └── UserSession.cs        # User session tracking
│   ├── Audit/                     # Auditing entities
│   │   ├── AuditLog.cs           # Action audit logs
│   │   └── SecurityLog.cs        # Security events log
│   └── Common/                    # Common entities
│       ├── BaseEntity.cs         # Base entity with common fields
│       └── FileUpload.cs         # File metadata entity
│
├── DTOs/                         # 📋 Data Transfer Objects - API Models
│   ├── Auth/                     # Authentication DTOs
│   │   ├── Input/                # Request DTOs
│   │   │   ├── LoginDto.cs       # Login request
│   │   │   ├── RegisterDto.cs    # Registration request
│   │   │   ├── ResetPasswordDto.cs # Password reset request
│   │   │   └── ChangePasswordDto.cs # Change password request
│   │   └── Output/               # Response DTOs
│   │       ├── LoginResultDto.cs # Login response with tokens
│   │       └── UserProfileDto.cs # User profile data
│   ├── User/                     # User management DTOs
│   │   ├── Input/
│   │   │   ├── CreateUserDto.cs  # Create user request
│   │   │   ├── UpdateUserDto.cs  # Update user request
│   │   │   └── GetUsersDto.cs    # User list filters
│   │   └── Output/
│   │       ├── UserDto.cs        # User detail response
│   │       └── UserListDto.cs    # User list item
│   └── Common/                   # Common DTOs
│       ├── PagedResultDto.cs     # Paginated response wrapper
│       ├── ErrorDto.cs           # Error response format
│       └── FileUploadDto.cs      # File upload response
│
├── Repositories/                 # 💾 Data Access Layer - Database Operations
│   ├── Interfaces/               # Repository contracts
│   │   ├── IUserRepository.cs    # User data access interface
│   │   ├── IPasswordResetTokenRepository.cs # Token repository interface
│   │   └── IAuditLogRepository.cs # Audit log interface
│   ├── Implementations/          # Repository implementations
│   │   ├── UserRepository.cs     # User data access implementation
│   │   ├── PasswordResetTokenRepository.cs # Token repository
│   │   └── AuditLogRepository.cs # Audit log repository
│   └── Specifications/           # Query specifications
│       ├── UserSpecifications.cs # User query specifications
│       └── TokenSpecifications.cs # Token query specifications
│
├── Data/                        # 🗄️ Database Context & Configurations
│   ├── AbpAppDbContext.cs       # EF Core DbContext
│   ├── Migrations/              # EF Core migrations
│   │   ├── 20240101120000_Initial.cs # Initial migration
│   │   ├── 20240102130000_AddPasswordReset.cs # Password reset feature
│   │   └── 20240103140000_AddAuditTables.cs # Audit logging
│   ├── Configurations/          # Entity configurations
│   │   ├── UserConfiguration.cs # User entity configuration
│   │   ├── TokenConfiguration.cs # Token entity configuration
│   │   └── AuditConfiguration.cs # Audit entity configuration
│   └── Seed/                    # Database seeding
│       ├── SeedDataBuilder.cs   # Seed data builder
│       ├── DefaultUsers.cs      # Default user accounts
│       └── DefaultRoles.cs      # Default roles and permissions
│
├── Models/                      # 🎨 View Models (if using MVC/Razor Pages)
│   ├── Auth/
│   │   ├── LoginViewModel.cs
│   │   ├── RegisterViewModel.cs
│   │   └── ForgotPasswordViewModel.cs
│   └── User/
│       ├── UserProfileViewModel.cs
│       └── UserListViewModel.cs
│
├── Helpers/                     # 🛠️ Utility Classes - Common Functions
│   ├── Security/                # Security utilities
│   │   ├── PasswordHelper.cs    # Password hashing, validation
│   │   ├── TokenGenerator.cs    # JWT, reset token generation
│   │   └── EncryptionHelper.cs  # Data encryption utilities
│   ├── Email/                   # Email utilities
│   │   ├── EmailTemplateHelper.cs # Email template processing
│   │   └── SmtpHelper.cs        # SMTP client wrapper
│   ├── Validation/              # Validation utilities
│   │   ├── ValidationHelper.cs  # Common validations
│   │   └── BusinessRuleHelper.cs # Business rule validations
│   └── Common/                  # General utilities
│       ├── DateTimeHelper.cs    # Date/time operations
│       ├── StringHelper.cs      # String manipulations
│       └── FileHelper.cs        # File operations
│
├── Constants/                   # 📌 Application Constants
│   ├── AuthConstants.cs         # Authentication constants
│   ├── ValidationConstants.cs   # Validation messages, rules
│   ├── CacheKeys.cs            # Cache key constants
│   ├── ClaimTypes.cs           # Custom claim types
│   └── AppSettings.cs          # Configuration keys
│
├── Exceptions/                  # ❌ Custom Exceptions
│   ├── Authentication/         # Auth related exceptions
│   │   ├── InvalidCredentialsException.cs
│   │   ├── AccountLockedException.cs
│   │   └── TokenExpiredException.cs
│   ├── Business/              # Business logic exceptions
│   │   ├── DuplicateEmailException.cs
│   │   ├── WeakPasswordException.cs
│   │   └── InvalidOperationException.cs
│   └── Common/                # Common exceptions
│       ├── ValidationException.cs
│       ├── NotFoundException.cs
│       └── UnauthorizedException.cs
│
├── Configurations/             # ⚙️ Startup & Service Configurations
│   ├── AuthConfiguration.cs    # Authentication setup (JWT, cookies)
│   ├── DatabaseConfiguration.cs # EF Core configuration
│   ├── SwaggerConfiguration.cs # API documentation setup
│   ├── CorsConfiguration.cs    # CORS policy setup
│   ├── CacheConfiguration.cs   # Caching setup (Redis/Memory)
│   └── EmailConfiguration.cs   # Email service setup
│
├── Middlewares/               # 🔀 Custom Middlewares
│   ├── ErrorHandlingMiddleware.cs # Global error handling
│   ├── SecurityHeadersMiddleware.cs # Security headers
│   ├── RequestLoggingMiddleware.cs # Request/response logging
│   ├── RateLimitingMiddleware.cs # API rate limiting
│   └── TenantResolutionMiddleware.cs # Multi-tenant support
│
├── Validators/                # ✅ Input Validation
│   ├── Auth/
│   │   ├── LoginDtoValidator.cs
│   │   ├── RegisterDtoValidator.cs
│   │   └── ResetPasswordDtoValidator.cs
│   ├── User/
│   │   ├── CreateUserDtoValidator.cs
│   │   └── UpdateUserDtoValidator.cs
│   └── Common/
│       ├── BaseValidator.cs
│       └── ValidationExtensions.cs
│
├── Extensions/                # 🔧 Extension Methods
│   ├── ServiceCollectionExtensions.cs # DI container extensions
│   ├── ClaimsPrincipalExtensions.cs # User claims extensions
│   ├── StringExtensions.cs    # String manipulation extensions
│   └── DateTimeExtensions.cs  # DateTime utility extensions
│
├── Filters/                   # 🎯 Action Filters
│   ├── ValidationFilter.cs    # Model validation filter
│   ├── AuthorizationFilter.cs # Custom authorization
│   ├── AuditFilter.cs        # Action auditing
│   └── RateLimitFilter.cs    # API rate limiting
│
├── Mappings/                  # 🗺️ Object Mapping Profiles
│   ├── AuthMappingProfile.cs  # Auth entities ↔ DTOs
│   ├── UserMappingProfile.cs  # User entities ↔ DTOs
│   └── CommonMappingProfile.cs # Common mappings
│
├── Jobs/                      # ⏰ Background Jobs
│   ├── TokenCleanupJob.cs     # Cleanup expired tokens
│   ├── EmailSendingJob.cs     # Send queued emails
│   ├── AuditLogCleanupJob.cs  # Cleanup old audit logs
│   └── UserInactivityJob.cs   # Handle inactive users
│
├── Resources/                 # 📚 Localization & Static Files
│   ├── Localization/          # Multi-language support
│   │   ├── en.json           # English translations
│   │   ├── vi.json           # Vietnamese translations
│   │   └── LocalizationKeys.cs # Translation key constants
│   ├── Templates/             # Email/SMS templates
│   │   ├── WelcomeEmail.html
│   │   ├── PasswordResetEmail.html
│   │   └── AccountLockedEmail.html
│   └── Static/                # Static files
│       ├── css/
│       ├── js/
│       └── images/
│
├── Tests/                     # 🧪 Unit Tests (optional in single layer)
│   ├── Services/
│   ├── Controllers/
│   ├── Repositories/
│   └── Helpers/
│
├── wwwroot/                   # 🌐 Web Static Files (if web app)
│   ├── css/
│   ├── js/
│   ├── images/
│   └── uploads/
│
├── appsettings.json           # ⚙️ Application Configuration
├── appsettings.Development.json # Development settings
├── appsettings.Production.json # Production settings
├── Program.cs                 # 🚀 Application Entry Point
├── Startup.cs                 # Application startup configuration
└── AbpApp.csproj             # Project file
```

## Mục đích từng thư mục

### 🎯 **Controllers/**

- **Mục đích**: Xử lý HTTP requests, định nghĩa API endpoints
- **Chức năng**: Routing, model binding, response formatting
- **Quy tắc**: Thin controllers, delegate business logic to services

### 🔧 **Services/**

- **Mục đích**: Chứa business logic, application rules
- **Chức năng**: Xử lý nghiệp vụ, coordinate giữa các layer
- **Quy tắc**: Interface segregation, single responsibility

### 📊 **Entities/**

- **Mục đích**: Domain models, database structure
- **Chức năng**: Định nghĩa data structure, relationships
- **Quy tắc**: Rich domain models, encapsulation

### 📋 **DTOs/**

- **Mục đích**: Data contracts cho API, tách biệt internal models
- **Chức năng**: Input validation, output formatting
- **Quy tắc**: Flat structure, validation attributes

### 💾 **Repositories/**

- **Mục đích**: Data access abstraction
- **Chức năng**: CRUD operations, complex queries
- **Quy tắc**: Repository pattern, specification pattern

### 🗄️ **Data/**

- **Mục đích**: Database context, migrations, configurations
- **Chức năng**: EF Core setup, schema management
- **Quy tắc**: Code-first approach, proper indexing

### 🛠️ **Helpers/**

- **Mục đích**: Utility functions, common operations
- **Chức năng**: Reusable logic, cross-cutting concerns
- **Quy tắc**: Stateless, pure functions when possible

### 📌 **Constants/**

- **Mục đích**: Application-wide constants, magic numbers
- **Chức năng**: Configuration values, enums
- **Quy tắc**: Type-safe constants, meaningful names

### ❌ **Exceptions/**

- **Mục đích**: Custom exception types
- **Chức năng**: Specific error handling, error context
- **Quy tắc**: Inherit from base exceptions, meaningful messages

### ⚙️ **Configurations/**

- **Mục đích**: Service registrations, startup logic
- **Chức năng**: DI setup, middleware configuration
- **Quy tắc**: Modular configuration, environment-specific
