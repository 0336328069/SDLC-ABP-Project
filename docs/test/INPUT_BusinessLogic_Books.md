# Book Management Domain Model - Business Logic Documentation

## Overview

This document describes the business logic, rules, and workflows implemented in the Book Management domain model. The domain model follows Domain-Driven Design principles and implements library management patterns using ABP Framework.

## Business Rules

### Book Registration Rules

1. **ISBN Uniqueness**: Each book must have a unique ISBN across the system
   - Implemented in: Domain service validation
   - Validation occurs at application layer before entity creation
   - Supports both ISBN-10 and ISBN-13 formats

2. **Title and Author Requirements**: Books must have valid title and at least one author
   - Minimum title length: 3 characters
   - Maximum title length: 200 characters
   - At least one author must be specified
   - Implemented in: `BookTitle` and `Author` value objects validation

3. **Publication Date Validation**: Publication date must be realistic
   - Cannot be in the future
   - Cannot be before year 1000 (reasonable historical limit)
   - Implemented in: `PublicationDate` value object

4. **Category Assignment**: Books must be assigned to at least one category
   - Books can belong to multiple categories
   - Category must exist in the system
   - Implemented in: Application service layer validation

### Inventory Management Rules

5. **Stock Tracking**: System tracks available and total quantities
   - Available quantity cannot exceed total quantity
   - Available quantity cannot be negative
   - Implemented in: `BookInventory` value object

6. **Reservation Logic**: Books can be reserved by users
   - Cannot reserve more books than available
   - Reservations expire after 24 hours if not borrowed
   - Implemented in: `BookReservation` entity

### Borrowing Rules

7. **Borrow Limits**: Users have borrowing limits based on membership type
   - Regular members: 5 books maximum
   - Premium members: 10 books maximum
   - Student members: 3 books maximum
   - Implemented in: Domain service `BookBorrowingService`

8. **Due Date Calculation**: Return due dates based on book type
   - Regular books: 14 days
   - Reference books: 7 days
   - New releases: 7 days
   - Implemented in: `BorrowPeriod` value object

### Return and Fine Rules

9. **Late Return Fines**: Fines calculated for overdue books
   - Regular books: $0.50 per day
   - Reference books: $1.00 per day
   - New releases: $1.50 per day
   - Maximum fine per book: $20.00
   - Implemented in: `Fine` value object

10. **Book Condition Assessment**: Books assessed for damage on return
    - Good, Fair, Poor, Damaged conditions
    - Damage fines applied based on replacement cost
    - Implemented in: `BookCondition` value object

## Entity Behaviors

### Book Entity

The `Book` entity represents the core book information and inventory:

**Key Properties**:
- ISBN (unique identifier)
- Title, subtitle, description
- Authors, publisher, publication date
- Categories, language, pages
- Physical properties (dimensions, weight)

**Key Methods**:
- `AddAuthor()`: Adds author to book
- `RemoveAuthor()`: Removes author (minimum one required)
- `UpdateInventory()`: Updates stock quantities
- `CanBeBorrowed()`: Checks if book is available for borrowing
- `Reserve()`: Creates reservation for user
- `CancelReservation()`: Cancels existing reservation

### BookReservation Entity

The `BookReservation` entity manages book reservations:

**Key Methods**:
- `IsExpired()`: Checks if reservation has expired (24 hours)
- `ConvertToBorrow()`: Converts reservation to active borrow
- `Cancel()`: Cancels reservation and frees book

**Business Logic**:
- Reservations automatically expire after 24 hours
- One user can only have one active reservation per book
- Reserved books are not available for direct borrowing

### BookBorrow Entity

The `BookBorrow` entity tracks borrowed books:

**Key Methods**:
- `IsOverdue()`: Checks if book is past due date
- `CalculateFine()`: Calculates late return fine
- `Return()`: Processes book return with condition assessment
- `Renew()`: Extends due date if allowed

**Business Logic**:
- Due date calculated based on book type and borrow date
- Renewals allowed once if no reservations pending
- Overdue calculation includes weekends and holidays

### Category Entity

The `Category` entity organizes books into logical groupings:

**Key Properties**:
- Name, description, parent category
- Active status, display order

**Key Methods**:
- `AddSubcategory()`: Creates child category
- `MoveToCategory()`: Changes parent category
- `GetBookCount()`: Returns number of books in category

## Value Object Logic

