# Generated Backend API Files - Book Management

Đây là file mô phỏng output từ Backend API generation để làm input cho các META prompt khác. File này thể hiện các API controllers và cấu hình đã được generate cho tính năng Quản lý Sách.

## Backend API Overview

Backend API đã được generate với đầy đủ các Controllers, DTOs validation, middleware, swagger documentation, và error handling. API được thiết kế theo RESTful principles và ABP Framework conventions.

### Generated API Controllers

1. **BookController**: Book catalog CRUD operations
2. **BookSearchController**: Advanced search và autocomplete
3. **BookBorrowingController**: Borrowing workflows và management
4. **BookReservationController**: Reservation operations
5. **CategoryController**: Category management
6. **FineController**: Fine management và payment
7. **LibraryReportsController**: Reporting và analytics
8. **UserLibraryController**: User dashboard và personal library

## Generated Files Structure

```
src/AbpApp.HttpApi/Controllers/Books/
├── BookController.cs
├── BookSearchController.cs
├── BookBorrowingController.cs
├── BookReservationController.cs
├── CategoryController.cs
├── FineController.cs
├── LibraryReportsController.cs
└── UserLibraryController.cs

src/AbpApp.HttpApi/Middleware/
├── BookManagementExceptionMiddleware.cs
├── RateLimitingMiddleware.cs
└── RequestLoggingMiddleware.cs

src/AbpApp.HttpApi/Filters/
├── BookManagementActionFilter.cs
├── BookManagementExceptionFilter.cs
└── BookManagementAuthorizationFilter.cs

src/AbpApp.HttpApi/Configuration/
├── SwaggerConfiguration.cs
├── CorsConfiguration.cs
└── ApiVersioningConfiguration.cs
```

## Generated Controller Implementations

### 1. BookController Implementation

```csharp
[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/app/books")]
[Authorize(BookManagementPermissions.Books.Search)]
public class BookController : AbpControllerBase
{
    private readonly IBookManagementAppService _bookManagementAppService;
    private readonly ILogger<BookController> _logger;

    public BookController(
        IBookManagementAppService bookManagementAppService,
        ILogger<BookController> logger)
    {
        _bookManagementAppService = bookManagementAppService;
        _logger = logger;
    }

    /// <summary>
    /// Get paginated list of books with search and filtering
    /// </summary>
    /// <param name="input">Search and filter parameters</param>
    /// <returns>Paginated list of books</returns>
    [HttpGet]
    [ProducesResponseType(typeof(PagedResultDto<BookDto>), 200)]
    [ProducesResponseType(400)]
    [ProducesResponseType(401)]
    public async Task<ActionResult<PagedResultDto<BookDto>>> GetListAsync(
        [FromQuery] GetBooksInput input)
    {
        _logger.LogInformation("Getting books list with search term: {SearchTerm}", 
            input.SearchTerm);

        var result = await _bookManagementAppService.GetListAsync(input);
        
        _logger.LogInformation("Retrieved {Count} books out of {Total}", 
            result.Items.Count, result.TotalCount);

        return Ok(result);
    }

    /// <summary>
    /// Get detailed book information by ID
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>Book details</returns>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(BookDto), 200)]
    [ProducesResponseType(404)]
    [ProducesResponseType(401)]
    public async Task<ActionResult<BookDto>> GetAsync(Guid id)
    {
        _logger.LogInformation("Getting book details for ID: {BookId}", id);
        
        var book = await _bookManagementAppService.GetAsync(id);
        return Ok(book);
    }

    /// <summary>
    /// Create new book (Admin/Librarian only)
    /// </summary>
    /// <param name="input">Book creation data</param>
    /// <returns>Created book</returns>
    [HttpPost]
    [Authorize(BookManagementPermissions.Books.Manage)]
    [ProducesResponseType(typeof(BookDto), 201)]
    [ProducesResponseType(400)]
    [ProducesResponseType(403)]
    public async Task<ActionResult<BookDto>> CreateAsync([FromBody] CreateBookDto input)
    {
        _logger.LogInformation("Creating new book with ISBN: {ISBN}", input.ISBN);
        
        var book = await _bookManagementAppService.CreateAsync(input);
        
        _logger.LogInformation("Successfully created book with ID: {BookId}", book.Id);
        
        return CreatedAtAction(nameof(GetAsync), new { id = book.Id }, book);
    }

    /// <summary>
    /// Update existing book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <param name="input">Updated book data</param>
    /// <returns>Updated book</returns>
    [HttpPut("{id}")]
    [Authorize(BookManagementPermissions.Books.Manage)]
    [ProducesResponseType(typeof(BookDto), 200)]
    [ProducesResponseType(404)]
    [ProducesResponseType(400)]
    [ProducesResponseType(403)]
    public async Task<ActionResult<BookDto>> UpdateAsync(Guid id, [FromBody] UpdateBookDto input)
    {
        _logger.LogInformation("Updating book with ID: {BookId}", id);
        
        var book = await _bookManagementAppService.UpdateAsync(id, input);
        
        _logger.LogInformation("Successfully updated book with ID: {BookId}", id);
        
        return Ok(book);
    }

    /// <summary>
    /// Delete book (if not borrowed/reserved)
    /// </summary>
    /// <param name="id">Book ID</param>
    [HttpDelete("{id}")]
    [Authorize(BookManagementPermissions.Books.Manage)]
    [ProducesResponseType(204)]
    [ProducesResponseType(404)]
    [ProducesResponseType(409)]
    [ProducesResponseType(403)]
    public async Task<ActionResult> DeleteAsync(Guid id)
    {
        _logger.LogInformation("Deleting book with ID: {BookId}", id);
        
        await _bookManagementAppService.DeleteAsync(id);
        
        _logger.LogInformation("Successfully deleted book with ID: {BookId}", id);
        
        return NoContent();
    }

    /// <summary>
    /// Update book inventory quantities
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <param name="input">Inventory update data</param>
    /// <returns>Updated book</returns>
    [HttpPut("{id}/inventory")]
    [Authorize(BookManagementPermissions.Books.Manage)]
    [ProducesResponseType(typeof(BookDto), 200)]
    [ProducesResponseType(404)]
    [ProducesResponseType(400)]
    [ProducesResponseType(403)]
    public async Task<ActionResult<BookDto>> UpdateInventoryAsync(
        Guid id, [FromBody] UpdateInventoryDto input)
    {
        _logger.LogInformation("Updating inventory for book ID: {BookId}, Quantity: {Quantity}", 
            id, input.Quantity);
        
        var book = await _bookManagementAppService.UpdateInventoryAsync(id, input);
        
        return Ok(book);
    }

    /// <summary>
    /// Check real-time book availability
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>Availability status</returns>
    [HttpGet("{id}/availability")]
    [ProducesResponseType(typeof(BookAvailabilityDto), 200)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<BookAvailabilityDto>> GetAvailabilityAsync(Guid id)
    {
        var availability = await _bookManagementAppService.GetAvailabilityAsync(id);
        return Ok(availability);
    }
}
```

