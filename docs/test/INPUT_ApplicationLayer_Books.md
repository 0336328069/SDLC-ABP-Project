# Application Layer Input - Book Management

Đây là file input cho Application Layer generation của tính năng Quản lý Sách. Application Layer sẽ được build dựa trên Domain Model và Domain Services đã có.

## Application Layer Requirements

### Core Application Services Needed

1. **BookManagementAppService**: CRUD operations cho sách
2. **BookSearchAppService**: Tìm kiếm và lọc sách nâng cao
3. **BookBorrowingAppService**: Xử lý mượn/trả sách
4. **BookReservationAppService**: Quản lý đặt chỗ sách
5. **CategoryManagementAppService**: Quản lý thể loại sách
6. **FineManagementAppService**: Xử lý phạt và thanh toán
7. **LibraryReportingAppService**: Báo cáo và thống kê
8. **UserLibraryAppService**: Dashboard người dùng

### Technology Context

- **Framework**: ABP Framework 8.3.0
- **Language**: C# 12
- **Database**: SQL Server 2019+ / PostgreSQL 15+
- **ORM**: Entity Framework Core 9.0
- **Caching**: Redis 7.0
- **Validation**: FluentValidation
- **Mapping**: AutoMapper
- **Authorization**: ABP Permission System

### Existing Dependencies

#### Domain Layer Available:
- Domain entities: Book, Category, BookReservation, BookBorrow, Fine
- Value objects: ISBN, BookTitle, Author, BookInventory, etc.
- Domain services: BookBorrowingService, FineCalculationService, etc.
- Repository interfaces: IBookRepository, ICategoryRepository, etc.

#### Infrastructure Available:
- Entity Framework implementations of repositories
- Database context with all entities
- Redis cache configuration
- Email service for notifications

## Application Service Specifications

### 1. BookManagementAppService

#### Purpose:
Administrative CRUD operations for book catalog management by librarians and admins.

#### Key Methods Required:
```csharp
Task<BookDto> CreateAsync(CreateBookDto input)
Task<BookDto> UpdateAsync(Guid id, UpdateBookDto input)
Task DeleteAsync(Guid id)
Task<BookDto> GetAsync(Guid id)
Task<PagedResultDto<BookDto>> GetListAsync(GetBooksInput input)
Task<List<BookDto>> GetBooksInCategoryAsync(Guid categoryId)
Task UpdateInventoryAsync(Guid bookId, UpdateInventoryDto input)
```

#### Business Rules to Implement:
- Only librarians/admins can create/update/delete books
- ISBN must be unique across the system
- Cannot delete books that are currently borrowed or reserved
- Inventory updates must maintain data consistency
- All changes must be audited

#### DTOs Needed:
- CreateBookDto, UpdateBookDto, BookDto
- GetBooksInput (with filtering and pagination)
- UpdateInventoryDto

### 2. BookSearchAppService

#### Purpose:
Advanced search and filtering capabilities for all users.

#### Key Methods Required:
```csharp
Task<PagedResultDto<BookSearchResultDto>> SearchAsync(BookSearchInput input)
Task<List<BookSuggestionDto>> GetSuggestionsAsync(string query)
Task<List<CategoryDto>> GetCategoriesAsync()
Task<List<AuthorDto>> GetPopularAuthorsAsync()
Task<SearchStatisticsDto> GetSearchStatisticsAsync()
```

#### Search Features:
- Full-text search across title, author, description
- Advanced filtering by category, publication year, availability
- Sorting options (relevance, title, author, publication date)
- Auto-suggestions and spell correction
- Search result highlighting
- Performance optimization for large datasets

#### DTOs Needed:
- BookSearchInput, BookSearchResultDto
- BookSuggestionDto, SearchStatisticsDto

### 3. BookBorrowingAppService

#### Purpose:
Handle all borrowing and returning operations for users.

