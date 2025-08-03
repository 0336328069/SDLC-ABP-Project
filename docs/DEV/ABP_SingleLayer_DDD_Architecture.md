# ABP Framework Single Layer with Domain-Driven Design (DDD)

## Overview

ABP Framework's Single Layer architecture with Domain-Driven Design combines the simplicity of a single-layer approach with the powerful domain modeling concepts of DDD. This architecture is ideal for small to medium-sized applications that want to maintain clean domain logic without the complexity of multi-layered architecture.

## Architecture Components

### 1. Domain Layer (Core)

The domain layer contains the business logic and domain entities, following DDD principles.

#### Domain Entities

```csharp
public class User : AuditedAggregateRoot<Guid>
{
    public string UserName { get; private set; }
    public string Email { get; private set; }
    public bool IsEmailConfirmed { get; private set; }

    // Domain methods
    public void ConfirmEmail()
    {
        IsEmailConfirmed = true;
        AddLocalEvent(new UserEmailConfirmedEvent(Id));
    }
}
```

#### Value Objects

```csharp
public class EmailAddress : ValueObject
{
    public string Value { get; private set; }

    private EmailAddress(string value)
    {
        Value = Check.NotNullOrWhiteSpace(value, nameof(value));
        if (!IsValidEmail(value))
            throw new BusinessException("Invalid email format");
    }

    public static EmailAddress Create(string email) => new(email);

    protected override IEnumerable<object> GetAtomicValues()
    {
        yield return Value;
    }
}
```

#### Domain Services

```csharp
public class UserDomainService : DomainService
{
    private readonly IUserRepository _userRepository;

    public UserDomainService(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    public async Task<bool> IsUsernameUniqueAsync(string username)
    {
        return await _userRepository.FindByUsernameAsync(username) == null;
    }
}
```

#### Repositories (Interfaces)

```csharp
public interface IUserRepository : IRepository<User, Guid>
{
    Task<User> FindByUsernameAsync(string username);
    Task<User> FindByEmailAsync(string email);
    Task<List<User>> GetActiveUsersAsync();
}
```

### 2. Application Layer

Contains application services, DTOs, and use case orchestration.

#### Application Services

```csharp
[Authorize]
public class UserAppService : ApplicationService, IUserAppService
{
    private readonly IUserRepository _userRepository;
    private readonly UserDomainService _userDomainService;

    public UserAppService(
        IUserRepository userRepository,
        UserDomainService userDomainService)
    {
        _userRepository = userRepository;
        _userDomainService = userDomainService;
    }

    public async Task<UserDto> CreateAsync(CreateUserDto input)
    {
        await CheckPolicyAsync(UserPermissions.Create);

        if (!await _userDomainService.IsUsernameUniqueAsync(input.UserName))
        {
            throw new UserFriendlyException("Username already exists");
        }

        var user = new User(
            GuidGenerator.Create(),
            input.UserName,
            input.Email
        );

        user = await _userRepository.InsertAsync(user);
        await UnitOfWorkManager.Current.SaveChangesAsync();

        return ObjectMapper.Map<User, UserDto>(user);
    }
}
```

#### DTOs

```csharp
public class UserDto : AuditedEntityDto<Guid>
{
    public string UserName { get; set; }
    public string Email { get; set; }
    public bool IsEmailConfirmed { get; set; }
}

public class CreateUserDto
{
    [Required]
    [StringLength(32)]
    public string UserName { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }
}
```

### 3. Infrastructure Layer

Contains implementations of repositories and external service integrations.

#### Repository Implementation

```csharp
public class EfCoreUserRepository : EfCoreRepository<AppDbContext, User, Guid>, IUserRepository
{
    public EfCoreUserRepository(IDbContextProvider<AppDbContext> dbContextProvider)
        : base(dbContextProvider)
    {
    }

    public async Task<User> FindByUsernameAsync(string username)
    {
        var dbSet = await GetDbSetAsync();
        return await dbSet.FirstOrDefaultAsync(x => x.UserName == username);
    }

    public async Task<User> FindByEmailAsync(string email)
    {
        var dbSet = await GetDbSetAsync();
        return await dbSet.FirstOrDefaultAsync(x => x.Email == email);
    }

    public async Task<List<User>> GetActiveUsersAsync()
    {
        var dbSet = await GetDbSetAsync();
        return await dbSet.Where(x => x.IsEmailConfirmed).ToListAsync();
    }
}
```

#### DbContext

```csharp
public class AppDbContext : AbpDbContext<AppDbContext>
{
    public DbSet<User> Users { get; set; }

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.ConfigureApp();
    }
}
```

### 4. Web/API Layer

Contains controllers, middleware, and web-specific configurations.

#### Controllers

```csharp
[ApiController]
[Route("api/users")]
public class UserController : AbpControllerBase
{
    private readonly IUserAppService _userAppService;

    public UserController(IUserAppService userAppService)
    {
        _userAppService = userAppService;
    }

    [HttpPost]
    public async Task<UserDto> CreateAsync(CreateUserDto input)
    {
        return await _userAppService.CreateAsync(input);
    }

    [HttpGet("{id}")]
    public async Task<UserDto> GetAsync(Guid id)
    {
        return await _userAppService.GetAsync(id);
    }
}
```

## Project Structure