### 2. BookBorrowingController Implementation

```csharp
[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/app/book-borrowing")]
[Authorize(BookManagementPermissions.Books.Borrow)]
public class BookBorrowingController : AbpControllerBase
{
    private readonly IBookBorrowingAppService _bookBorrowingAppService;
    private readonly ILogger<BookBorrowingController> _logger;

    public BookBorrowingController(
        IBookBorrowingAppService bookBorrowingAppService,
        ILogger<BookBorrowingController> logger)
    {
        _bookBorrowingAppService = bookBorrowingAppService;
        _logger = logger;
    }

    /// <summary>
    /// Borrow a book
    /// </summary>
    /// <param name="input">Borrow request data</param>
    /// <returns>Borrow result</returns>
    [HttpPost("borrow")]
    [ProducesResponseType(typeof(BorrowResultDto), 201)]
    [ProducesResponseType(400)]
    [ProducesResponseType(409)]
    public async Task<ActionResult<BorrowResultDto>> BorrowAsync([FromBody] BorrowBookDto input)
    {
        using var scope = _logger.BeginScope(new Dictionary<string, object>
        {
            ["UserId"] = CurrentUser.Id,
            ["BookId"] = input.BookId,
            ["Operation"] = "BorrowBook"
        });

        _logger.LogInformation("User attempting to borrow book");

        try
        {
            var result = await _bookBorrowingAppService.BorrowBookAsync(input.BookId);
            
            _logger.LogInformation("Book borrowed successfully. Due date: {DueDate}", 
                result.DueDate);
            
            return CreatedAtAction(nameof(GetBorrowAsync), new { id = result.BorrowId }, result);
        }
        catch (BusinessException ex) when (ex.Code == "BOOK_NOT_AVAILABLE")
        {
            _logger.LogWarning("Book borrowing failed: {Reason}", ex.Message);
            return Conflict(new { error = "Book is not available for borrowing" });
        }
        catch (BusinessException ex) when (ex.Code == "BORROWING_LIMIT_EXCEEDED")
        {
            _logger.LogWarning("Borrowing limit exceeded for user");
            return Conflict(new { error = "You have reached your borrowing limit" });
        }
    }

    /// <summary>
    /// Convert reservation to borrow
    /// </summary>
    /// <param name="input">Reservation conversion data</param>
    /// <returns>Borrow result</returns>
    [HttpPost("borrow-with-reservation")]
    [ProducesResponseType(typeof(BorrowResultDto), 201)]
    [ProducesResponseType(400)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<BorrowResultDto>> BorrowWithReservationAsync(
        [FromBody] BorrowWithReservationDto input)
    {
        _logger.LogInformation("Converting reservation {ReservationId} to borrow", 
            input.ReservationId);
        
        var result = await _bookBorrowingAppService.BorrowWithReservationAsync(input.ReservationId);
        
        return CreatedAtAction(nameof(GetBorrowAsync), new { id = result.BorrowId }, result);
    }

    /// <summary>
    /// Return a borrowed book
    /// </summary>
    /// <param name="borrowId">Borrow ID</param>
    /// <param name="input">Return data</param>
    /// <returns>Return result</returns>
    [HttpPost("{borrowId}/return")]
    [ProducesResponseType(typeof(ReturnResultDto), 200)]
    [ProducesResponseType(404)]
    [ProducesResponseType(400)]
    public async Task<ActionResult<ReturnResultDto>> ReturnBookAsync(
        Guid borrowId, [FromBody] ReturnBookDto input)
    {
        _logger.LogInformation("Processing return for borrow ID: {BorrowId}", borrowId);
        
        var result = await _bookBorrowingAppService.ReturnBookAsync(borrowId, input);
        
        if (result.FineAmount > 0)
        {
            _logger.LogInformation("Fine applied: {FineAmount}", result.FineAmount);
        }
        
        return Ok(result);
    }

    /// <summary>
    /// Renew borrowed book
    /// </summary>
    /// <param name="borrowId">Borrow ID</param>
    /// <returns>Renewal result</returns>
    [HttpPost("{borrowId}/renew")]
    [ProducesResponseType(typeof(RenewResultDto), 200)]
    [ProducesResponseType(404)]
    [ProducesResponseType(409)]
    public async Task<ActionResult<RenewResultDto>> RenewBookAsync(Guid borrowId)
    {
        _logger.LogInformation("Renewing book for borrow ID: {BorrowId}", borrowId);
        
        var result = await _bookBorrowingAppService.RenewBookAsync(borrowId);
        
        return Ok(result);
    }

    /// <summary>
    /// Get current user's borrowed books
    /// </summary>
    /// <param name="input">Query parameters</param>
    /// <returns>User's borrowed books</returns>
    [HttpGet("my-borrows")]
    [ProducesResponseType(typeof(PagedResultDto<UserBorrowDto>), 200)]
    public async Task<ActionResult<PagedResultDto<UserBorrowDto>>> GetMyBorrowsAsync(
        [FromQuery] GetUserBorrowsInput input)
    {
        var result = await _bookBorrowingAppService.GetUserBorrowsAsync(input);
        return Ok(result);
    }

    /// <summary>
    /// Check if user can borrow specific book
    /// </summary>
    /// <param name="bookId">Book ID</param>
    /// <returns>Borrowing eligibility</returns>
    [HttpGet("{bookId}/eligibility")]
    [ProducesResponseType(typeof(BorrowingEligibilityDto), 200)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<BorrowingEligibilityDto>> CheckEligibilityAsync(Guid bookId)
    {
        var eligibility = await _bookBorrowingAppService.CheckBorrowingEligibilityAsync(bookId);
        return Ok(eligibility);
    }

    /// <summary>
    /// Get borrow details by ID
    /// </summary>
    /// <param name="id">Borrow ID</param>
    /// <returns>Borrow details</returns>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(UserBorrowDto), 200)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<UserBorrowDto>> GetBorrowAsync(Guid id)
    {
        var borrow = await _bookBorrowingAppService.GetBorrowAsync(id);
        return Ok(borrow);
    }
}
```

