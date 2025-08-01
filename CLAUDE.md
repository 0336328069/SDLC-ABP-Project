# ABP App - Database Integration Commands

## EF Core Migration Commands

### Development Workflow
```bash
# Navigate to EntityFrameworkCore project
cd "src/backend/src/AbpApp.EntityFrameworkCore"

# Add new migration (after schema changes)
dotnet ef migrations add [MigrationName]

# Update database to latest migration
dotnet ef database update

# Remove last migration (if not applied to database)
dotnet ef migrations remove

# Generate SQL script for production deployment
dotnet ef migrations script

# Update to specific migration
dotnet ef database update [MigrationName]

# Drop database (development only)
dotnet ef database drop
```

### Migration Best Practices
- Always review generated migration before applying
- Use descriptive migration names (e.g., `AddUserAccountLocking`, `UpdatePasswordResetTokenSchema`)
- Test migrations on development environment first
- Create rollback plan for production deployments

## Build Commands
```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build "src/backend/src/AbpApp.EntityFrameworkCore"

# Clean and rebuild
dotnet clean && dotnet build
```

## Database Migrator Tool
```bash
# Run database migrator (for production deployments)
dotnet run --project "tools/AbpApp.DbMigrator"
```

## Specification Pattern Usage

### Overview
The Specification Pattern has been implemented to provide reusable, testable, and composable query logic. It helps eliminate N+1 problems and provides better query performance.

### Available Specifications

#### PasswordResetToken Specifications
- `ValidPasswordResetTokensForUserSpecification` - Find valid tokens for a user
- `ExpiredPasswordResetTokensSpecification` - Find all expired tokens
- `UnusedPasswordResetTokensForUserSpecification` - Find unused tokens for a user
- `PasswordResetTokenByHashSpecification` - Find token by hash
- `RecentPasswordResetTokensSpecification` - Find recent tokens within time window
- `PasswordResetTokensWithPagingSpecification` - Paginated token query with filters

#### AppUser Specifications
- `LockedUsersSpecification` - Find locked user accounts
- `UsersWithFailedLoginsSpecification` - Find users with failed login attempts
- `RecentlyRegisteredUsersSpecification` - Find recently registered users
- `UnconfirmedUsersSpecification` - Find users with unconfirmed emails
- `UsersByEmailDomainSpecification` - Find users by email domain
- `ActiveUsersSpecification` - Find active (confirmed, unlocked) users
- `UsersWithPagingSpecification` - Paginated user query with search and filters

### Usage Examples

#### Basic Specification Usage
```csharp
// In Application Service or Domain Service
public class AuthenticationAppService
{
    private readonly IPasswordResetTokenRepository _tokenRepository;
    
    public async Task<List<PasswordResetTokenDto>> GetValidTokensForUserAsync(Guid userId)
    {
        var specification = new ValidPasswordResetTokensForUserSpecification(userId);
        var tokens = await _tokenRepository.ListBySpecificationAsync(specification);
        return ObjectMapper.Map<List<PasswordResetToken>, List<PasswordResetTokenDto>>(tokens);
    }
    
    public async Task<int> GetExpiredTokenCountAsync()
    {
        var specification = new ExpiredPasswordResetTokensSpecification();
        return await _tokenRepository.CountBySpecificationAsync(specification);
    }
    
    public async Task<bool> HasValidTokenAsync(Guid userId)
    {
        var specification = new ValidPasswordResetTokensForUserSpecification(userId);
        return await _tokenRepository.AnyBySpecificationAsync(specification);
    }
}
```

#### Paginated Query Example
```csharp
public async Task<PagedResultDto<AppUserDto>> GetUsersAsync(GetUsersInput input)
{
    var specification = new UsersWithPagingSpecification(
        input.SkipCount,
        input.MaxResultCount,
        input.SearchTerm,
        input.IsEmailConfirmed,
        input.IsLocked
    );
    
    var users = await _userRepository.ListBySpecificationAsync(specification);
    var totalCount = await _userRepository.CountBySpecificationAsync(
        new UsersWithPagingSpecification(0, int.MaxValue, input.SearchTerm, input.IsEmailConfirmed, input.IsLocked)
    );
    
    return new PagedResultDto<AppUserDto>
    {
        Items = ObjectMapper.Map<List<AppUser>, List<AppUserDto>>(users),
        TotalCount = totalCount
    };
}
```

#### Performance Benefits
- **No Tracking**: Read-only queries use `AsNoTracking()` automatically
- **Optimized Queries**: Only necessary data is loaded
- **Reusable Logic**: Specifications can be reused across different services
- **Testable**: Easy to unit test query logic independently

### Best Practices
1. Use specifications for complex queries with multiple conditions
2. Combine specifications for reusable query building blocks  
3. Use `ApplyNoTracking()` for read-only operations
4. Apply paging for large datasets
5. Create specific specifications rather than generic ones for better performance