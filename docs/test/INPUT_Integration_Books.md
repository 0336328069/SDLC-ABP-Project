# Integration Input - Book Management

Đây là file input cho Integration generation của tính năng Quản lý Sách. Integration sẽ đảm bảo tất cả các layer hoạt động liền mạch với nhau và với các hệ thống bên ngoài.

## Integration Requirements Overview

### System Integration Context

Hệ thống Book Management cần tích hợp với:
- **Authentication System** (đã có): User management và permissions
- **Email Service**: Notifications và reminders
- **File Storage**: Book covers, documents, reports
- **Payment Gateway**: Fine payments (future)
- **External APIs**: Book metadata services (future)
- **Monitoring Systems**: Logging, metrics, health checks

### Technology Stack Integration

- **Backend**: ABP Framework 8.3.0 + .NET 9.0
- **Database**: SQL Server 2019+ với EF Core 9.0
- **Caching**: Redis 7.0
- **Message Queue**: RabbitMQ (for async processing)
- **Email**: SMTP với template system
- **Storage**: Azure Blob Storage / AWS S3
- **Monitoring**: Serilog + Application Insights
- **API Gateway**: Optional reverse proxy

## Layer Integration Specifications

### 1. Domain Layer Integration

#### Authentication System Integration
```csharp
// Extend existing User entity with library-specific properties
public class LibraryUser : IdentityUser
{
    public MembershipType MembershipType { get; set; }
    public DateTime MembershipExpiration { get; set; }
    public int BorrowingLimit { get; set; }
    public decimal TotalFineAmount { get; set; }
    public bool IsLibraryActive { get; set; }
}

// Domain service integration
public class BookBorrowingService : DomainService
{
    private readonly IUserRepository _userRepository; // From Auth system
    private readonly IBookRepository _bookRepository;
    
    public async Task<bool> CanUserBorrowAsync(Guid userId, Guid bookId)
    {
        // Integrate with existing user management
        var user = await _userRepository.GetAsync(userId);
        var libraryUser = await GetLibraryUserDataAsync(userId);
        
        // Apply borrowing rules
        return ValidateBorrowingEligibility(user, libraryUser, bookId);
    }
}
```

#### Event Integration
```csharp
// Domain events that trigger cross-system actions
public class BookBorrowedEventData : EntityEventData<BookBorrow>
{
    public Guid UserId { get; set; }
    public Guid BookId { get; set; }
    public DateTime DueDate { get; set; }
    public string UserEmail { get; set; } // From Auth system
}

// Event handlers for integration
public class BookBorrowedEventHandler : 
    IDistributedEventHandler<BookBorrowedEventData>
{
    private readonly IEmailService _emailService;
    private readonly INotificationService _notificationService;
    
    public async Task HandleEventAsync(BookBorrowedEventData eventData)
    {
        // Send confirmation email
        await _emailService.SendBorrowConfirmationAsync(eventData);
        
        // Create in-app notification
        await _notificationService.CreateNotificationAsync(eventData);
        
        // Schedule due date reminder
        await ScheduleDueDateReminderAsync(eventData);
    }
}
```

### 2. Application Layer Integration

#### Permission Integration
```csharp
// Integrate with ABP Permission System
public static class BookManagementPermissions
{
    public const string GroupName = "BookManagement";
    
    public static class Books
    {
        public const string Default = GroupName + ".Books";
        public const string Search = Default + ".Search";
        public const string Borrow = Default + ".Borrow";
        public const string Manage = Default + ".Manage";
        public const string Reports = Default + ".Reports";
    }
    
    public static class Fines
    {
        public const string Default = GroupName + ".Fines";
        public const string Pay = Default + ".Pay";
        public const string Manage = Default + ".Manage";
        public const string Waive = Default + ".Waive";
    }
}

// Permission provider registration
public class BookManagementPermissionDefinitionProvider : PermissionDefinitionProvider
{
    public override void Define(IPermissionDefinitionContext context)
    {
        var bookGroup = context.AddGroup(BookManagementPermissions.GroupName, 
            L("Permission:BookManagement"));
            
        var booksPermission = bookGroup.AddPermission(
            BookManagementPermissions.Books.Default, L("Permission:Books"));
        booksPermission.AddChild(BookManagementPermissions.Books.Search, 
            L("Permission:Books.Search"));
        // ... add other permissions
    }
}
```