### 3. Advanced Search Controller Implementation

```csharp
[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/app/book-search")]
[Authorize(BookManagementPermissions.Books.Search)]
public class BookSearchController : AbpControllerBase
{
    private readonly IBookSearchAppService _bookSearchAppService;
    private readonly ILogger<BookSearchController> _logger;

    /// <summary>
    /// Get search suggestions and autocomplete
    /// </summary>
    /// <param name="query">Search query</param>
    /// <param name="maxResults">Maximum results to return</param>
    /// <returns>Search suggestions</returns>
    [HttpGet("suggestions")]
    [ProducesResponseType(typeof(List<BookSuggestionDto>), 200)]
    public async Task<ActionResult<List<BookSuggestionDto>>> GetSuggestionsAsync(
        [FromQuery] string query, [FromQuery] int maxResults = 10)
    {
        if (string.IsNullOrWhiteSpace(query) || query.Length < 2)
        {
            return Ok(new List<BookSuggestionDto>());
        }

        var suggestions = await _bookSearchAppService.GetSuggestionsAsync(query, maxResults);
        return Ok(suggestions);
    }

    /// <summary>
    /// Advanced search with multiple criteria
    /// </summary>
    /// <param name="input">Advanced search parameters</param>
    /// <returns>Search results</returns>
    [HttpGet("advanced")]
    [ProducesResponseType(typeof(PagedResultDto<BookSearchResultDto>), 200)]
    [ProducesResponseType(400)]
    public async Task<ActionResult<PagedResultDto<BookSearchResultDto>>> AdvancedSearchAsync(
        [FromQuery] AdvancedSearchInput input)
    {
        _logger.LogInformation("Advanced search with query: {Query}", input.Query);
        
        var result = await _bookSearchAppService.AdvancedSearchAsync(input);
        
        _logger.LogInformation("Advanced search returned {Count} results", result.TotalCount);
        
        return Ok(result);
    }

    /// <summary>
    /// Get popular/trending books
    /// </summary>
    /// <param name="count">Number of books to return</param>
    /// <returns>Popular books</returns>
    [HttpGet("popular")]
    [ProducesResponseType(typeof(List<BookDto>), 200)]
    public async Task<ActionResult<List<BookDto>>> GetPopularBooksAsync(
        [FromQuery] int count = 20)
    {
        var books = await _bookSearchAppService.GetPopularBooksAsync(count);
        return Ok(books);
    }

    /// <summary>
    /// Get search statistics and analytics
    /// </summary>
    /// <returns>Search statistics</returns>
    [HttpGet("statistics")]
    [Authorize(BookManagementPermissions.Books.Reports)]
    [ProducesResponseType(typeof(SearchStatisticsDto), 200)]
    public async Task<ActionResult<SearchStatisticsDto>> GetSearchStatisticsAsync()
    {
        var statistics = await _bookSearchAppService.GetSearchStatisticsAsync();
        return Ok(statistics);
    }
}
```

