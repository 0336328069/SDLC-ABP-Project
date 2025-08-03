# Implementation Plan: Book Management

## 1. Executive Summary

This implementation plan outlines the development of a comprehensive Book Management system for a digital library application. It will enable efficient library operations, user book interactions, and inventory management. The core functionalities include book catalog management, reservation system, borrowing/returning workflow, and fine management. The system will integrate with the existing authentication module to provide personalized user experiences.

- **Technical Architecture Overview**: The system will adhere to a Modular Monolith architecture, leveraging Domain-Driven Design (DDD) and Clean Architecture principles. The backend is built with .NET 9.0 and ABP Framework 8.3.0, exposing RESTful APIs. The frontend uses Next.js 14+ and React 18.3+. Data persistence is handled by SQL Server 2019+ (or PostgreSQL 15+) with EF Core 9.0, and Redis 7.0 for caching.
- **Key Technologies and Tools**:
  - **Backend**: .NET 9.0, ABP Framework 8.3.0, C# 12, SQL Server 2019+/PostgreSQL 15+, Entity Framework Core 9.0, Redis 7.0, ABP Identity, JWT Bearer Tokens, ABP Permission System, ASP.NET Core Web API, Swagger/OpenAPI 3.0, Serilog, RabbitMQ, FluentValidation.
  - **Frontend**: Next.js 14+, React 18.3+, TypeScript 5.3+, NextAuth.js v4, Tailwind CSS 3.4, Radix UI, Lucide React, Zustand, TanStack Query v5, Axios, React Hook Form, Zod, React Table v8.
  - **DevOps**: Docker, Docker Compose, Nginx, GitHub Actions, n8n, Husky, lint-staged, ESLint, Prettier, dotnet format.
- **Implementation Timeline and Phases**: The implementation strategy is phased over approximately 10 weeks:
  - **Phase 1 (Weeks 1-2)**: Foundation & Domain Model.
  - **Phase 2 (Weeks 3-5)**: Core Book Management (CRUD, Search).
  - **Phase 3 (Weeks 6-8)**: Reservation & Borrowing System.
  - **Phase 4 (Weeks 9-10)**: Fine Management & Advanced Features.

## 2. Development Phases

- **Phase 1: Domain Layer**
  - Define `Book` entity in `src/AbpApp.Domain/Books/Book.cs`.
  - Define `Category` entity in `src/AbpApp.Domain/Books/Category.cs`.
  - Define `BookReservation` entity in `src/AbpApp.Domain/Books/BookReservation.cs`.
  - Define `BookBorrow` entity in `src/AbpApp.Domain/Books/BookBorrow.cs`.
  - Define `Fine` entity in `src/AbpApp.Domain/Books/Fine.cs`.
  - Define value objects (`ISBN`, `BookTitle`, `Author`, `BookInventory`, etc.) in `src/AbpApp.Domain/Books/ValueObjects/`.
  - Define repository interfaces in `src/AbpApp.Domain/Books/`.
  - Define domain services like `BookBorrowingService` in `src/AbpApp.Domain/Books/BookBorrowingService.cs`.
  - Define domain events in `src/AbpApp.Domain.Shared/Books/Events/`.
- **Phase 2: Application Layer**
  - Define DTOs in `src/AbpApp.Application.Contracts/Books/Dtos/`.
  - Define application service interfaces in `src/AbpApp.Application.Contracts/Books/`.
  - Implement application services in `src/AbpApp.Application/Books/`.
  - Configure AutoMapper profiles in `src/AbpApp.Application/Books/BookManagementAutoMapperProfile.cs`.
  - Implement specifications for query optimization in `src/AbpApp.Application/Books/Specifications/`.
- **Phase 3: Infrastructure Layer**
  - Implement repository classes in `src/AbpApp.EntityFrameworkCore/Books/`.
  - Add DbSets to `AbpAppDbContext.cs`.
  - Generate and apply EF Core Migrations for all book-related entities.
  - Configure entity mappings and relationships.
  - Set up Redis caching for frequently accessed data.
