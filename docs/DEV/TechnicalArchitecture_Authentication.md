# Technical Architecture: Authentication Feature v1.0

## 1. Architecture Overview

### 1.1 System Context
The Authentication feature is a foundational component of the ABP Enterprise Application, providing secure user identity management capabilities. It follows Domain-Driven Design (DDD) principles and Clean Architecture patterns, integrating seamlessly with the existing ABP Framework 8.3.0 and Next.js 14+ technology stack.

### 1.2 Architecture Principles
- **Security First**: All authentication flows implement industry-standard security practices
- **Separation of Concerns**: Clear boundaries between domain logic, application services, and infrastructure
- **Scalability**: Designed to handle 1,000+ concurrent authentication requests
- **Maintainability**: Modular design following ABP Framework conventions
- **Performance**: Sub-800ms response times for all authentication operations

## 2. System Architecture

### 2.1 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Frontend Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   Login Page    │  │  Register Page  │  │ Reset Password  │ │
│  │   (Next.js)     │  │   (Next.js)     │  │   (Next.js)     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
│           │                     │                     │         │
└───────────┼─────────────────────┼─────────────────────┼─────────┘
            │                     │                     │
┌───────────┼─────────────────────┼─────────────────────┼─────────┐
│           │        API Gateway / HTTP Layer           │         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ AuthController  │  │ AccountController│  │ TokenController │ │
│  │   (ASP.NET)     │  │   (ASP.NET)     │  │   (ASP.NET)     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└───────────┼─────────────────────┼─────────────────────┼─────────┘
            │                     │                     │
┌───────────┼─────────────────────┼─────────────────────┼─────────┐
│           │        Application Layer                  │         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ AuthAppService  │  │AccountAppService│  │ TokenAppService │ │
│  │     (ABP)       │  │     (ABP)       │  │     (ABP)       │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└───────────┼─────────────────────┼─────────────────────┼─────────┘
            │                     │                     │
┌───────────┼─────────────────────┼─────────────────────┼─────────┐
│           │         Domain Layer                      │         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   User Entity   │  │ Session Entity  │  │ResetToken Entity│ │
│  │   (Domain)      │  │   (Domain)      │  │   (Domain)      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└───────────┼─────────────────────┼─────────────────────┼─────────┘
            │                     │                     │
┌───────────┼─────────────────────┼─────────────────────┼─────────┐
│           │      Infrastructure Layer                 │         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   SQL Server    │  │     Redis       │  │  Email Service  │ │
│  │   (Database)    │  │   (Caching)     │  │   (SendGrid)    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Component Interaction Flow

#### 2.2.1 User Registration Flow
```
Frontend → AuthController → AuthAppService → UserDomainService → UserRepository → Database
                                          ↓
                                    EmailService → External Email Provider
```

#### 2.2.2 User Login Flow
```
Frontend → AuthController → AuthAppService → UserDomainService → UserRepository → Database
                                          ↓                              ↓
                                    SessionService ← Redis Cache ← SessionRepository
```

#### 2.2.3 Password Reset Flow
```
Frontend → TokenController → TokenAppService → ResetTokenDomainService → TokenRepository → Database
                                            ↓
                                      EmailService → External Email Provider
```

## 3. Domain Architecture

### 3.1 Domain Model

#### 3.1.1 User Aggregate
```csharp
public class User : AggregateRoot<Guid>
{
    public string Email { get; private set; }
    public string PasswordHash { get; private set; }
    public UserStatus Status { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime? LastLoginAt { get; private set; }
    public int FailedLoginAttempts { get; private set; }
    public DateTime? LockedUntil { get; private set; }
    
    // Domain methods
    public void ChangePassword(string newPasswordHash);
    public void LockAccount(TimeSpan lockDuration);
    public void UnlockAccount();
    public void RecordFailedLogin();
    public void RecordSuccessfulLogin();
}
```

#### 3.1.2 Session Aggregate
```csharp
public class Session : AggregateRoot<Guid>
{
    public Guid UserId { get; private set; }
    public string TokenHash { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime ExpiresAt { get; private set; }
    public bool IsActive { get; private set; }
    
    // Domain methods
    public void Expire();
    public bool IsExpired();
    public void Refresh(TimeSpan duration);
}
```

#### 3.1.3 PasswordResetToken Aggregate
```csharp
public class PasswordResetToken : AggregateRoot<Guid>
{
    public Guid UserId { get; private set; }
    public string TokenHash { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime ExpiresAt { get; private set; }
    public bool IsUsed { get; private set; }
    
    // Domain methods
    public void MarkAsUsed();
    public bool IsExpired();
    public bool IsValid();
}
```

### 3.2 Domain Services