```
src/
├── Domain/
│   ├── Entities/
│   │   ├── User.cs
│   │   └── PasswordResetToken.cs
│   ├── ValueObjects/
│   │   └── EmailAddress.cs
│   ├── Services/
│   │   └── UserDomainService.cs
│   ├── Repositories/
│   │   └── IUserRepository.cs
│   └── Events/
│       └── UserEmailConfirmedEvent.cs
├── Application/
│   ├── Services/
│   │   └── UserAppService.cs
│   ├── Contracts/
│   │   └── IUserAppService.cs
│   ├── Dtos/
│   │   ├── UserDto.cs
│   │   └── CreateUserDto.cs
│   └── Permissions/
│       └── UserPermissions.cs
├── Infrastructure/
│   ├── EntityFrameworkCore/
│   │   ├── AppDbContext.cs
│   │   ├── Repositories/
│   │   │   └── EfCoreUserRepository.cs
│   │   └── Configurations/
│   │       └── UserConfiguration.cs
│   └── ExternalServices/
│       └── EmailService.cs
└── Web/
    ├── Controllers/
    │   └── UserController.cs
    ├── Pages/
    └── wwwroot/
```

## DDD Patterns Implementation

### 1. Aggregate Roots

```csharp
public class User : AuditedAggregateRoot<Guid>
{
    private readonly List<UserRole> _roles = new();
    public IReadOnlyList<UserRole> Roles => _roles.AsReadOnly();

    public void AddRole(Role role)
    {
        if (_roles.Any(r => r.RoleId == role.Id))
            return;

        _roles.Add(new UserRole(Id, role.Id));
        AddLocalEvent(new UserRoleAddedEvent(Id, role.Id));
    }
}
```

### 2. Domain Events

```csharp
[Serializable]
public class UserEmailConfirmedEvent : DomainEventData
{
    public Guid UserId { get; set; }

    public UserEmailConfirmedEvent(Guid userId)
    {
        UserId = userId;
    }
}

// Event Handler
public class UserEmailConfirmedEventHandler : ILocalEventHandler<UserEmailConfirmedEvent>
{
    public async Task HandleEventAsync(UserEmailConfirmedEvent eventData)
    {
        // Send welcome email
        // Update statistics
        // Trigger other business processes
    }
}
```

### 3. Specifications Pattern

```csharp
public class ActiveUsersSpecification : Specification<User>
{
    public override Expression<Func<User, bool>> ToExpression()
    {
        return user => user.IsEmailConfirmed && !user.IsLocked;
    }
}

public class UsersByDomainSpecification : Specification<User>
{
    private readonly string _domain;

    public UsersByDomainSpecification(string domain)
    {
        _domain = domain;
    }

    public override Expression<Func<User, bool>> ToExpression()
    {
        return user => user.Email.EndsWith($"@{_domain}");
    }
}
```

### 4. Factory Pattern

```csharp
public class UserFactory : ITransientDependency
{
    private readonly IGuidGenerator _guidGenerator;
    private readonly UserDomainService _userDomainService;

    public UserFactory(
        IGuidGenerator guidGenerator,
        UserDomainService userDomainService)
    {
        _guidGenerator = guidGenerator;
        _userDomainService = userDomainService;
    }

    public async Task<User> CreateAsync(string username, string email)
    {
        await _userDomainService.CheckUsernameUniquenessAsync(username);

        return new User(
            _guidGenerator.Create(),
            username,
            EmailAddress.Create(email)
        );
    }
}
```

## Configuration and Module Setup

### Module Definition

```csharp
[DependsOn(
    typeof(AbpAspNetCoreMvcModule),
    typeof(AbpEntityFrameworkCoreModule),
    typeof(AbpAutoMapperModule)
)]
public class AppModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var configuration = context.Services.GetConfiguration();

        ConfigureDatabase(context, configuration);
        ConfigureAutoMapper(context);
        ConfigureServices(context);
    }

    private void ConfigureDatabase(ServiceConfigurationContext context, IConfiguration configuration)
    {
        context.Services.AddAbpDbContext<AppDbContext>(options =>
        {
            options.AddDefaultRepositories(includeAllEntities: true);
            options.AddRepository<User, EfCoreUserRepository>();
        });

        Configure<AbpDbContextOptions>(options =>
        {
            options.UseSqlServer();
        });
    }
}
```

## Benefits of Single Layer DDD

### Advantages

1. **Simplified Architecture**: Reduced complexity compared to multi-layer DDD
2. **Domain Focus**: Strong emphasis on business logic and domain modeling
3. **Faster Development**: Less boilerplate code and architectural overhead
4. **Easy Testing**: Simplified dependency injection and testing setup
5. **ABP Integration**: Leverages ABP's built-in features and conventions

### When to Use

- Small to medium-sized applications
- Projects with clear domain boundaries
- Teams new to DDD concepts
- Rapid prototyping and MVP development
- Applications with straightforward business logic

### Considerations

- May become complex as the application grows
- Limited separation of concerns compared to multi-layer architecture
- Potential for mixing concerns if not carefully managed
- Less suitable for large enterprise applications

## Best Practices

1. **Keep Domain Pure**: Avoid infrastructure dependencies in domain layer
2. **Use Value Objects**: Model concepts that don't have identity as value objects
3. **Apply Specifications**: Use specification pattern for complex queries
4. **Handle Domain Events**: Implement domain events for cross-cutting concerns
5. **Validate Business Rules**: Place validation logic in domain entities and services
6. **Use Factories**: Create complex objects using factory pattern
7. **Repository Abstraction**: Keep repository interfaces in domain layer
8. **Unit Testing**: Focus on testing domain logic and business rules

This architecture provides a balanced approach between simplicity and domain-driven design principles, making it ideal for applications that need clean domain modeling without excessive architectural complexity.