- **Phase 4: Presentation Layer**
  - Develop frontend pages for book management in `src/frontend/app/books/`.
  - Create reusable book components in `src/frontend/components/books/`.
  - Implement search and filtering functionality.
  - Create user dashboard for borrowed books and reservations.
  - Implement admin interfaces for book management.
- **Phase 5: Testing & Deployment**
  - Write comprehensive unit tests for domain logic and application services.
  - Write frontend component tests using Jest and React Testing Library.
  - Implement integration tests for API endpoints and database operations.
  - Configure CI/CD pipelines for automated testing and deployment.
  - Conduct performance testing for search and inventory operations.

## 3. Backend Implementation

### Domain Layer

- **Entity classes**:

  - `Book`: Core book entity with catalog information.

    - File Path: `src/backend/src/AbpApp.Domain/Books/Book.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/Book.cs
    using System;
    using System.Collections.Generic;
    using AbpApp.Books.ValueObjects;
    using Volo.Abp.Domain.Entities.Auditing;

    namespace AbpApp.Books;

    public class Book : FullAuditedAggregateRoot<Guid>
    {
        public ISBN ISBN { get; private set; }
        public BookTitle Title { get; private set; }
        public string Subtitle { get; private set; }
        public string Description { get; private set; }
        public List<Author> Authors { get; private set; }
        public string Publisher { get; private set; }
        public PublicationDate PublicationDate { get; private set; }
        public string Language { get; private set; }
        public int Pages { get; private set; }
        public BookInventory Inventory { get; private set; }
        public List<Guid> CategoryIds { get; private set; }
        public BookType BookType { get; private set; }
        public string CoverImageUrl { get; private set; }

        private Book() { /* For ORM */ }

        public Book(Guid id, ISBN isbn, BookTitle title, List<Author> authors, string publisher, 
                   PublicationDate publicationDate, BookType bookType) : base(id)
        {
            ISBN = isbn;
            Title = title;
            Authors = authors ?? throw new ArgumentNullException(nameof(authors));
            Publisher = publisher;
            PublicationDate = publicationDate;
            BookType = bookType;
            CategoryIds = new List<Guid>();
            Inventory = new BookInventory(0, 0);
        }

        public void UpdateInventory(int totalQuantity, int availableQuantity)
        {
            Inventory = new BookInventory(totalQuantity, availableQuantity);
        }

        public void AddCategory(Guid categoryId)
        {
            if (!CategoryIds.Contains(categoryId))
            {
                CategoryIds.Add(categoryId);
            }
        }

        public bool CanBeBorrowed()
        {
            return Inventory.AvailableQuantity > 0;
        }
    }
    ```

  - `Category`: Book categorization entity.

    - File Path: `src/backend/src/AbpApp.Domain/Books/Category.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/Category.cs
    using System;
    using Volo.Abp.Domain.Entities.Auditing;

    namespace AbpApp.Books;

    public class Category : FullAuditedAggregateRoot<Guid>
    {
        public string Name { get; private set; }
        public string Description { get; private set; }
        public Guid? ParentCategoryId { get; private set; }
        public bool IsActive { get; private set; }
        public int DisplayOrder { get; private set; }

        private Category() { /* For ORM */ }

        public Category(Guid id, string name, string description = null) : base(id)
        {
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Description = description;
            IsActive = true;
            DisplayOrder = 0;
        }

        public void SetParentCategory(Guid? parentCategoryId)
        {
            ParentCategoryId = parentCategoryId;
        }

        public void UpdateDisplayOrder(int order)
        {
            DisplayOrder = order;
        }

        public void SetActiveStatus(bool isActive)
        {
            IsActive = isActive;
        }
    }
    ```

  - `BookReservation`: Book reservation tracking.

    - File Path: `src/backend/src/AbpApp.Domain/Books/BookReservation.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/BookReservation.cs
    using System;
    using Volo.Abp.Domain.Entities.Auditing;

    namespace AbpApp.Books;

    public class BookReservation : FullAuditedAggregateRoot<Guid>
    {
        public Guid BookId { get; private set; }
        public Guid UserId { get; private set; }
        public DateTime ReservationDate { get; private set; }
        public DateTime ExpirationDate { get; private set; }
        public ReservationStatus Status { get; private set; }

        private BookReservation() { /* For ORM */ }

        public BookReservation(Guid id, Guid bookId, Guid userId) : base(id)
        {
            BookId = bookId;
            UserId = userId;
            ReservationDate = DateTime.UtcNow;
            ExpirationDate = DateTime.UtcNow.AddHours(24);
            Status = ReservationStatus.Active;
        }

        public bool IsExpired()
        {
            return DateTime.UtcNow > ExpirationDate && Status == ReservationStatus.Active;
        }

        public void Cancel()
        {
            Status = ReservationStatus.Cancelled;
        }

        public void ConvertToBorrow()
        {
            Status = ReservationStatus.Fulfilled;
        }
    }

    public enum ReservationStatus
    {
        Active,
        Fulfilled,
        Cancelled,
        Expired
    }
    ```

  - `BookBorrow`: Active borrowing records.

    - File Path: `src/backend/src/AbpApp.Domain/Books/BookBorrow.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/BookBorrow.cs
    using System;
    using AbpApp.Books.ValueObjects;
    using Volo.Abp.Domain.Entities.Auditing;

    namespace AbpApp.Books;

    public class BookBorrow : FullAuditedAggregateRoot<Guid>
    {
        public Guid BookId { get; private set; }
        public Guid UserId { get; private set; }
        public DateTime BorrowDate { get; private set; }
        public DateTime DueDate { get; private set; }
        public DateTime? ReturnDate { get; private set; }
        public BorrowStatus Status { get; private set; }
        public BookCondition? ReturnCondition { get; private set; }
        public bool IsRenewed { get; private set; }

        private BookBorrow() { /* For ORM */ }

        public BookBorrow(Guid id, Guid bookId, Guid userId, BorrowPeriod borrowPeriod) : base(id)
        {
            BookId = bookId;
            UserId = userId;
            BorrowDate = DateTime.UtcNow;
            DueDate = borrowPeriod.CalculateDueDate(BorrowDate);
            Status = BorrowStatus.Active;
            IsRenewed = false;
        }

        public bool IsOverdue()
        {
            return DateTime.UtcNow > DueDate && Status == BorrowStatus.Active;
        }

        public Fine CalculateFine(decimal dailyFineRate, decimal maxFine)
        {
            if (!IsOverdue()) return null;
            
            var daysOverdue = (DateTime.UtcNow - DueDate).Days;
            var fineAmount = Math.Min(daysOverdue * dailyFineRate, maxFine);
            
            return new Fine(fineAmount, "Late Return", DateTime.UtcNow);
        }

        public void Return(BookCondition condition)
        {
            ReturnDate = DateTime.UtcNow;
            ReturnCondition = condition;
            Status = BorrowStatus.Returned;
        }

        public void Renew(BorrowPeriod newPeriod)
        {
            if (IsRenewed) throw new InvalidOperationException("Book can only be renewed once");
            
            DueDate = newPeriod.CalculateDueDate(DateTime.UtcNow);
            IsRenewed = true;
        }
    }

    public enum BorrowStatus
    {
        Active,
        Returned,
        Lost,
        Damaged
    }
    ```