## Middleware Implementation

### Exception Handling Middleware
```csharp
public class BookManagementExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<BookManagementExceptionMiddleware> _logger;

    public BookManagementExceptionMiddleware(
        RequestDelegate next,
        ILogger<BookManagementExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var response = context.Response;
        response.ContentType = "application/json";

        var errorResponse = exception switch
        {
            BookNotAvailableException ex => new ErrorResponse
            {
                StatusCode = 409,
                Code = "BOOK_NOT_AVAILABLE",
                Message = "The requested book is not available for borrowing",
                Details = ex.Message
            },
            BorrowingLimitExceededException ex => new ErrorResponse
            {
                StatusCode = 409,
                Code = "BORROWING_LIMIT_EXCEEDED",
                Message = "You have reached your borrowing limit",
                Details = ex.Message
            },
            ReservationExpiredException ex => new ErrorResponse
            {
                StatusCode = 410,
                Code = "RESERVATION_EXPIRED",
                Message = "The reservation has expired",
                Details = ex.Message
            },
            ValidationException ex => new ErrorResponse
            {
                StatusCode = 400,
                Code = "VALIDATION_ERROR",
                Message = "Input validation failed",
                Details = ex.Message,
                ValidationErrors = ex.Errors?.ToList()
            },
            _ => new ErrorResponse
            {
                StatusCode = 500,
                Code = "INTERNAL_ERROR",
                Message = "An internal server error occurred",
                Details = exception.Message
            }
        };

        response.StatusCode = errorResponse.StatusCode;

        _logger.LogError(exception, "Book Management API Error: {Code} - {Message}", 
            errorResponse.Code, errorResponse.Message);

        var jsonResponse = JsonSerializer.Serialize(errorResponse, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });

        await response.WriteAsync(jsonResponse);
    }
}
```

