# Generated Application Layer Files - Book Management

Đây là file mô phỏng output từ Application Layer generation để làm input cho các META prompt khác. File này thể hiện Application Layer đã được generate cho tính năng Quản lý Sách.

## Application Layer Overview

Application Layer đã được generate với đầy đủ các Application Services, DTOs, AutoMapper profiles, và validation logic. Tầng này kết nối Domain Layer với Infrastructure và Presentation Layer.

### Generated Application Services

1. **BookManagementAppService**: CRUD operations cho Book entities
2. **BookSearchAppService**: Advanced search và filtering
3. **BookBorrowingAppService**: Borrowing workflows
4. **BookReservationAppService**: Reservation management
5. **CategoryManagementAppService**: Category operations
6. **FineManagementAppService**: Fine processing
7. **LibraryReportingAppService**: Reports và analytics
8. **UserLibraryAppService**: User dashboard và personal management

## Generated Files Structure

```
src/AbpApp.Application/Books/
├── Services/
│   ├── BookManagementAppService.cs
│   ├── BookSearchAppService.cs
│   ├── BookBorrowingAppService.cs
│   ├── BookReservationAppService.cs
│   ├── CategoryManagementAppService.cs
│   ├── FineManagementAppService.cs
│   ├── LibraryReportingAppService.cs
│   └── UserLibraryAppService.cs
├── Specifications/
│   ├── BookSearchSpecification.cs
│   ├── UserBorrowsSpecification.cs
│   ├── OverdueBooksSpecification.cs
│   └── PopularBooksSpecification.cs
└── BookManagementApplicationAutoMapperProfile.cs

src/AbpApp.Application.Contracts/Books/
├── Dtos/
│   ├── Books/
│   │   ├── BookDto.cs
│   │   ├── CreateBookDto.cs
│   │   ├── UpdateBookDto.cs
│   │   ├── BookSearchResultDto.cs
│   │   └── BookAvailabilityDto.cs
│   ├── Borrowing/
│   │   ├── BorrowResultDto.cs
│   │   ├── UserBorrowDto.cs
│   │   ├── ReturnBookDto.cs
│   │   └── RenewResultDto.cs
│   ├── Reservations/
│   │   ├── ReservationResultDto.cs
│   │   ├── UserReservationDto.cs
│   │   └── QueueStatusDto.cs
│   ├── Categories/
│   │   ├── CategoryDto.cs
│   │   ├── CreateCategoryDto.cs
│   │   └── CategoryTreeDto.cs
│   ├── Fines/
│   │   ├── UserFineDto.cs
│   │   ├── PayFineDto.cs
│   │   └── FineCalculationDto.cs
│   ├── Reports/
│   │   ├── PopularBooksReportDto.cs
│   │   ├── UserActivityReportDto.cs
│   │   └── InventoryReportDto.cs
│   └── UserLibrary/
│       ├── UserDashboardDto.cs
│       ├── UserStatisticsDto.cs
│       └── RecommendationDto.cs
├── Interfaces/
│   ├── IBookManagementAppService.cs
│   ├── IBookSearchAppService.cs
│   ├── IBookBorrowingAppService.cs
│   ├── IBookReservationAppService.cs
│   ├── ICategoryManagementAppService.cs
│   ├── IFineManagementAppService.cs
│   ├── ILibraryReportingAppService.cs
│   └── IUserLibraryAppService.cs
└── Permissions/
    └── BookManagementPermissions.cs
```

## Key Implementation Highlights

### 1. BookManagementAppService Implementation

```csharp
[Authorize(BookManagementPermissions.Books.Manage)]
public class BookManagementAppService : ApplicationService, IBookManagementAppService
{
    private readonly IBookRepository _bookRepository;
    private readonly ICategoryRepository _categoryRepository;
    private readonly BookBorrowingService _borrowingService;
    private readonly IDistributedEventBus _eventBus;

    public async Task<BookDto> CreateAsync(CreateBookDto input)
    {
        // ISBN uniqueness validation
        var existingBook = await _bookRepository.FindByISBNAsync(input.ISBN);
        if (existingBook != null)
        {
            throw new BusinessException("DUPLICATE_ISBN")
                .WithData("ISBN", input.ISBN);
        }

        // Create book entity with value objects
        var book = new Book(
            GuidGenerator.Create(),
            new ISBN(input.ISBN),
            new BookTitle(input.Title),
            input.Authors.Select(a => new Author(a)).ToList(),
            input.Publisher,
            new PublicationDate(input.PublicationDate),
            (BookType)input.BookType
        );

        // Add categories
        foreach (var categoryId in input.CategoryIds)
        {
            book.AddCategory(categoryId);
        }

        // Set initial inventory
        book.UpdateInventory(input.Quantity, input.Quantity);

        await _bookRepository.InsertAsync(book);
        await UnitOfWorkManager.Current.SaveChangesAsync();

        // Publish domain event
        await _eventBus.PublishAsync(new BookAddedEventData
        {
            BookId = book.Id,
            ISBN = book.ISBN.Value,
            Title = book.Title.Value,
            AddedBy = CurrentUser.Id
        });

        return ObjectMapper.Map<Book, BookDto>(book);
    }

    public async Task<PagedResultDto<BookDto>> GetListAsync(GetBooksInput input)
    {
        var specification = new BookSearchSpecification(
            input.SearchTerm,
            input.CategoryId,
            input.AuthorName,
            input.IsAvailable,
            input.PublicationYearFrom,
            input.PublicationYearTo
        )
        .WithPaging(input.SkipCount, input.MaxResultCount)
        .WithSorting(input.Sorting);

        var books = await _bookRepository.GetPagedListAsync(specification);
        var totalCount = await _bookRepository.GetCountAsync(specification);

        return new PagedResultDto<BookDto>(
            totalCount,
            ObjectMapper.Map<List<Book>, List<BookDto>>(books)
        );
    }
}
```