- **Value objects**:

  - `ISBN`: ISBN validation and formatting.

    - File Path: `src/backend/src/AbpApp.Domain/Books/ValueObjects/ISBN.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/ValueObjects/ISBN.cs
    using System;
    using System.Text.RegularExpressions;
    using Volo.Abp.Domain.Values;

    namespace AbpApp.Books.ValueObjects;

    public class ISBN : ValueObject
    {
        public string Value { get; private set; }

        private ISBN() { }

        public ISBN(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("ISBN cannot be null or empty");
                
            var cleanValue = value.Replace("-", "").Replace(" ", "");
            
            if (!IsValidISBN(cleanValue))
                throw new ArgumentException("Invalid ISBN format");
                
            Value = cleanValue;
        }

        private static bool IsValidISBN(string isbn)
        {
            return IsValidISBN10(isbn) || IsValidISBN13(isbn);
        }

        private static bool IsValidISBN10(string isbn)
        {
            if (isbn.Length != 10) return false;
            
            // ISBN-10 validation logic
            int sum = 0;
            for (int i = 0; i < 9; i++)
            {
                if (!char.IsDigit(isbn[i])) return false;
                sum += (10 - i) * (isbn[i] - '0');
            }
            
            char checkDigit = isbn[9];
            if (checkDigit == 'X') sum += 10;
            else if (char.IsDigit(checkDigit)) sum += checkDigit - '0';
            else return false;
            
            return sum % 11 == 0;
        }

        private static bool IsValidISBN13(string isbn)
        {
            if (isbn.Length != 13) return false;
            if (!isbn.StartsWith("978") && !isbn.StartsWith("979")) return false;
            
            // ISBN-13 validation logic
            int sum = 0;
            for (int i = 0; i < 12; i++)
            {
                if (!char.IsDigit(isbn[i])) return false;
                int digit = isbn[i] - '0';
                sum += (i % 2 == 0) ? digit : digit * 3;
            }
            
            int checkDigit = (10 - (sum % 10)) % 10;
            return checkDigit == (isbn[12] - '0');
        }

        public string GetDisplayFormat()
        {
            if (Value.Length == 10)
            {
                return $"{Value.Substring(0, 1)}-{Value.Substring(1, 3)}-{Value.Substring(4, 5)}-{Value.Substring(9, 1)}";
            }
            else if (Value.Length == 13)
            {
                return $"{Value.Substring(0, 3)}-{Value.Substring(3, 1)}-{Value.Substring(4, 3)}-{Value.Substring(7, 5)}-{Value.Substring(12, 1)}";
            }
            return Value;
        }

        protected override IEnumerable<object> GetAtomicValues()
        {
            yield return Value;
        }
    }
    ```

  - `BookTitle`: Title validation and formatting.
  - `Author`: Author information value object.
  - `BookInventory`: Inventory tracking value object.
  - `BorrowPeriod`: Borrow duration calculation.
  - `Fine`: Fine calculation and tracking.