### ISBN Value Object

Encapsulates ISBN validation and formatting logic:

**Validation Logic**:
- Supports both ISBN-10 and ISBN-13 formats
- Validates check digit calculations
- Handles formatting with/without hyphens
- Case normalization for ISBN codes

**Business Operations**:
- `GetIsbn10()`: Converts ISBN-13 to ISBN-10 format
- `GetIsbn13()`: Converts ISBN-10 to ISBN-13 format
- `GetDisplayFormat()`: Returns formatted ISBN with hyphens
- `IsValid()`: Static method for format validation

### BookTitle Value Object

Encapsulates title validation and formatting:

**Validation Logic**:
- Length validation (3-200 characters)
- Trims whitespace and normalizes spacing
- Prevents special character sequences
- Title case formatting support

**Business Operations**:
- `GetShortTitle()`: Returns truncated version for displays
- `SearchTerms()`: Extracts keywords for search
- `Normalize()`: Standardizes title format

### Author Value Object

Encapsulates author information and validation:

**Properties**:
- First name, last name, middle initial
- Biography, birth date, nationality

**Business Operations**:
- `GetFullName()`: Returns formatted full name
- `GetDisplayName()`: Returns last name, first name format
- `GetInitials()`: Returns author initials
- `IsAlive()`: Checks if author is still living

### PublicationDate Value Object

Encapsulates publication date logic:

**Validation Logic**:
- Date cannot be in the future
- Minimum year validation (1000 AD)
- Handles uncertain publication dates

**Business Operations**:
- `GetAge()`: Returns years since publication
- `IsNewRelease()`: Checks if published within last year
- `GetDecade()`: Returns publication decade
- `GetCentury()`: Returns publication century

### BookInventory Value Object

Encapsulates inventory tracking logic:

**Properties**:
- Total quantity, available quantity
- Reserved quantity, borrowed quantity

**Business Operations**:
- `AddStock()`: Increases total and available quantities
- `RemoveStock()`: Decreases quantities (validation included)
- `Reserve()`: Moves from available to reserved
- `Borrow()`: Moves from available/reserved to borrowed
- `Return()`: Moves from borrowed back to available

### Fine Value Object

Encapsulates fine calculation logic:

**Properties**:
- Amount, currency, reason
- Date assessed, date paid, payment status

**Business Operations**:
- `CalculateLateFee()`: Computes overdue fine amount
- `CalculateDamageFee()`: Computes damage-based fine
- `ApplyDiscount()`: Applies member discounts
- `MarkPaid()`: Records fine payment
- `CanWaive()`: Checks if fine can be waived

## Domain Event Scenarios

### BookAddedEventData

**Triggered When**: New book is added to the library catalog

**Properties**:
- Book ID, ISBN, title, authors
- Categories, publication details
- Initial inventory quantities
- Added by user ID and timestamp

**Use Cases**:
- Update search indexes
- Notify interested users about new arrivals
- Update category statistics
- Generate acquisition reports

### BookReservedEventData

**Triggered When**: User reserves a book

**Properties**:
- Book ID, user ID, reservation timestamp
- Expiration time (24 hours)
- Queue position if multiple reservations

**Use Cases**:
- Send reservation confirmation
- Set up expiration reminders
- Update availability displays
- Queue management for popular books

### BookBorrowedEventData

**Triggered When**: Book is checked out to user

**Properties**:
- Book ID, user ID, borrow timestamp
- Due date, renewal status
- Location/branch information

**Use Cases**:
- Send checkout confirmation with due date
- Update user borrowing limits
- Generate circulation reports
- Set up return reminders

### BookReturnedEventData

**Triggered When**: Book is returned to library

**Properties**:
- Book ID, user ID, return timestamp
- Book condition assessment
- Late fees incurred
- Return location

**Use Cases**:
- Process late fees if applicable
- Update inventory availability
- Send return confirmation
- Assess book condition and maintenance needs

### BookOverdueEventData

**Triggered When**: Book becomes overdue

**Properties**:
- Book ID, user ID, due date
- Days overdue, accumulated fine
- Contact information for notifications

**Use Cases**:
- Send overdue notifications
- Calculate and apply late fees
- Update user account status
- Generate overdue reports

## Invariants

### System-Wide Invariants