### 2. BookBorrowingAppService Implementation

```csharp
public class BookBorrowingAppService : ApplicationService, IBookBorrowingAppService
{
    public async Task<BorrowResultDto> BorrowBookAsync(Guid bookId)
    {
        // Validate borrowing eligibility
        var eligibility = await _borrowingService.CheckBorrowingEligibilityAsync(
            CurrentUser.Id.Value, bookId);
        
        if (!eligibility.CanBorrow)
        {
            throw new BusinessException("CANNOT_BORROW_BOOK")
                .WithData("Reason", eligibility.Reason);
        }

        // Process borrowing
        var borrow = await _borrowingService.ProcessBorrowAsync(
            CurrentUser.Id.Value, bookId);

        // Update book availability
        var book = await _bookRepository.GetAsync(bookId);
        book.UpdateInventory(
            book.Inventory.TotalQuantity,
            book.Inventory.AvailableQuantity - 1
        );

        await UnitOfWorkManager.Current.SaveChangesAsync();

        // Publish event for notifications
        await _eventBus.PublishAsync(new BookBorrowedEventData
        {
            BorrowId = borrow.Id,
            UserId = borrow.UserId,
            BookId = borrow.BookId,
            DueDate = borrow.DueDate
        });

        return ObjectMapper.Map<BookBorrow, BorrowResultDto>(borrow);
    }

    public async Task<RenewResultDto> RenewBookAsync(Guid borrowId)
    {
        var borrow = await _bookBorrowRepository.GetAsync(borrowId);
        
        // Authorization check
        if (borrow.UserId != CurrentUser.Id.Value && 
            !await AuthorizationService.IsGrantedAsync(BookManagementPermissions.Books.Manage))
        {
            throw new AbpAuthorizationException();
        }

        // Business rule validation
        if (!await _borrowingService.CanRenewBookAsync(borrowId))
        {
            throw new BusinessException("CANNOT_RENEW_BOOK");
        }

        // Process renewal
        var borrowPeriod = _borrowingService.CalculateBorrowPeriod(borrow.Book.BookType);
        borrow.Renew(borrowPeriod);

        await _bookBorrowRepository.UpdateAsync(borrow);

        return new RenewResultDto
        {
            BorrowId = borrow.Id,
            NewDueDate = borrow.DueDate,
            RenewedAt = Clock.Now
        };
    }
}
```

### 3. Advanced Search Implementation

```csharp
public class BookSearchAppService : ApplicationService, IBookSearchAppService
{
    private readonly IDistributedCache _cache;
    
    public async Task<PagedResultDto<BookSearchResultDto>> SearchAsync(BookSearchInput input)
    {
        // Cache key for search results
        var cacheKey = $"search:{input.GetHashCode()}";
        var cachedResult = await _cache.GetStringAsync(cacheKey);
        
        if (cachedResult != null)
        {
            return JsonSerializer.Deserialize<PagedResultDto<BookSearchResultDto>>(cachedResult);
        }

        var specification = new BookSearchSpecification(input.Query)
            .WithCategoryFilter(input.CategoryIds)
            .WithAuthorFilter(input.AuthorNames)
            .WithAvailabilityFilter(input.ShowAvailableOnly)
            .WithPublicationDateRange(input.PublicationYearFrom, input.PublicationYearTo)
            .WithPaging(input.SkipCount, input.MaxResultCount)
            .WithHighlighting(input.Query);

        var books = await _bookRepository.SearchAsync(specification);
        var totalCount = await _bookRepository.GetSearchCountAsync(specification);

        var result = new PagedResultDto<BookSearchResultDto>(
            totalCount,
            ObjectMapper.Map<List<Book>, List<BookSearchResultDto>>(books)
        );

        // Cache results for 5 minutes
        await _cache.SetStringAsync(cacheKey, JsonSerializer.Serialize(result),
            new DistributedCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5)
            });

        return result;
    }

    public async Task<List<BookSuggestionDto>> GetSuggestionsAsync(string query)
    {
        if (string.IsNullOrWhiteSpace(query) || query.Length < 2)
        {
            return new List<BookSuggestionDto>();
        }

        var suggestions = await _bookRepository.GetSuggestionsAsync(query, 10);
        return ObjectMapper.Map<List<BookSuggestion>, List<BookSuggestionDto>>(suggestions);
    }
}
```

