# Backend API Input - Book Management

Đây là file input cho Backend API generation của tính năng Quản lý Sách. API sẽ được build trên Application Layer đã có.

## API Requirements Specification

### Technology Stack Context

- **Framework**: ASP.NET Core Web API với ABP Framework 8.3.0
- **Authentication**: JWT Bearer Tokens
- **Authorization**: ABP Permission System
- **Documentation**: Swagger/OpenAPI 3.0
- **Validation**: Model validation với DataAnnotations và FluentValidation
- **Error Handling**: ABP Exception Handling
- **Versioning**: API Versioning support
- **Rate Limiting**: Request throttling
- **CORS**: Cross-origin support cho frontend

### API Architecture Principles

- RESTful design patterns
- Consistent response formats
- Proper HTTP status codes
- Resource-based URLs
- Stateless operations
- Idempotent operations where applicable

## Controller Specifications

### 1. BookController

#### Base Route: `/api/app/books`

#### Endpoints:

**GET /api/app/books**

- **Purpose**: Get paginated list of books with search and filtering
- **Authorization**: `Books.Search` permission
- **Parameters**:
  ```csharp
  [FromQuery] GetBooksInput input
  // Includes: SearchTerm, CategoryId, AuthorName, IsAvailable,
  // PublicationYearFrom, PublicationYearTo, SkipCount, MaxResultCount
  ```
- **Response**: `PagedResultDto<BookDto>`
- **Status Codes**: 200 OK, 400 Bad Request, 401 Unauthorized

**GET /api/app/books/{id}**

- **Purpose**: Get detailed book information
- **Authorization**: `Books.Search` permission
- **Parameters**: `Guid id`
- **Response**: `BookDto`
- **Status Codes**: 200 OK, 404 Not Found, 401 Unauthorized

**POST /api/app/books**

- **Purpose**: Create new book (Admin/Librarian only)
- **Authorization**: `Books.Manage` permission
- **Body**: `CreateBookDto`
- **Response**: `BookDto`
- **Status Codes**: 201 Created, 400 Bad Request, 403 Forbidden

**PUT /api/app/books/{id}**

- **Purpose**: Update existing book
- **Authorization**: `Books.Manage` permission
- **Parameters**: `Guid id`
- **Body**: `UpdateBookDto`
- **Response**: `BookDto`
- **Status Codes**: 200 OK, 404 Not Found, 400 Bad Request, 403 Forbidden

**DELETE /api/app/books/{id}**

- **Purpose**: Delete book (if not borrowed/reserved)
- **Authorization**: `Books.Manage` permission
- **Parameters**: `Guid id`
- **Response**: No content
- **Status Codes**: 204 No Content, 404 Not Found, 409 Conflict, 403 Forbidden

**PUT /api/app/books/{id}/inventory**

- **Purpose**: Update book inventory quantities
- **Authorization**: `Books.Manage` permission
- **Parameters**: `Guid id`
- **Body**: `UpdateInventoryDto`
- **Response**: `BookDto`
- **Status Codes**: 200 OK, 404 Not Found, 400 Bad Request, 403 Forbidden

**GET /api/app/books/{id}/availability**

- **Purpose**: Check real-time book availability
- **Authorization**: `Books.Search` permission
- **Parameters**: `Guid id`
- **Response**: `BookAvailabilityDto`
- **Status Codes**: 200 OK, 404 Not Found

### 2. BookSearchController

#### Base Route: `/api/app/book-search`

**GET /api/app/book-search/suggestions**

- **Purpose**: Get search suggestions and autocomplete
- **Authorization**: `Books.Search` permission
- **Parameters**: `[FromQuery] string query, int maxResults = 10`
- **Response**: `List<BookSuggestionDto>`
- **Status Codes**: 200 OK

**GET /api/app/book-search/advanced**

- **Purpose**: Advanced search with multiple criteria
- **Authorization**: `Books.Search` permission
- **Parameters**: `[FromQuery] AdvancedSearchInput input`
- **Response**: `PagedResultDto<BookSearchResultDto>`
- **Status Codes**: 200 OK, 400 Bad Request

**GET /api/app/book-search/popular**

- **Purpose**: Get popular/trending books
- **Authorization**: `Books.Search` permission
- **Parameters**: `[FromQuery] int count = 20`
- **Response**: `List<BookDto>`
- **Status Codes**: 200 OK