#### 3.2.1 UserDomainService
```csharp
public class UserDomainService : DomainService
{
    public async Task<User> CreateUserAsync(string email, string password);
    public async Task<bool> ValidateCredentialsAsync(string email, string password);
    public async Task<User> FindByEmailAsync(string email);
    public async Task LockUserAccountAsync(Guid userId, TimeSpan duration);
}
```

#### 3.2.2 SessionDomainService
```csharp
public class SessionDomainService : DomainService
{
    public async Task<Session> CreateSessionAsync(Guid userId);
    public async Task<Session> ValidateSessionAsync(string token);
    public async Task ExpireSessionAsync(Guid sessionId);
    public async Task CleanupExpiredSessionsAsync();
}
```

#### 3.2.3 PasswordResetDomainService
```csharp
public class PasswordResetDomainService : DomainService
{
    public async Task<PasswordResetToken> CreateResetTokenAsync(Guid userId);
    public async Task<bool> ValidateResetTokenAsync(string token);
    public async Task ResetPasswordAsync(string token, string newPassword);
}
```

## 4. Application Layer Architecture

### 4.1 Application Services

#### 4.1.1 AuthAppService
```csharp
public class AuthAppService : ApplicationService, IAuthAppService
{
    public async Task<LoginResultDto> LoginAsync(LoginInputDto input);
    public async Task<RegisterResultDto> RegisterAsync(RegisterInputDto input);
    public async Task LogoutAsync();
    public async Task<RefreshTokenResultDto> RefreshTokenAsync(RefreshTokenInputDto input);
}
```

#### 4.1.2 AccountAppService
```csharp
public class AccountAppService : ApplicationService, IAccountAppService
{
    public async Task<UserProfileDto> GetCurrentUserAsync();
    public async Task ChangePasswordAsync(ChangePasswordInputDto input);
    public async Task UpdateProfileAsync(UpdateProfileInputDto input);
}
```

#### 4.1.3 PasswordResetAppService
```csharp
public class PasswordResetAppService : ApplicationService, IPasswordResetAppService
{
    public async Task RequestPasswordResetAsync(RequestPasswordResetInputDto input);
    public async Task ResetPasswordAsync(ResetPasswordInputDto input);
    public async Task<bool> ValidateResetTokenAsync(string token);
}
```

### 4.2 DTOs (Data Transfer Objects)

#### 4.2.1 Input DTOs
```csharp
public class LoginInputDto
{
    [Required, EmailAddress]
    public string Email { get; set; }
    
    [Required, MinLength(8)]
    public string Password { get; set; }
    
    public bool RememberMe { get; set; }
}

public class RegisterInputDto
{
    [Required, EmailAddress]
    public string Email { get; set; }
    
    [Required, MinLength(8)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$")]
    public string Password { get; set; }
    
    [Required, Compare(nameof(Password))]
    public string ConfirmPassword { get; set; }
}
```

#### 4.2.2 Output DTOs
```csharp
public class LoginResultDto
{
    public string AccessToken { get; set; }
    public string RefreshToken { get; set; }
    public DateTime ExpiresAt { get; set; }
    public UserProfileDto User { get; set; }
}

public class UserProfileDto
{
    public Guid Id { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? LastLoginAt { get; set; }
}
```

## 5. Infrastructure Architecture

### 5.1 Database Schema

#### 5.1.1 Users Table
```sql
CREATE TABLE Users (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Email NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(512) NOT NULL,
    Status INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    LastLoginAt DATETIME2 NULL,
    FailedLoginAttempts INT NOT NULL DEFAULT 0,
    LockedUntil DATETIME2 NULL,
    
    INDEX IX_Users_Email (Email),
    INDEX IX_Users_Status (Status)
);
```

#### 5.1.2 Sessions Table
```sql
CREATE TABLE Sessions (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    TokenHash NVARCHAR(512) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    ExpiresAt DATETIME2 NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX IX_Sessions_UserId (UserId),
    INDEX IX_Sessions_TokenHash (TokenHash),
    INDEX IX_Sessions_ExpiresAt (ExpiresAt)
);
```

#### 5.1.3 PasswordResetTokens Table
```sql
CREATE TABLE PasswordResetTokens (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    TokenHash NVARCHAR(512) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    ExpiresAt DATETIME2 NOT NULL,
    IsUsed BIT NOT NULL DEFAULT 0,
    
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX IX_PasswordResetTokens_UserId (UserId),
    INDEX IX_PasswordResetTokens_TokenHash (TokenHash),
    INDEX IX_PasswordResetTokens_ExpiresAt (ExpiresAt)
);
```

### 5.2 Caching Strategy

#### 5.2.1 Redis Cache Structure
```
auth:session:{sessionId} → Session data (TTL: 24 hours)
auth:user:{userId} → User profile cache (TTL: 1 hour)
auth:failed_attempts:{email} → Failed login attempts (TTL: 15 minutes)
auth:locked_accounts:{userId} → Account lock status (TTL: 15 minutes)
```