### 4. Report Generation Implementation

```csharp
public class LibraryReportingAppService : ApplicationService, ILibraryReportingAppService
{
    [Authorize(BookManagementPermissions.Books.Reports)]
    public async Task<PopularBooksReportDto> GetPopularBooksReportAsync(ReportPeriodInput input)
    {
        var specification = new PopularBooksSpecification(input.StartDate, input.EndDate)
            .WithTop(input.TopCount ?? 20);

        var popularBooks = await _bookBorrowRepository.GetPopularBooksAsync(specification);
        var borrowStatistics = await _bookBorrowRepository.GetBorrowStatisticsAsync(
            input.StartDate, input.EndDate);

        return new PopularBooksReportDto
        {
            ReportPeriod = $"{input.StartDate:dd/MM/yyyy} - {input.EndDate:dd/MM/yyyy}",
            TotalBorrows = borrowStatistics.TotalBorrows,
            UniqueUsers = borrowStatistics.UniqueUsers,
            PopularBooks = ObjectMapper.Map<List<PopularBookData>, List<PopularBookDto>>(popularBooks),
            GeneratedAt = Clock.Now
        };
    }

    public async Task<byte[]> ExportReportAsync(ExportReportInput input)
    {
        switch (input.ReportType)
        {
            case ReportType.PopularBooks:
                var report = await GetPopularBooksReportAsync(input.Parameters);
                return await _reportExporter.ExportToPdfAsync(report, input.Format);
                
            case ReportType.UserActivity:
                var activityReport = await GetUserActivityReportAsync(input.Parameters);
                return await _reportExporter.ExportToExcelAsync(activityReport);
                
            default:
                throw new BusinessException("UNSUPPORTED_REPORT_TYPE");
        }
    }
}
```

## DTOs and Validation

### Book DTOs with Validation
```csharp
public class CreateBookDto
{
    [Required]
    [StringLength(17, MinimumLength = 10, ErrorMessage = "ISBN must be between 10 and 17 characters")]
    public string ISBN { get; set; }

    [Required]
    [StringLength(200, MinimumLength = 3)]
    public string Title { get; set; }

    [StringLength(500)]
    public string Subtitle { get; set; }

    [Required]
    [MinLength(1, ErrorMessage = "At least one author is required")]
    public List<string> Authors { get; set; }

    [Required]
    [StringLength(100)]
    public string Publisher { get; set; }

    [Required]
    public DateTime PublicationDate { get; set; }

    [Required]
    [MinLength(1, ErrorMessage = "At least one category is required")]
    public List<Guid> CategoryIds { get; set; }

    [Required]
    [Range(1, 1000)]
    public int Quantity { get; set; }

    public BookType BookType { get; set; } = BookType.Regular;
}

public class BookDto : EntityDto<Guid>
{
    public string ISBN { get; set; }
    public string Title { get; set; }
    public string Subtitle { get; set; }
    public List<string> Authors { get; set; }
    public string Publisher { get; set; }
    public DateTime PublicationDate { get; set; }
    public List<CategoryDto> Categories { get; set; }
    public int TotalQuantity { get; set; }
    public int AvailableQuantity { get; set; }
    public int BorrowedQuantity { get; set; }
    public int ReservedQuantity { get; set; }
    public BookType BookType { get; set; }
    public string CoverImageUrl { get; set; }
    public bool IsAvailable => AvailableQuantity > 0;
}
```

## AutoMapper Configuration