### 3. BookBorrowingController

#### Base Route: `/api/app/book-borrowing`

**POST /api/app/book-borrowing/borrow**

- **Purpose**: Borrow a book
- **Authorization**: `Books.Borrow` permission
- **Body**: `BorrowBookDto { BookId: Guid }`
- **Response**: `BorrowResultDto`
- **Status Codes**: 201 Created, 400 Bad Request, 409 Conflict

**POST /api/app/book-borrowing/borrow-with-reservation**

- **Purpose**: Convert reservation to borrow
- **Authorization**: `Books.Borrow` permission
- **Body**: `BorrowWithReservationDto { ReservationId: Guid }`
- **Response**: `BorrowResultDto`
- **Status Codes**: 201 Created, 400 Bad Request, 404 Not Found

**POST /api/app/book-borrowing/{borrowId}/return**

- **Purpose**: Return a borrowed book
- **Authorization**: `Books.Borrow` permission (own books) or `Books.Manage`
- **Parameters**: `Guid borrowId`
- **Body**: `ReturnBookDto`
- **Response**: `ReturnResultDto`
- **Status Codes**: 200 OK, 404 Not Found, 400 Bad Request

**POST /api/app/book-borrowing/{borrowId}/renew**

- **Purpose**: Renew borrowed book
- **Authorization**: `Books.Borrow` permission
- **Parameters**: `Guid borrowId`
- **Response**: `RenewResultDto`
- **Status Codes**: 200 OK, 404 Not Found, 409 Conflict

**GET /api/app/book-borrowing/my-borrows**

- **Purpose**: Get current user's borrowed books
- **Authorization**: `Books.Borrow` permission
- **Parameters**: `[FromQuery] GetUserBorrowsInput input`
- **Response**: `PagedResultDto<UserBorrowDto>`
- **Status Codes**: 200 OK

**GET /api/app/book-borrowing/{bookId}/eligibility**

- **Purpose**: Check if user can borrow specific book
- **Authorization**: `Books.Borrow` permission
- **Parameters**: `Guid bookId`
- **Response**: `BorrowingEligibilityDto`
- **Status Codes**: 200 OK, 404 Not Found

### 4. BookReservationController

#### Base Route: `/api/app/book-reservations`

**POST /api/app/book-reservations**

- **Purpose**: Create book reservation
- **Authorization**: `Books.Reserve` permission
- **Body**: `CreateReservationDto { BookId: Guid }`
- **Response**: `ReservationResultDto`
- **Status Codes**: 201 Created, 400 Bad Request, 409 Conflict

**DELETE /api/app/book-reservations/{id}**

- **Purpose**: Cancel reservation
- **Authorization**: `Books.Reserve` permission (own) or `Books.Manage`
- **Parameters**: `Guid id`
- **Response**: No content
- **Status Codes**: 204 No Content, 404 Not Found, 403 Forbidden

**GET /api/app/book-reservations/my-reservations**

- **Purpose**: Get current user's reservations
- **Authorization**: `Books.Reserve` permission
- **Response**: `List<UserReservationDto>`
- **Status Codes**: 200 OK

**GET /api/app/book-reservations/{bookId}/queue**

- **Purpose**: Get reservation queue status for book
- **Authorization**: `Books.Search` permission
- **Parameters**: `Guid bookId`
- **Response**: `QueueStatusDto`
- **Status Codes**: 200 OK, 404 Not Found

### 5. CategoryController

#### Base Route: `/api/app/categories`

**GET /api/app/categories**

- **Purpose**: Get all categories
- **Authorization**: `Books.Search` permission
- **Response**: `List<CategoryDto>`
- **Status Codes**: 200 OK

**GET /api/app/categories/tree**

- **Purpose**: Get categories in hierarchical tree structure
- **Authorization**: `Books.Search` permission
- **Response**: `List<CategoryTreeDto>`
- **Status Codes**: 200 OK

**POST /api/app/categories**

- **Purpose**: Create new category
- **Authorization**: `Books.Manage` permission
- **Body**: `CreateCategoryDto`
- **Response**: `CategoryDto`
- **Status Codes**: 201 Created, 400 Bad Request, 403 Forbidden

**PUT /api/app/categories/{id}**