#### 5.2.2 Cache Implementation
```csharp
public class AuthCacheService : IAuthCacheService
{
    private readonly IDistributedCache _cache;
    
    public async Task CacheSessionAsync(Session session, TimeSpan expiry);
    public async Task<Session> GetCachedSessionAsync(string sessionId);
    public async Task InvalidateSessionAsync(string sessionId);
    public async Task CacheUserAsync(User user, TimeSpan expiry);
    public async Task InvalidateUserCacheAsync(Guid userId);
}
```

### 5.3 Email Service Integration

#### 5.3.1 Email Service Interface
```csharp
public interface IEmailService
{
    Task SendPasswordResetEmailAsync(string toEmail, string resetLink);
    Task SendWelcomeEmailAsync(string toEmail, string userName);
    Task SendAccountLockedEmailAsync(string toEmail, DateTime unlockTime);
}
```

#### 5.3.2 SendGrid Implementation
```csharp
public class SendGridEmailService : IEmailService
{
    private readonly ISendGridClient _sendGridClient;
    private readonly IConfiguration _configuration;
    
    public async Task SendPasswordResetEmailAsync(string toEmail, string resetLink)
    {
        var templateId = _configuration["SendGrid:PasswordResetTemplateId"];
        var dynamicData = new { reset_link = resetLink };
        
        await SendTemplateEmailAsync(toEmail, templateId, dynamicData);
    }
}
```

## 6. Security Architecture

### 6.1 Authentication Flow Security

#### 6.1.1 Password Security
- **Hashing Algorithm**: BCrypt with cost factor 12
- **Salt**: Automatically generated per password
- **Validation**: Minimum 8 characters, uppercase, lowercase, number

#### 6.1.2 Session Security
- **Token Format**: JWT with RS256 signing
- **Expiration**: 24 hours for access tokens, 7 days for refresh tokens
- **Storage**: HttpOnly cookies for web, secure storage for mobile

#### 6.1.3 Password Reset Security
- **Token Generation**: Cryptographically secure random tokens
- **Token Expiration**: 60 minutes
- **One-time Use**: Tokens invalidated after successful use
- **Rate Limiting**: Maximum 3 reset requests per hour per email

### 6.2 Security Controls

#### 6.2.1 Rate Limiting
```csharp
[RateLimit(Requests = 5, Period = "1m")]
public async Task<LoginResultDto> LoginAsync(LoginInputDto input)
{
    // Implementation
}

[RateLimit(Requests = 3, Period = "1h")]
public async Task RequestPasswordResetAsync(RequestPasswordResetInputDto input)
{
    // Implementation
}
```

#### 6.2.2 Account Lockout
- **Trigger**: 5 failed login attempts within 15 minutes
- **Duration**: 15 minutes lockout period
- **Reset**: Successful login or manual unlock by admin

#### 6.2.3 Input Validation
```csharp
public class LoginInputDtoValidator : AbstractValidator<LoginInputDto>
{
    public LoginInputDtoValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(256);
            
        RuleFor(x => x.Password)
            .NotEmpty()
            .MinimumLength(8)
            .MaximumLength(128);
    }
}
```

## 7. Performance Architecture

### 7.1 Performance Requirements
- **API Response Time**: < 800ms (95th percentile)
- **Concurrent Users**: 1,000+ simultaneous authentication requests
- **Database Queries**: Optimized with proper indexing
- **Caching**: Redis for session and user data

### 7.2 Performance Optimizations

#### 7.2.1 Database Optimizations
- Indexed columns: Email, UserId, TokenHash, ExpiresAt
- Connection pooling with Entity Framework Core
- Read replicas for user profile queries

#### 7.2.2 Caching Strategy
- Session data cached in Redis (24-hour TTL)
- User profile data cached (1-hour TTL)
- Failed login attempts cached (15-minute TTL)

#### 7.2.3 Async Operations
```csharp
public async Task<LoginResultDto> LoginAsync(LoginInputDto input)
{
    var user = await _userRepository.FindByEmailAsync(input.Email);
    var isValidPassword = await _passwordService.VerifyAsync(input.Password, user.PasswordHash);
    var session = await _sessionService.CreateSessionAsync(user.Id);
    
    return new LoginResultDto
    {
        AccessToken = await _tokenService.GenerateAccessTokenAsync(user),
        RefreshToken = session.TokenHash,
        ExpiresAt = session.ExpiresAt,
        User = ObjectMapper.Map<User, UserProfileDto>(user)
    };
}
```

## 8. Monitoring and Observability

### 8.1 Logging Strategy
```csharp
public class AuthAppService : ApplicationService
{
    public async Task<LoginResultDto> LoginAsync(LoginInputDto input)
    {
        Logger.LogInformation("Login attempt for email: {Email}", input.Email);
        
        try
        {
            // Login logic
            Logger.LogInformation("Successful login for user: {UserId}", user.Id);
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Login failed for email: {Email}", input.Email);
            throw;
        }
    }
}
```