#### Key Methods Required:
```csharp
Task<BorrowResultDto> BorrowBookAsync(Guid bookId)
Task<BorrowResultDto> BorrowWithReservationAsync(Guid reservationId)
Task<ReturnResultDto> ReturnBookAsync(Guid borrowId, ReturnBookDto input)
Task<RenewResultDto> RenewBookAsync(Guid borrowId)
Task<PagedResultDto<UserBorrowDto>> GetUserBorrowsAsync(GetUserBorrowsInput input)
Task<BorrowingEligibilityDto> CheckBorrowingEligibilityAsync(Guid bookId)
```

#### Business Logic:
- Validate user borrowing limits
- Check book availability
- Calculate due dates based on book type and user membership
- Handle fine restrictions
- Process renewals with validation
- Integration with reservation system

#### DTOs Needed:
- BorrowResultDto, ReturnResultDto, RenewResultDto
- ReturnBookDto, UserBorrowDto
- BorrowingEligibilityDto, GetUserBorrowsInput

### 4. BookReservationAppService

#### Purpose:
Manage book reservations and waiting queues.

#### Key Methods Required:
```csharp
Task<ReservationResultDto> CreateReservationAsync(Guid bookId)
Task CancelReservationAsync(Guid reservationId)
Task<PagedResultDto<UserReservationDto>> GetUserReservationsAsync()
Task<QueueStatusDto> GetQueueStatusAsync(Guid bookId)
Task ProcessExpiredReservationsAsync()
Task NotifyAvailableReservationsAsync()
```

#### Queue Management:
- FIFO queue with priority by user type
- Automatic expiration after 24 hours
- Email notifications when books become available
- Queue position tracking
- Maximum queue length enforcement

#### DTOs Needed:
- ReservationResultDto, UserReservationDto
- QueueStatusDto

### 5. CategoryManagementAppService

#### Purpose:
Manage book categories and hierarchical organization.

#### Key Methods Required:
```csharp
Task<CategoryDto> CreateAsync(CreateCategoryDto input)
Task<CategoryDto> UpdateAsync(Guid id, UpdateCategoryDto input)
Task DeleteAsync(Guid id)
Task<List<CategoryDto>> GetAllAsync()
Task<List<CategoryDto>> GetCategoryTreeAsync()
Task<CategoryStatisticsDto> GetCategoryStatisticsAsync(Guid categoryId)
```

#### Category Features:
- Hierarchical category structure
- Category statistics (book count, popularity)
- Bulk category operations
- Category tree visualization support

#### DTOs Needed:
- CreateCategoryDto, UpdateCategoryDto, CategoryDto
- CategoryStatisticsDto

### 6. FineManagementAppService

#### Purpose:
Handle fines, payments, and financial tracking.

#### Key Methods Required:
```csharp
Task<PagedResultDto<UserFineDto>> GetUserFinesAsync(GetUserFinesInput input)
Task<PaymentResultDto> PayFineAsync(Guid fineId, PayFineDto input)
Task<WaiverResultDto> WaiveFineAsync(Guid fineId, WaiveFineDto input)
Task<FineCalculationDto> CalculatePotentialFineAsync(Guid borrowId)
Task<FineStatisticsDto> GetFineStatisticsAsync(GetFineStatisticsInput input)
```

#### Fine Management:
- Automatic fine calculation for overdue books
- Payment processing integration
- Fine waiver approval workflow
- Damage assessment fines
- Financial reporting

#### DTOs Needed:
- UserFineDto, PayFineDto, WaiveFineDto
- PaymentResultDto, WaiverResultDto
- FineCalculationDto, FineStatisticsDto

### 7. LibraryReportingAppService

#### Purpose:
Generate reports and analytics for library management.

#### Key Methods Required:
```csharp
Task<PopularBooksReportDto> GetPopularBooksReportAsync(ReportPeriodInput input)
Task<UserActivityReportDto> GetUserActivityReportAsync(ReportPeriodInput input)
Task<InventoryReportDto> GetInventoryReportAsync()
Task<FinancialReportDto> GetFinancialReportAsync(ReportPeriodInput input)
Task<SystemUsageReportDto> GetSystemUsageReportAsync(ReportPeriodInput input)
Task<byte[]> ExportReportAsync(ExportReportInput input)
```