- **Domain services**:

  - `BookBorrowingService`: Manages borrowing business logic.

    - File Path: `src/backend/src/AbpApp.Domain/Books/BookBorrowingService.cs`
    - Code:

    ```csharp
    // src/AbpApp.Domain/Books/BookBorrowingService.cs
    using System;
    using System.Threading.Tasks;
    using AbpApp.Books.ValueObjects;
    using Volo.Abp.Domain.Services;

    namespace AbpApp.Books;

    public class BookBorrowingService : DomainService
    {
        private readonly IBookRepository _bookRepository;
        private readonly IBookBorrowRepository _borrowRepository;

        public BookBorrowingService(IBookRepository bookRepository, IBookBorrowRepository borrowRepository)
        {
            _bookRepository = bookRepository;
            _borrowRepository = borrowRepository;
        }

        public async Task<bool> CanUserBorrowBookAsync(Guid userId, Guid bookId)
        {
            var book = await _bookRepository.GetAsync(bookId);
            if (!book.CanBeBorrowed()) return false;

            var userActiveBorrows = await _borrowRepository.GetActiveborrowsForUserAsync(userId);
            var userBorrowLimit = GetBorrowLimitForUser(userId);

            return userActiveBorrows.Count < userBorrowLimit;
        }

        public BorrowPeriod CalculateBorrowPeriod(BookType bookType)
        {
            return bookType switch
            {
                BookType.Regular => new BorrowPeriod(14),
                BookType.Reference => new BorrowPeriod(7),
                BookType.NewRelease => new BorrowPeriod(7),
                _ => new BorrowPeriod(14)
            };
        }

        private int GetBorrowLimitForUser(Guid userId)
        {
            // TODO: Get user membership type and return appropriate limit
            return 5; // Default for regular members
        }
    }

    public enum BookType
    {
        Regular,
        Reference,
        NewRelease,
        Textbook,
        Journal
    }
    ```