### 8.2 Metrics Collection
- Login success/failure rates
- Password reset request rates
- Session creation/expiration rates
- API response times
- Cache hit/miss ratios

### 8.3 Health Checks
```csharp
public class AuthHealthCheck : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context)
    {
        try
        {
            await _userRepository.GetCountAsync();
            await _cache.GetAsync("health-check");
            
            return HealthCheckResult.Healthy();
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("Authentication service unhealthy", ex);
        }
    }
}
```

## 9. Deployment Architecture

### 9.1 Container Configuration
```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Security configurations
RUN adduser --disabled-password --gecos '' appuser
USER appuser

EXPOSE 80
ENTRYPOINT ["dotnet", "AbpApp.HttpApi.Host.dll"]
```

### 9.2 Environment Configuration
```yaml
# docker-compose.yml
services:
  auth-api:
    build: .
    environment:
      - ConnectionStrings__Default=Server=sqlserver;Database=AbpApp;User Id=sa;Password=YourPassword123!
      - Redis__Configuration=redis:6379
      - SendGrid__ApiKey=${SENDGRID_API_KEY}
    depends_on:
      - sqlserver
      - redis
```

### 9.3 Scaling Considerations
- **Horizontal Scaling**: Stateless application services
- **Database Scaling**: Read replicas for user queries
- **Cache Scaling**: Redis cluster for high availability
- **Load Balancing**: Nginx for request distribution

## 10. Testing Architecture

### 10.1 Unit Testing Strategy
```csharp
[Test]
public async Task LoginAsync_ValidCredentials_ReturnsSuccessResult()
{
    // Arrange
    var input = new LoginInputDto { Email = "test@example.com", Password = "Password123" };
    var user = new User(input.Email, "hashedPassword");
    
    _userRepository.Setup(x => x.FindByEmailAsync(input.Email)).ReturnsAsync(user);
    _passwordService.Setup(x => x.VerifyAsync(input.Password, user.PasswordHash)).ReturnsAsync(true);
    
    // Act
    var result = await _authAppService.LoginAsync(input);
    
    // Assert
    Assert.That(result.AccessToken, Is.Not.Null);
    Assert.That(result.User.Email, Is.EqualTo(input.Email));
}
```

### 10.2 Integration Testing
```csharp
[Test]
public async Task AuthenticationFlow_EndToEnd_Success()
{
    // Register user
    var registerResult = await _client.PostAsync("/api/auth/register", registerData);
    
    // Login user
    var loginResult = await _client.PostAsync("/api/auth/login", loginData);
    
    // Access protected resource
    _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    var profileResult = await _client.GetAsync("/api/account/profile");
    
    Assert.That(profileResult.StatusCode, Is.EqualTo(HttpStatusCode.OK));
}
```

## 11. Migration and Rollback Strategy

### 11.1 Database Migration
```csharp
public partial class AddAuthenticationTables : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Users",
            columns: table => new
            {
                Id = table.Column<Guid>(nullable: false),
                Email = table.Column<string>(maxLength: 256, nullable: false),
                PasswordHash = table.Column<string>(maxLength: 512, nullable: false),
                // ... other columns
            });
    }
    
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "Users");
        migrationBuilder.DropTable(name: "Sessions");
        migrationBuilder.DropTable(name: "PasswordResetTokens");
    }
}
```

### 11.2 Feature Flags
```csharp
public class AuthAppService : ApplicationService
{
    public async Task<LoginResultDto> LoginAsync(LoginInputDto input)
    {
        if (await _featureChecker.IsEnabledAsync("Authentication.NewLoginFlow"))
        {
            return await NewLoginFlowAsync(input);
        }
        
        return await LegacyLoginFlowAsync(input);
    }
}
```

## 12. Conclusion

This technical architecture provides a comprehensive foundation for implementing the Authentication feature within the ABP Enterprise Application. The design emphasizes security, performance, and maintainability while following established patterns and best practices.

### Key Architectural Benefits:
1. **Scalable Design**: Supports 1,000+ concurrent users with horizontal scaling capabilities
2. **Security-First Approach**: Implements industry-standard security practices
3. **Performance Optimized**: Sub-800ms response times with intelligent caching
4. **Maintainable Code**: Clean architecture with clear separation of concerns
5. **Testable Components**: Comprehensive testing strategy with high coverage

### Next Steps:
1. Review and approve this technical architecture
2. Begin implementation following the defined patterns
3. Set up monitoring and observability tools
4. Implement comprehensive testing suite
5. Plan deployment and rollback procedures

This architecture serves as the blueprint for the development team to implement a robust, secure, and scalable authentication system that meets all functional and non-functional requirements.