#### Reporting Features:
- Most borrowed books analysis
- User engagement metrics
- Inventory turnover reports
- Financial performance tracking
- System usage analytics
- Export capabilities (PDF, Excel, CSV)

#### DTOs Needed:
- Various report DTOs for different report types
- ReportPeriodInput, ExportReportInput

### 8. UserLibraryAppService

#### Purpose:
User dashboard and personal library management.

#### Key Methods Required:
```csharp
Task<UserDashboardDto> GetUserDashboardAsync()
Task<PagedResultDto<UserBorrowHistoryDto>> GetBorrowHistoryAsync(GetBorrowHistoryInput input)
Task<List<UserReservationDto>> GetActiveReservationsAsync()
Task<UserStatisticsDto> GetUserStatisticsAsync()
Task<List<RecommendationDto>> GetRecommendationsAsync()
Task UpdatePreferencesAsync(UpdateUserPreferencesDto input)
```

#### Dashboard Features:
- Current borrowed books with due dates
- Active reservations with queue positions
- Outstanding fines
- Reading history and statistics
- Personalized book recommendations
- User preferences management

#### DTOs Needed:
- UserDashboardDto, UserBorrowHistoryDto
- UserStatisticsDto, RecommendationDto
- UpdateUserPreferencesDto

## Cross-Cutting Concerns

### Authorization Requirements

#### Permissions Structure:
```
Books.Dashboard (All authenticated users)
Books.Search (All authenticated users)
Books.Borrow (Library members)
Books.Reserve (Library members)
Books.Manage (Librarians, Admins)
Books.Reports (Librarians, Admins)
Books.Fines.Manage (Librarians, Admins)
Books.System.Admin (Admins only)
```

#### Role-Based Access:
- **Guests**: Search and view only
- **Members**: Search, borrow, reserve, view personal data
- **Librarians**: All member permissions + book management + fine processing
- **Admins**: All permissions + system configuration + advanced reports

### Validation Requirements

#### Input Validation:
- All DTOs must have comprehensive validation
- Business rule validation at application layer
- Security validation (SQL injection, XSS prevention)
- Data type and format validation
- Authorization validation

#### Validation Examples:
```csharp
// CreateBookDto validation
- ISBN: Required, valid format, unique
- Title: Required, 3-200 characters
- Authors: Required, at least one author
- Publication Date: Valid date, not in future
- Quantity: Positive integer
```

### Error Handling Strategy

#### Exception Types:
- BusinessException: For business rule violations
- EntityNotFoundException: When entities don't exist
- UnauthorizedException: For permission violations
- ValidationException: For input validation failures
- DuplicateEntityException: For uniqueness violations

#### Error Response Format:
```json
{
  "error": {
    "code": "BOOK_NOT_AVAILABLE",
    "message": "The requested book is not available for borrowing",
    "details": "Book is currently reserved by another user",
    "validationErrors": []
  }
}
```

### Performance Requirements

#### Caching Strategy:
- Cache frequently accessed book information
- Cache category hierarchies
- Cache user borrowing limits and preferences
- Cache search results with appropriate TTL
- Implement cache invalidation on data changes

#### Query Optimization:
- Use specifications pattern for complex queries
- Implement pagination for all list operations
- Use AsNoTracking() for read-only operations
- Optimize database queries with proper indexing
- Implement async operations throughout

### Integration Points

#### Domain Layer Integration:
- Use domain services for complex business logic
- Publish domain events for state changes
- Respect aggregate boundaries
- Implement Unit of Work pattern

#### Infrastructure Integration:
- Email service for notifications
- File storage for book covers and documents
- Payment gateway for fine payments
- External APIs for book metadata
- Audit logging for all operations

### Testing Requirements

#### Unit Testing:
- Test all business logic in application services
- Mock repository and domain service dependencies
- Validate input/output mappings
- Test authorization and validation logic
- Achieve minimum 80% code coverage

#### Integration Testing:
- Test complete workflows end-to-end
- Validate database operations
- Test email notification delivery
- Verify caching behavior
- Performance testing for large datasets

This Application Layer specification provides comprehensive coverage for the Book Management system while maintaining clean architecture principles and ABP Framework best practices.