1. **ISBN Uniqueness**: No two books can have the same ISBN
2. **Inventory Consistency**: Available quantity ≤ Total quantity
3. **Borrow Limits**: Users cannot exceed their borrowing limits
4. **Fine Accuracy**: All fines must be calculated correctly based on rules

### Entity Invariants

#### Book Invariants
- Must have at least one author
- ISBN must be valid format
- Publication date cannot be in future
- Must belong to at least one category

#### BookReservation Invariants
- Expiration time must be 24 hours from creation
- Cannot reserve already borrowed book
- One reservation per user per book

#### BookBorrow Invariants
- Due date must be calculated based on book type
- Cannot borrow more than user limit allows
- Book must be available or reserved by user

#### BookInventory Invariants
- Available quantity cannot be negative
- Available quantity cannot exceed total quantity
- Reserved + Borrowed + Available = Total quantity

## Validation Rules

### Input Validation

1. **ISBN Validation**:
   - Format validation for ISBN-10/13
   - Check digit calculation verification
   - Duplicate detection across system

2. **Title Validation**:
   - Length constraints (3-200 characters)
   - Content validation (no special characters)
   - Trimming and normalization

3. **Author Validation**:
   - Name format and length validation
   - Biography length limits
   - Date validation for birth/death dates

4. **Inventory Validation**:
   - Positive number validation
   - Quantity relationship validation
   - Maximum limit enforcement

### Business Rule Validation

1. **Borrowing Validation**:
   - User borrowing limit check
   - Book availability verification
   - User account status validation

2. **Reservation Validation**:
   - Book availability check
   - User reservation limits
   - Existing reservation detection

3. **Return Validation**:
   - Borrow record existence
   - User identity verification
   - Condition assessment requirements

## Business Workflows

### Book Addition Workflow

1. **Input Validation**:
   - Validate ISBN format and uniqueness
   - Validate title and author information
   - Verify category existence

2. **Entity Creation**:
   - Create `Book` entity with validated data
   - Initialize inventory with starting quantities
   - Assign to specified categories

3. **Event Publishing**:
   - Publish `BookAddedEventData` for downstream processing

4. **Index Updates**:
   - Update search indexes
   - Refresh category counters

### Book Reservation Workflow

1. **Availability Check**:
   - Verify book exists and is available
   - Check user doesn't have existing reservation
   - Verify user account is in good standing

2. **Reservation Creation**:
   - Create `BookReservation` entity with 24-hour expiration
   - Update book inventory (move from available to reserved)

3. **Event Publishing**:
   - Publish `BookReservedEventData` with expiration details

4. **Notification Setup**:
   - Schedule expiration reminder
   - Send reservation confirmation

### Book Borrowing Workflow

1. **Pre-Borrow Validation**:
   - Check user borrowing limits
   - Verify book availability or valid reservation
   - Confirm user account status

2. **Borrow Processing**:
   - Create `BookBorrow` entity with calculated due date
   - Update inventory (move to borrowed status)
   - Cancel reservation if applicable

3. **Due Date Calculation**:
   - Apply book type rules for borrow period
   - Account for holidays and library closures

4. **Event Publishing**:
   - Publish `BookBorrowedEventData` with due date

5. **Confirmation**:
   - Generate checkout receipt
   - Send due date reminder setup

### Book Return Workflow

1. **Return Validation**:
   - Verify borrow record exists
   - Confirm user identity
   - Check book condition

2. **Fine Calculation**:
   - Calculate late fees if overdue
   - Assess damage fees if applicable
   - Apply member discounts

3. **Return Processing**:
   - Update book inventory (return to available)
   - Close borrow record
   - Process any fines

4. **Event Publishing**:
   - Publish `BookReturnedEventData` with condition and fees

5. **Availability Update**:
   - Process waiting reservations
   - Update availability displays

## Security Considerations

### Data Protection
- User borrowing history privacy
- Fine payment information security
- Personal information in reservations

### Access Control
- Library staff permissions for inventory management
- User self-service restrictions
- Administrative override capabilities

### Audit Requirements
- All borrowing activity logging
- Fine calculation audit trail
- Inventory change tracking

## Performance Considerations

### Database Optimization
- Indexes on ISBN, title, author names
- Efficient queries for availability checks
- Archival strategy for old borrow records

### Caching Strategy
- Popular book information caching
- Category and author metadata caching
- User borrowing limit caching

### Query Optimization
- Specification pattern for complex book searches
- Pagination for large result sets
- Optimized availability calculations