- **Repository interfaces**:

  - `IBookRepository`, `ICategoryRepository`, `IBookReservationRepository`, `IBookBorrowRepository`, `IFineRepository`

### Application Layer

- **Application services**:

  - `BookManagementAppService`: Core book CRUD operations.

    - File Path: `src/backend/src/AbpApp.Application/Books/BookManagementAppService.cs`
    - Code:

    ```csharp
    // src/AbpApp.Application/Books/BookManagementAppService.cs
    using System;
    using System.Threading.Tasks;
    using AbpApp.Books.Dtos;
    using Volo.Abp.Application.Services;
    using Volo.Abp.Application.Dtos;

    namespace AbpApp.Books;

    public class BookManagementAppService : ApplicationService, IBookManagementAppService
    {
        private readonly IBookRepository _bookRepository;
        private readonly BookBorrowingService _borrowingService;

        public BookManagementAppService(IBookRepository bookRepository, BookBorrowingService borrowingService)
        {
            _bookRepository = bookRepository;
            _borrowingService = borrowingService;
        }

        public async Task<BookDto> CreateAsync(CreateBookDto input)
        {
            // 1. Validate input DTO
            // 2. Create Book entity with value objects
            // 3. Save to repository
            // 4. Publish BookAddedEvent
            // 5. Return mapped DTO
            return null; // TODO: Implementation
        }

        public async Task<PagedResultDto<BookDto>> GetListAsync(GetBooksInput input)
        {
            // 1. Apply search filters and pagination
            // 2. Use specifications for optimized queries
            // 3. Return paged results
            return null; // TODO: Implementation
        }

        public async Task<BookDto> ReserveBookAsync(Guid bookId)
        {
            // 1. Check book availability
            // 2. Create reservation
            // 3. Update inventory
            // 4. Publish BookReservedEvent
            return null; // TODO: Implementation
        }

        public async Task<BookDto> BorrowBookAsync(Guid bookId)
        {
            // 1. Validate user can borrow
            // 2. Check reservation or availability
            // 3. Create borrow record
            // 4. Update inventory
            // 5. Publish BookBorrowedEvent
            return null; // TODO: Implementation
        }
    }
    ```

- **DTOs**:

  - `CreateBookDto`, `UpdateBookDto`, `BookDto`, `CategoryDto`, `BookReservationDto`, `BookBorrowDto`, `FineDto`

### Infrastructure Layer

- **Repository implementations**:
  - `EfCoreBookRepository`, `EfCoreCategoryRepository`, etc.
- **EF Core configurations**:
  - Entity mappings for all book-related entities
  - Relationships and constraints
- **Database migrations**:
  - Initial migration for book management schema

### API Layer

- **Controllers with endpoints**:
  - `BookManagementController`:
    - `GET /api/app/books`: Search and list books
    - `POST /api/app/books`: Create new book (admin)
    - `PUT /api/app/books/{id}`: Update book (admin)
    - `DELETE /api/app/books/{id}`: Delete book (admin)
    - `POST /api/app/books/{id}/reserve`: Reserve book
    - `POST /api/app/books/{id}/borrow`: Borrow book
    - `POST /api/app/books/{id}/return`: Return book

## 4. Frontend Implementation

### Components