#### Cross-Service Communication
```csharp
// Application service integration
public class BookBorrowingAppService : ApplicationService
{
    private readonly IUserAppService _userAppService; // From Auth module
    private readonly BookBorrowingService _borrowingService;
    private readonly IEmailService _emailService;
    private readonly IDistributedEventBus _eventBus;
    
    [Authorize(BookManagementPermissions.Books.Borrow)]
    public async Task<BorrowResultDto> BorrowBookAsync(Guid bookId)
    {
        // Get current user from Auth system
        var currentUser = await _userAppService.GetAsync(CurrentUser.Id.Value);
        
        // Use domain service for business logic
        var borrowResult = await _borrowingService.ProcessBorrowAsync(
            CurrentUser.Id.Value, bookId);
        
        // Publish event for integration
        await _eventBus.PublishAsync(new BookBorrowedEventData
        {
            UserId = CurrentUser.Id.Value,
            BookId = bookId,
            DueDate = borrowResult.DueDate,
            UserEmail = currentUser.Email
        });
        
        return ObjectMapper.Map<BookBorrow, BorrowResultDto>(borrowResult);
    }
}
```

### 3. Infrastructure Layer Integration

#### Database Integration
```csharp
// DbContext integration with existing auth tables
public class LibraryDbContext : AbpDbContext<LibraryDbContext>
{
    // Book management tables
    public DbSet<Book> Books { get; set; }
    public DbSet<BookBorrow> BookBorrows { get; set; }
    public DbSet<BookReservation> BookReservations { get; set; }
    public DbSet<Fine> Fines { get; set; }
    
    // Reference to auth tables (via navigation properties)
    public DbSet<IdentityUser> Users { get; set; }
    
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        
        // Configure relationships with auth system
        builder.Entity<BookBorrow>(b =>
        {
            b.HasOne<IdentityUser>()
                .WithMany()
                .HasForeignKey(x => x.UserId)
                .OnDelete(DeleteBehavior.Restrict);
        });
        
        // Configure book management entities
        builder.ConfigureBookManagement();
    }
}

// Repository implementations with performance optimization
public class EfCoreBookRepository : EfCoreRepository<LibraryDbContext, Book, Guid>, IBookRepository
{
    public async Task<List<Book>> GetAvailableBooksAsync()
    {
        var dbSet = await GetDbSetAsync();
        return await dbSet
            .Where(b => b.Inventory.AvailableQuantity > 0)
            .AsNoTracking()
            .ToListAsync();
    }
    
    public async Task<PagedResultDto<Book>> GetBooksWithFiltersAsync(BookSearchSpecification spec)
    {
        var dbSet = await GetDbSetAsync();
        var query = spec.Apply(dbSet);
        
        var totalCount = await query.CountAsync();
        var items = await query
            .Skip(spec.Skip)
            .Take(spec.Take)
            .AsNoTracking()
            .ToListAsync();
            
        return new PagedResultDto<Book>(totalCount, items);
    }
}
```

#### Caching Integration
```csharp
// Redis caching for performance
public class CachedBookRepository : IBookRepository, ITransientDependency
{
    private readonly IBookRepository _bookRepository;
    private readonly IDistributedCache _cache;
    
    public async Task<Book> GetAsync(Guid id)
    {
        var cacheKey = $"book:{id}";
        var cachedBook = await _cache.GetStringAsync(cacheKey);
        
        if (cachedBook != null)
        {
            return JsonSerializer.Deserialize<Book>(cachedBook);
        }
        
        var book = await _bookRepository.GetAsync(id);
        await _cache.SetStringAsync(cacheKey, JsonSerializer.Serialize(book),
            new DistributedCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(30)
            });
            
        return book;
    }
}
```

### 4. API Layer Integration

#### Unified Error Handling
```csharp
// Global exception filter
public class BookManagementExceptionFilter : IExceptionFilter, ITransientDependency
{
    private readonly ILogger<BookManagementExceptionFilter> _logger;
    
    public void OnException(ExceptionContext context)
    {
        if (context.Exception is BookNotAvailableException)
        {
            context.Result = new ObjectResult(new ErrorResponse
            {
                Error = new ErrorInfo
                {
                    Code = "BOOK_NOT_AVAILABLE",
                    Message = "The requested book is not available for borrowing",
                    Details = context.Exception.Message
                }
            })
            {
                StatusCode = 409
            };
            
            _logger.LogWarning("Book not available: {Message}", context.Exception.Message);
        }
        // Handle other custom exceptions...
    }
}

// API versioning
[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/app/books")]
public class BookController : AbpControllerBase
{
    // Controller implementation
}
```