- **Purpose**: Update category
- **Authorization**: `Books.Manage` permission
- **Parameters**: `Guid id`
- **Body**: `UpdateCategoryDto`
- **Response**: `CategoryDto`
- **Status Codes**: 200 OK, 404 Not Found, 400 Bad Request, 403 Forbidden

**DELETE /api/app/categories/{id}**

- **Purpose**: Delete category
- **Authorization**: `Books.Manage` permission
- **Parameters**: `Guid id`
- **Response**: No content
- **Status Codes**: 204 No Content, 404 Not Found, 409 Conflict, 403 Forbidden

### 6. FineController

#### Base Route: `/api/app/fines`

**GET /api/app/fines/my-fines**

- **Purpose**: Get current user's fines
- **Authorization**: `Books.Dashboard` permission
- **Parameters**: `[FromQuery] GetUserFinesInput input`
- **Response**: `PagedResultDto<UserFineDto>`
- **Status Codes**: 200 OK

**POST /api/app/fines/{id}/pay**

- **Purpose**: Pay fine
- **Authorization**: `Books.Dashboard` permission (own) or `Books.Fines.Manage`
- **Parameters**: `Guid id`
- **Body**: `PayFineDto`
- **Response**: `PaymentResultDto`
- **Status Codes**: 200 OK, 404 Not Found, 400 Bad Request

**POST /api/app/fines/{id}/waive**

- **Purpose**: Waive fine (Librarian/Admin)
- **Authorization**: `Books.Fines.Manage` permission
- **Parameters**: `Guid id`
- **Body**: `WaiveFineDto`
- **Response**: `WaiverResultDto`
- **Status Codes**: 200 OK, 404 Not Found, 403 Forbidden

**GET /api/app/fines/{borrowId}/calculate**

- **Purpose**: Calculate potential fine for borrow
- **Authorization**: `Books.Dashboard` permission
- **Parameters**: `Guid borrowId`
- **Response**: `FineCalculationDto`
- **Status Codes**: 200 OK, 404 Not Found

### 7. LibraryReportsController

#### Base Route: `/api/app/library-reports`

**GET /api/app/library-reports/popular-books**

- **Purpose**: Get popular books report
- **Authorization**: `Books.Reports` permission
- **Parameters**: `[FromQuery] ReportPeriodInput input`
- **Response**: `PopularBooksReportDto`
- **Status Codes**: 200 OK, 403 Forbidden

**GET /api/app/library-reports/user-activity**

- **Purpose**: Get user activity report
- **Authorization**: `Books.Reports` permission
- **Parameters**: `[FromQuery] ReportPeriodInput input`
- **Response**: `UserActivityReportDto`
- **Status Codes**: 200 OK, 403 Forbidden

**GET /api/app/library-reports/inventory**

- **Purpose**: Get inventory report
- **Authorization**: `Books.Reports` permission
- **Response**: `InventoryReportDto`
- **Status Codes**: 200 OK, 403 Forbidden

**GET /api/app/library-reports/financial**

- **Purpose**: Get financial report
- **Authorization**: `Books.Reports` permission
- **Parameters**: `[FromQuery] ReportPeriodInput input`
- **Response**: `FinancialReportDto`
- **Status Codes**: 200 OK, 403 Forbidden

**POST /api/app/library-reports/export**

- **Purpose**: Export report to file
- **Authorization**: `Books.Reports` permission
- **Body**: `ExportReportInput`
- **Response**: `FileResult` (PDF/Excel/CSV)
- **Status Codes**: 200 OK, 400 Bad Request, 403 Forbidden

### 8. UserLibraryController

#### Base Route: `/api/app/user-library`

**GET /api/app/user-library/dashboard**

- **Purpose**: Get user dashboard data
- **Authorization**: `Books.Dashboard` permission
- **Response**: `UserDashboardDto`
- **Status Codes**: 200 OK, 401 Unauthorized

**GET /api/app/user-library/borrow-history**

- **Purpose**: Get user's borrowing history
- **Authorization**: `Books.Dashboard` permission
- **Parameters**: `[FromQuery] GetBorrowHistoryInput input`
- **Response**: `PagedResultDto<UserBorrowHistoryDto>`
- **Status Codes**: 200 OK

**GET /api/app/user-library/statistics**