### Rate Limiting Middleware
```csharp
public class RateLimitingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IMemoryCache _cache;
    private readonly ILogger<RateLimitingMiddleware> _logger;

    private static readonly Dictionary<string, RateLimitRule> _rules = new()
    {
        { "search", new RateLimitRule { RequestsPerMinute = 20, BurstAllowance = 5 } },
        { "borrow", new RateLimitRule { RequestsPerMinute = 10, BurstAllowance = 2 } },
        { "default", new RateLimitRule { RequestsPerMinute = 100, BurstAllowance = 20 } }
    };

    public async Task InvokeAsync(HttpContext context)
    {
        var endpoint = context.GetEndpoint();
        var rateLimitKey = GetRateLimitKey(context);
        var rule = GetApplicableRule(context.Request.Path);

        if (await IsRateLimitExceededAsync(rateLimitKey, rule))
        {
            context.Response.StatusCode = 429;
            await context.Response.WriteAsync("Rate limit exceeded. Please try again later.");
            return;
        }

        await _next(context);
    }

    private async Task<bool> IsRateLimitExceededAsync(string key, RateLimitRule rule)
    {
        var currentCount = _cache.Get<int>($"rate_limit_{key}");
        
        if (currentCount >= rule.RequestsPerMinute)
        {
            return true;
        }

        var newCount = currentCount + 1;
        _cache.Set($"rate_limit_{key}", newCount, TimeSpan.FromMinutes(1));
        
        return false;
    }
}
```

## Swagger Configuration

```csharp
public static class SwaggerConfiguration
{
    public static void ConfigureSwagger(this ServiceCollection services)
    {
        services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new OpenApiInfo
            {
                Title = "Book Management API",
                Version = "v1",
                Description = "Comprehensive library management system API",
                Contact = new OpenApiContact
                {
                    Name = "Library Support",
                    Email = "support@library.example.com"
                }
            });

            // JWT Authentication
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Description = "JWT Authorization header using the Bearer scheme",
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer"
            });

            c.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    Array.Empty<string>()
                }
            });

            // XML Documentation
            var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
            var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
            c.IncludeXmlComments(xmlPath);

            // Custom operation filters
            c.OperationFilter<BookManagementOperationFilter>();
            c.SchemaFilter<BookManagementSchemaFilter>();

            // Examples
            c.EnableAnnotations();
        });
    }
}
```

## API Versioning Configuration

```csharp
public static class ApiVersioningConfiguration
{
    public static void ConfigureApiVersioning(this ServiceCollection services)
    {
        services.AddApiVersioning(opt =>
        {
            opt.DefaultApiVersion = new ApiVersion(1, 0);
            opt.AssumeDefaultVersionWhenUnspecified = true;
            opt.ApiVersionReader = ApiVersionReader.Combine(
                new UrlSegmentApiVersionReader(),
                new HeaderApiVersionReader("X-Version"),
                new MediaTypeApiVersionReader("ver")
            );
        });

        services.AddVersionedApiExplorer(setup =>
        {
            setup.GroupNameFormat = "'v'VVV";
            setup.SubstituteApiVersionInUrl = true;
        });
    }
}
```

## Response DTOs for API

```csharp
public class ApiResponse<T>
{
    public T Data { get; set; }
    public bool Success { get; set; } = true;
    public ErrorInfo Error { get; set; }
    public bool UnAuthorizedRequest { get; set; }
    public bool __Abp { get; set; } = true;
}

public class ErrorResponse
{
    public int StatusCode { get; set; }
    public string Code { get; set; }
    public string Message { get; set; }
    public string Details { get; set; }
    public List<ValidationError> ValidationErrors { get; set; }
    public Dictionary<string, object> Data { get; set; }
}

public class ValidationError
{
    public string Message { get; set; }
    public string[] Members { get; set; }
}
```

## Performance Monitoring

```csharp
public class PerformanceLoggingFilter : IActionFilter
{
    private readonly ILogger<PerformanceLoggingFilter> _logger;
    private readonly Stopwatch _stopwatch;

    public void OnActionExecuting(ActionExecutingContext context)
    {
        _stopwatch = Stopwatch.StartNew();
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        _stopwatch.Stop();
        var elapsedTime = _stopwatch.ElapsedMilliseconds;

        var actionName = context.ActionDescriptor.DisplayName;
        var controllerName = context.Controller.GetType().Name;

        if (elapsedTime > 1000) // Log slow requests
        {
            _logger.LogWarning("Slow API call: {Controller}.{Action} took {ElapsedTime}ms",
                controllerName, actionName, elapsedTime);
        }
        else
        {
            _logger.LogInformation("API call: {Controller}.{Action} completed in {ElapsedTime}ms",
                controllerName, actionName, elapsedTime);
        }

        // Add response header
        context.HttpContext.Response.Headers.Add("X-Response-Time", $"{elapsedTime}ms");
    }
}
```

This generated Backend API provides a comprehensive, well-documented REST API that follows ABP Framework conventions and modern API design principles while ensuring proper error handling, security, and performance monitoring.