#### CORS Configuration
```csharp
// Startup configuration for frontend integration
public void ConfigureServices(IServiceCollection services)
{
    services.AddCors(options =>
    {
        options.AddPolicy("BookManagementCors", builder =>
        {
            builder
                .WithOrigins(
                    "http://localhost:3000", // Next.js dev
                    "https://library.example.com" // Production
                )
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials();
        });
    });
}
```

### 5. Frontend Integration

#### API Client Integration
```typescript
// Unified API client with auth integration
class ApiClient {
  private axiosInstance: AxiosInstance
  
  constructor() {
    this.axiosInstance = axios.create({
      baseURL: process.env.NEXT_PUBLIC_API_URL,
      timeout: 10000,
    })
    
    // Request interceptor for auth token
    this.axiosInstance.interceptors.request.use((config) => {
      const token = this.getAuthToken() // From existing auth
      if (token) {
        config.headers.Authorization = `Bearer ${token}`
      }
      return config
    })
    
    // Response interceptor for error handling
    this.axiosInstance.interceptors.response.use(
      (response) => response,
      async (error) => {
        if (error.response?.status === 401) {
          await this.handleTokenRefresh()
        }
        return Promise.reject(error)
      }
    )
  }
}

// Service integration
export const bookService = {
  async getBooks(params: GetBooksParams): Promise<PagedResult<Book>> {
    const response = await apiClient.get('/api/app/books', { params })
    return response.data
  },
  
  async borrowBook(bookId: string): Promise<BorrowResult> {
    const response = await apiClient.post('/api/app/book-borrowing/borrow', 
      { bookId })
    return response.data
  }
}
```

#### State Management Integration
```typescript
// Zustand store integration with auth
interface AppStore {
  // Existing auth state
  auth: AuthState
  
  // Book management state
  books: {
    catalog: Book[]
    loading: boolean
    filters: BookFilters
  }
  
  userLibrary: {
    borrowedBooks: BorrowedBook[]
    reservations: Reservation[]
    fines: Fine[]
  }
  
  // Actions
  borrowBook: (bookId: string) => Promise<void>
  loadUserLibrary: () => Promise<void>
}

// React Query integration
export function useBooks(filters: BookFilters) {
  return useQuery({
    queryKey: ['books', filters],
    queryFn: () => bookService.getBooks(filters),
    enabled: !!filters,
    staleTime: 5 * 60 * 1000, // 5 minutes
  })
}

export function useBorrowBook() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: bookService.borrowBook,
    onSuccess: () => {
      // Invalidate relevant queries
      queryClient.invalidateQueries({ queryKey: ['books'] })
      queryClient.invalidateQueries({ queryKey: ['userLibrary'] })
    },
  })
}
```

## External System Integrations

### 1. Email Service Integration

#### Template System
```csharp
// Email templates for book management
public class BookEmailTemplates
{
    public const string BorrowConfirmation = "BookBorrowConfirmation";
    public const string DueReminder = "BookDueReminder";
    public const string OverdueNotice = "BookOverdueNotice";
    public const string ReservationAvailable = "ReservationAvailable";
    public const string FineNotice = "FineNotice";
}

// Email service implementation
public class BookEmailService : IBookEmailService, ITransientDependency
{
    private readonly IEmailSender _emailSender;
    private readonly ITemplateRenderer _templateRenderer;
    
    public async Task SendBorrowConfirmationAsync(BookBorrowedEventData eventData)
    {
        var template = await _templateRenderer.RenderAsync(
            BookEmailTemplates.BorrowConfirmation,
            new
            {
                UserName = eventData.UserName,
                BookTitle = eventData.BookTitle,
                DueDate = eventData.DueDate.ToString("dd/MM/yyyy"),
                LibraryName = "Digital Library"
            });
            
        await _emailSender.SendAsync(
            eventData.UserEmail,
            "Book Borrow Confirmation",
            template);
    }
}
```

### 2. File Storage Integration

#### Book Cover Management
```csharp
// File storage for book covers
public class BookCoverService : IBookCoverService, ITransientDependency
{
    private readonly IBlobStorageService _blobStorage;
    
    public async Task<string> UploadCoverAsync(IFormFile file, Guid bookId)
    {
        var fileName = $"covers/{bookId}/{Guid.NewGuid()}.jpg";
        var url = await _blobStorage.SaveAsync(fileName, file.OpenReadStream());
        return url;
    }
    
    public async Task DeleteCoverAsync(string coverUrl)
    {
        var fileName = ExtractFileNameFromUrl(coverUrl);
        await _blobStorage.DeleteAsync(fileName);
    }
}
```