- **React/Next.js components**:
  - `BookSearchForm.tsx`: Advanced book search interface.
    - File Path: `src/frontend/components/books/BookSearchForm.tsx`
    - Props: `onSearch` callback, `filters`.
    - State: Search term, category filters, author filters, availability status.
  - `BookCard.tsx`: Display book information in lists.
    - File Path: `src/frontend/components/books/BookCard.tsx`
    - Props: `book` object, `actions` (reserve, borrow, view details).
  - `BookDetailsModal.tsx`: Detailed book information popup.
    - File Path: `src/frontend/components/books/BookDetailsModal.tsx`
    - Props: `book` object, `isOpen`, `onClose`.
  - `UserDashboard.tsx`: User's borrowed books and reservations.
    - File Path: `src/frontend/components/books/UserDashboard.tsx`
    - State: Active borrows, reservations, fine information.
  - `BookManagementForm.tsx`: Admin form for adding/editing books.
    - File Path: `src/frontend/components/books/BookManagementForm.tsx`
    - Props: `book` (for editing), `onSubmit` callback.
    - State: All book fields, categories, validation errors.

- **Pages**:
  - `books/page.tsx`: Main book catalog page.
    - File Path: `src/frontend/app/books/page.tsx`
  - `books/[id]/page.tsx`: Individual book details page.
    - File Path: `src/frontend/app/books/[id]/page.tsx`
  - `dashboard/page.tsx`: User dashboard for borrowed books.
    - File Path: `src/frontend/app/dashboard/page.tsx`
  - `admin/books/page.tsx`: Admin book management interface.
    - File Path: `src/frontend/app/admin/books/page.tsx`

### API Integration

- **HTTP client setup**:
  - Extend existing Axios configuration for book-related endpoints.
  - Create typed API client functions for all book operations.
- **Real-time updates**:
  - Implement WebSocket connection for real-time availability updates.
  - Use TanStack Query for optimistic updates and cache management.

### State Management

- **Global state**:
  - Extend Zustand store for book-related state.
  - Cache frequently accessed book data and user preferences.
- **Search state**:
  - Manage complex search filters and pagination state.
  - Implement search history and saved searches.

### UI/UX

- **Advanced search**:
  - Multi-criteria search with filters for category, author, availability, publication date.
  - Autocomplete for authors and titles.
  - Save and load search preferences.
- **Responsive design**:
  - Grid layout for book browsing on desktop.
  - List view for mobile devices.
  - Infinite scroll for large result sets.

## 5. Database & Security

### Migration Strategy

- **Database schema changes**:
  - Comprehensive migration for all book management entities.
  - Indexes for optimized search performance.
  - Foreign key relationships and constraints.

### Authorization

- **Permission-based access**:
  - Reader permissions: Browse, search, reserve, borrow books.
  - Librarian permissions: Manage inventory, process returns, manage fines.
  - Admin permissions: Full book management, user management, system configuration.

### Data Protection

- **Audit logging**:
  - Track all book operations for compliance.
  - Log borrowing history for analytics while respecting privacy.
- **Data privacy**:
  - Anonymize borrowing history after retention period.
  - Secure handling of user reading preferences.

## 6. Testing & Deployment

### Unit Testing

- **Domain logic testing**:
  - ISBN validation and formatting.
  - Borrowing rules and fine calculations.
  - Inventory management logic.
  - Value object behaviors.
- **Application service testing**:
  - Book CRUD operations.
  - Reservation and borrowing workflows.
  - Search and filtering logic.

### Integration Testing

- **API testing**:
  - End-to-end testing of book management workflows.
  - Performance testing for search operations.
  - Load testing for concurrent borrowing operations.

### Performance

- **Optimization strategies**:
  - Database indexing for search queries.
  - Caching for popular books and categories.
  - Pagination for large result sets.
  - Search result caching with Redis.
- **Monitoring**:
  - Performance metrics for search response times.
  - Availability tracking and alerting.
  - User experience analytics.

## Quality Assurance Checklist:

- [ ] Domain model properly implements DDD principles
- [ ] All value objects have proper validation
- [ ] Repository pattern correctly implemented
- [ ] Specification pattern used for complex queries
- [ ] Business rules enforced in domain layer
- [ ] Comprehensive test coverage for domain logic
- [ ] API endpoints properly secured and documented
- [ ] Frontend components are responsive and accessible
- [ ] Search functionality is optimized for performance
- [ ] Database schema supports efficient querying
- [ ] Audit logging captures all required events
- [ ] Error handling covers all edge cases