```csharp
public class BookManagementApplicationAutoMapperProfile : Profile
{
    public BookManagementApplicationAutoMapperProfile()
    {
        // Book mappings
        CreateMap<Book, BookDto>()
            .ForMember(dest => dest.Authors, opt => opt.MapFrom(src => src.Authors.Select(a => a.FullName)))
            .ForMember(dest => dest.TotalQuantity, opt => opt.MapFrom(src => src.Inventory.TotalQuantity))
            .ForMember(dest => dest.AvailableQuantity, opt => opt.MapFrom(src => src.Inventory.AvailableQuantity));

        CreateMap<CreateBookDto, Book>()
            .ConvertUsing<CreateBookDtoToBookConverter>();

        // Borrowing mappings
        CreateMap<BookBorrow, BorrowResultDto>()
            .ForMember(dest => dest.BookTitle, opt => opt.MapFrom(src => src.Book.Title.Value))
            .ForMember(dest => dest.BorrowId, opt => opt.MapFrom(src => src.Id));

        CreateMap<BookBorrow, UserBorrowDto>()
            .ForMember(dest => dest.BookTitle, opt => opt.MapFrom(src => src.Book.Title.Value))
            .ForMember(dest => dest.BookAuthors, opt => opt.MapFrom(src => src.Book.Authors.Select(a => a.FullName)))
            .ForMember(dest => dest.IsOverdue, opt => opt.MapFrom(src => src.IsOverdue()))
            .ForMember(dest => dest.DaysUntilDue, opt => opt.MapFrom(src => (src.DueDate - DateTime.Now).Days));

        // Category mappings
        CreateMap<Category, CategoryDto>();
        CreateMap<CreateCategoryDto, Category>();

        // Fine mappings
        CreateMap<Fine, UserFineDto>()
            .ForMember(dest => dest.BookTitle, opt => opt.MapFrom(src => src.BookBorrow.Book.Title.Value))
            .ForMember(dest => dest.FineTypeName, opt => opt.MapFrom(src => src.FineType.ToString()));
    }
}

public class CreateBookDtoToBookConverter : ITypeConverter<CreateBookDto, Book>
{
    public Book Convert(CreateBookDto source, Book destination, ResolutionContext context)
    {
        var guidGenerator = context.Options.ServiceCtor(typeof(IGuidGenerator)) as IGuidGenerator;
        
        return new Book(
            guidGenerator.Create(),
            new ISBN(source.ISBN),
            new BookTitle(source.Title),
            source.Authors.Select(a => new Author(a)).ToList(),
            source.Publisher,
            new PublicationDate(source.PublicationDate),
            source.BookType
        );
    }
}
```

## Permission System Integration

```csharp
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
        public const string View = Default + ".View";
        public const string Pay = Default + ".Pay";
        public const string Manage = Default + ".Manage";
        public const string Waive = Default + ".Waive";
    }
}

[DependsOn(typeof(AbpPermissionManagementApplicationModule))]
public class BookManagementPermissionDefinitionProvider : PermissionDefinitionProvider
{
    public override void Define(IPermissionDefinitionContext context)
    {
        var bookGroup = context.AddGroup(BookManagementPermissions.GroupName, 
            L("Permission:BookManagement"));

        var booksPermission = bookGroup.AddPermission(BookManagementPermissions.Books.Default, 
            L("Permission:Books"));
        booksPermission.AddChild(BookManagementPermissions.Books.Search, L("Permission:Books.Search"));
        booksPermission.AddChild(BookManagementPermissions.Books.Borrow, L("Permission:Books.Borrow"));
        booksPermission.AddChild(BookManagementPermissions.Books.Manage, L("Permission:Books.Manage"));
        booksPermission.AddChild(BookManagementPermissions.Books.Reports, L("Permission:Books.Reports"));

        var finesPermission = bookGroup.AddPermission(BookManagementPermissions.Fines.Default, 
            L("Permission:Fines"));
        finesPermission.AddChild(BookManagementPermissions.Fines.View, L("Permission:Fines.View"));
        finesPermission.AddChild(BookManagementPermissions.Fines.Pay, L("Permission:Fines.Pay"));
        finesPermission.AddChild(BookManagementPermissions.Fines.Manage, L("Permission:Fines.Manage"));
        finesPermission.AddChild(BookManagementPermissions.Fines.Waive, L("Permission:Fines.Waive"));
    }
}
```

## Error Handling and Localization

```csharp
// Custom business exceptions
public static class BookManagementErrorCodes
{
    public const string BookNotAvailable = "BookManagement:BookNotAvailable";
    public const string BorrowingLimitExceeded = "BookManagement:BorrowingLimitExceeded";
    public const string DuplicateISBN = "BookManagement:DuplicateISBN";
    public const string CannotRenewBook = "BookManagement:CannotRenewBook";
    public const string ReservationExpired = "BookManagement:ReservationExpired";
}

// Localization resources
public class BookManagementResource
{
    // Error messages
    public const string BookNotAvailableMessage = "The requested book is not available for borrowing";
    public const string BorrowingLimitExceededMessage = "You have reached your borrowing limit";
    public const string DuplicateISBNMessage = "A book with this ISBN already exists";
    
    // Success messages
    public const string BookBorrowedSuccessfully = "Book borrowed successfully";
    public const string BookReturnedSuccessfully = "Book returned successfully";
    public const string ReservationCreatedSuccessfully = "Reservation created successfully";
}
```

This generated Application Layer provides a robust, well-structured foundation that handles all business operations for the Book Management system while maintaining clean architecture principles and ABP Framework best practices.