### 3. Background Job Integration

#### Scheduled Tasks
```csharp
// Background jobs for book management
[DisallowConcurrentExecution]
public class BookMaintenanceJob : AsyncBackgroundJob<BookMaintenanceJobArgs>
{
    public async Task ExecuteAsync(BookMaintenanceJobArgs args)
    {
        // Process overdue books
        await ProcessOverdueBooksAsync();
        
        // Send due date reminders
        await SendDueDateRemindersAsync();
        
        // Clean up expired reservations
        await CleanupExpiredReservationsAsync();
        
        // Update availability cache
        await UpdateAvailabilityCacheAsync();
    }
}

// Job scheduling
public class BookManagementBackgroundJobsService : ITransientDependency
{
    private readonly IBackgroundJobManager _backgroundJobManager;
    
    public async Task ScheduleMaintenanceJobsAsync()
    {
        // Daily maintenance at 2 AM
        await _backgroundJobManager.EnqueueAsync<BookMaintenanceJob>(
            new BookMaintenanceJobArgs(),
            BackgroundJobPriority.High,
            TimeSpan.FromHours(24));
    }
}
```

## Health Checks & Monitoring

### Health Check Integration
```csharp
// Health checks for book management
public class BookManagementHealthCheck : IHealthCheck
{
    private readonly IBookRepository _bookRepository;
    private readonly IDistributedCache _cache;
    
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context, 
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Check database connectivity
            await _bookRepository.GetCountAsync();
            
            // Check cache connectivity
            await _cache.GetStringAsync("health-check");
            
            return HealthCheckResult.Healthy("Book management system is healthy");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy(
                "Book management system is unhealthy", ex);
        }
    }
}
```

### Logging Integration
```csharp
// Structured logging for book operations
public class BookBorrowingAppService : ApplicationService
{
    private readonly ILogger<BookBorrowingAppService> _logger;
    
    public async Task<BorrowResultDto> BorrowBookAsync(Guid bookId)
    {
        using var scope = _logger.BeginScope(new Dictionary<string, object>
        {
            ["UserId"] = CurrentUser.Id,
            ["BookId"] = bookId,
            ["Operation"] = "BorrowBook"
        });
        
        _logger.LogInformation("Starting book borrow process");
        
        try
        {
            var result = await ProcessBorrowAsync(bookId);
            
            _logger.LogInformation("Book borrowed successfully. DueDate: {DueDate}", 
                result.DueDate);
                
            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to borrow book");
            throw;
        }
    }
}
```

## Testing Integration

### Integration Testing Setup
```csharp
// Test setup for integration testing
public class BookManagementTestModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        // Use in-memory database for testing
        context.Services.AddAbpDbContext<TestLibraryDbContext>(options =>
        {
            options.AddDefaultRepositories(includeAllEntities: true);
        });
        
        // Mock external services
        context.Services.Replace(ServiceDescriptor.Transient<IEmailService, MockEmailService>());
        context.Services.Replace(ServiceDescriptor.Transient<IBlobStorageService, MockBlobStorageService>());
    }
}

// Integration test example
public class BookBorrowingIntegrationTests : BookManagementApplicationTestBase
{
    [Fact]
    public async Task Should_Borrow_Book_Successfully()
    {
        // Arrange
        var book = await CreateTestBookAsync();
        var user = await CreateTestUserAsync();
        
        // Act
        var result = await BookBorrowingAppService.BorrowBookAsync(book.Id);
        
        // Assert
        result.ShouldNotBeNull();
        result.BookId.ShouldBe(book.Id);
        result.DueDate.ShouldBeGreaterThan(Clock.Now);
        
        // Verify side effects
        var borrowRecord = await BookBorrowRepository.GetAsync(result.BorrowId);
        borrowRecord.ShouldNotBeNull();
        
        // Verify email was sent
        var emailService = GetRequiredService<MockEmailService>();
        emailService.SentEmails.ShouldContain(e => e.Subject.Contains("Borrow Confirmation"));
    }
}
```

This integration specification ensures seamless communication between all layers and external systems while maintaining clean architecture principles and providing comprehensive testing coverage.