- **Purpose**: Get user's reading statistics
- **Authorization**: `Books.Dashboard` permission
- **Response**: `UserStatisticsDto`
- **Status Codes**: 200 OK

**GET /api/app/user-library/recommendations**

- **Purpose**: Get personalized book recommendations
- **Authorization**: `Books.Dashboard` permission
- **Response**: `List<RecommendationDto>`
- **Status Codes**: 200 OK

**PUT /api/app/user-library/preferences**

- **Purpose**: Update user preferences
- **Authorization**: `Books.Dashboard` permission
- **Body**: `UpdateUserPreferencesDto`
- **Response**: `UserPreferencesDto`
- **Status Codes**: 200 OK, 400 Bad Request

## API Response Standards

### Success Response Format

```json
{
  "data": {
    // Actual response data
  },
  "success": true,
  "error": null,
  "unAuthorizedRequest": false,
  "__abp": true
}
```

### Error Response Format

```json
{
  "error": {
    "code": "BUSINESS_RULE_VIOLATION",
    "message": "User has reached borrowing limit",
    "details": "Maximum 5 books can be borrowed simultaneously",
    "data": {},
    "validationErrors": [
      {
        "message": "Book is not available",
        "members": ["BookId"]
      }
    ]
  },
  "success": false,
  "unAuthorizedRequest": false,
  "__abp": true
}
```

### Pagination Response Format

```json
{
  "totalCount": 150,
  "items": [
    // Array of items
  ]
}
```

## Security & Validation

### Authentication

- All endpoints require valid JWT token except public search
- Token should include user ID and permissions
- Token expiration handling

### Authorization

- Permission-based access control
- Role-based endpoint access
- Resource ownership validation
- Cross-tenant data isolation

### Input Validation

```csharp
// Example validation for CreateBookDto
public class CreateBookDto
{
    [Required]
    [StringLength(17, MinimumLength = 10)]
    public string ISBN { get; set; }

    [Required]
    [StringLength(200, MinimumLength = 3)]
    public string Title { get; set; }

    [Required]
    [MinLength(1)]
    public List<string> Authors { get; set; }

    [Range(1, int.MaxValue)]
    public int Quantity { get; set; }

    [DataType(DataType.Date)]
    public DateTime PublicationDate { get; set; }
}
```

### Rate Limiting

- 100 requests per minute per user for standard operations
- 20 requests per minute for search operations
- 10 requests per minute for report generation
- Burst allowance for short periods

## Performance Requirements

### Response Time Targets

- Simple GET operations: < 200ms
- Search operations: < 1000ms
- Complex reports: < 5000ms
- File exports: < 30000ms

### Caching Strategy

- Cache frequently accessed book data (30 minutes TTL)
- Cache category trees (1 hour TTL)
- Cache user permissions (15 minutes TTL)
- Cache search results (5 minutes TTL)

### Database Optimization

- Use pagination for all list endpoints
- Implement efficient query patterns
- Use AsNoTracking for read-only operations
- Optimize joins and includes

## Error Handling

### Custom Exception Types

```csharp
- BookNotAvailableException (HTTP 409)
- BorrowingLimitExceededException (HTTP 409)
- ReservationExpiredException (HTTP 410)
- InvalidISBNException (HTTP 400)
- InsufficientPermissionsException (HTTP 403)
```

### HTTP Status Code Usage

- 200 OK: Successful GET, PUT operations
- 201 Created: Successful POST operations
- 204 No Content: Successful DELETE operations
- 400 Bad Request: Invalid input data
- 401 Unauthorized: Missing or invalid authentication
- 403 Forbidden: Insufficient permissions
- 404 Not Found: Resource doesn't exist
- 409 Conflict: Business rule violation
- 410 Gone: Resource expired/no longer available
- 429 Too Many Requests: Rate limit exceeded
- 500 Internal Server Error: Unexpected server errors

## Documentation & Testing

### Swagger Configuration

- Complete API documentation
- Request/response examples
- Authentication requirements
- Error response examples
- Try-it-out functionality

### API Testing Requirements

- Unit tests for all controllers
- Integration tests for workflows
- Performance testing for endpoints
- Security testing for authorization
- Load testing for concurrent users

This Backend API specification provides comprehensive REST endpoints for the Book Management system following ABP Framework conventions and modern API design principles.
