# Frontend Input - Book Management

Đây là file input cho Frontend generation của tính năng Quản lý Sách. Frontend sẽ được build với Next.js và tích hợp với Backend API đã có.

## Frontend Requirements Specification

### Technology Stack Context

- **Framework**: Next.js 14+ với App Router
- **UI Library**: React 18.3+
- **Language**: TypeScript 5.3+
- **Styling**: Tailwind CSS 3.4 + Radix UI
- **Icons**: Lucide React
- **State Management**: Zustand + TanStack Query v5
- **Forms**: React Hook Form + Zod validation
- **HTTP Client**: Axios với interceptors
- **Authentication**: NextAuth.js v4 (tích hợp với existing auth)
- **Testing**: Jest + React Testing Library
- **Build Tools**: Next.js build system

### Design System Requirements

#### Brand Guidelines
- Consistent với hệ thống Authentication hiện có
- Modern, clean interface
- Accessibility compliant (WCAG 2.1 AA)
- Responsive design (mobile-first)
- Dark/light theme support

#### Component Library
- Reusable components với Radix UI base
- Consistent spacing và typography
- Loading states và skeleton loaders
- Error boundaries và fallbacks
- Animation với Framer Motion (optional)

## Page Structure & Routing

### Public Routes (No Authentication Required)
```
/books (Public book catalog)
/books/[id] (Book details - public view)
/books/search (Advanced search)
/categories (Browse by categories)
```

### Protected Routes (Authentication Required)
```
/dashboard (User dashboard)
/my-library (Personal library management)
/my-library/borrowed (Currently borrowed books)
/my-library/reservations (Active reservations)
/my-library/history (Borrowing history)
/my-library/fines (Outstanding fines)
/admin/books (Book management - Admin/Librarian)
/admin/categories (Category management)
/admin/reports (Reports & analytics)
/admin/users (User management)
```

## Page Specifications

### 1. Public Book Catalog (/books)

#### Purpose:
Main catalog page for browsing and searching books, accessible to all users.

#### Features Required:
- **Search Bar**: Prominent search with autocomplete
- **Book Grid/List**: Toggle between grid and list views
- **Filters Sidebar**: Category, author, publication year, availability
- **Sorting Options**: Relevance, title A-Z/Z-A, publication date
- **Pagination**: Infinite scroll or traditional pagination
- **Book Cards**: Title, author, cover image, availability status
- **Quick Actions**: View details, reserve/borrow (if logged in)

#### Components Needed:
```typescript
// Main page component
BookCatalogPage

// Sub-components
SearchBar
BookFilters
BookCard
BookGrid
BookList
ViewToggle
SortDropdown
PaginationControls
```

#### State Management:
```typescript
interface BookCatalogState {
  books: Book[]
  loading: boolean
  filters: BookFilters
  searchQuery: string
  sortBy: SortOption
  viewMode: 'grid' | 'list'
  currentPage: number
  totalCount: number
}
```

#### API Integration:
- GET /api/app/books (với pagination và filters)
- GET /api/app/book-search/suggestions
- GET /api/app/categories

### 2. Book Details (/books/[id])

#### Purpose:
Detailed view của một cuốn sách với đầy đủ thông tin và actions.

#### Features Required:
- **Book Information**: Complete metadata display
- **Cover Image**: Large, high-quality image
- **Availability Status**: Real-time availability
- **Action Buttons**: Borrow, Reserve, Add to Wishlist
- **Reviews/Ratings**: User feedback (if implemented)
- **Related Books**: Recommendations based on category/author
- **QR Code**: For mobile scanning (if applicable)

#### Components Needed:
```typescript
BookDetailsPage
BookInfo
BookCover
AvailabilityStatus
ActionButtons
RelatedBooks
BookMetadata
```

#### State Management:
```typescript
interface BookDetailsState {
  book: BookDetail | null
  availability: AvailabilityStatus
  loading: boolean
  error: string | null
  relatedBooks: Book[]
}
```

### 3. User Dashboard (/dashboard)

#### Purpose:
Personal dashboard showing user's library activity and quick actions.

#### Features Required:
- **Quick Stats**: Books borrowed, reservations, overdue items
- **Current Borrows**: Books currently borrowed with due dates
- **Active Reservations**: Queue positions and estimated availability
- **Due Soon**: Books due in next 3 days
- **Outstanding Fines**: Amount owed with payment link
- **Recent Activity**: Recent borrows and returns
- **Quick Actions**: Search books, view full library

#### Components Needed:
```typescript
UserDashboard
QuickStats
CurrentBorrows
ActiveReservations
DueSoonAlert
FinesAlert
RecentActivity
QuickActions
```

#### State Management:
```typescript
interface DashboardState {
  userData: UserDashboard
  loading: boolean
  notifications: Notification[]
  quickStats: UserStats
}
```

### 4. My Library (/my-library)

#### Purpose:
Complete personal library management with tabs for different sections.

#### Tab Structure:
- **Borrowed**: Currently borrowed books
- **Reservations**: Active reservations and queue status
- **History**: Complete borrowing history
- **Fines**: Outstanding fines and payment history
- **Preferences**: Reading preferences and notifications

#### Features Required:
- **Tabbed Interface**: Easy navigation between sections
- **Search/Filter**: Within personal data
- **Bulk Actions**: Renew multiple books, cancel reservations
- **Export**: Download history as PDF/CSV
- **Notifications**: In-app notifications for due dates

#### Components Needed:
```typescript
MyLibraryPage
LibraryTabs
BorrowedBooksTab
ReservationsTab
HistoryTab
FinesTab
PreferencesTab
BulkActions
ExportButton
```

### 5. Book Management Admin (/admin/books)

#### Purpose:
Administrative interface cho librarians để quản lý book catalog.

#### Features Required:
- **Book List**: All books with admin actions
- **Add New Book**: Form để thêm sách mới
- **Edit Book**: Update book information
- **Inventory Management**: Update quantities
- **Bulk Import**: Import books from CSV/Excel
- **QR Code Generation**: Generate và print QR codes
- **Book Status**: Track borrowed, available, damaged books

#### Components Needed:
```typescript
BookAdminPage
BookAdminList
AddBookForm
EditBookForm
InventoryManager
BulkImportDialog
QRCodeGenerator
BookStatusManager
```

#### Form Validations:
```typescript
const createBookSchema = z.object({
  isbn: z.string().min(10).max(17),
  title: z.string().min(3).max(200),
  authors: z.array(z.string()).min(1),
  categories: z.array(z.string()).min(1),
  publicationDate: z.date().max(new Date()),
  quantity: z.number().min(1),
  // ... other fields
})
```

### 6. Reports & Analytics (/admin/reports)

#### Purpose:
Comprehensive reporting cho library management.

#### Report Types:
- **Popular Books**: Most borrowed books
- **User Activity**: User engagement metrics
- **Inventory**: Stock levels and turnover
- **Financial**: Fine collection and outstanding amounts
- **System Usage**: Peak times and usage patterns

#### Features Required:
- **Report Selection**: Dropdown của available reports
- **Date Range Picker**: Custom date ranges
- **Filters**: Additional filtering options
- **Visualization**: Charts và graphs
- **Export**: PDF, Excel, CSV formats
- **Scheduled Reports**: Email delivery (future)

#### Components Needed:
```typescript
ReportsPage
ReportSelector
DateRangePicker
ReportFilters
ChartContainer
ReportTable
ExportOptions
```

## Component Library Specifications

### Core Components

#### BookCard Component
```typescript
interface BookCardProps {
  book: Book
  variant: 'grid' | 'list' | 'compact'
  showActions?: boolean
  onBorrow?: (bookId: string) => void
  onReserve?: (bookId: string) => void
  onViewDetails?: (bookId: string) => void
}
```

#### SearchBar Component
```typescript
interface SearchBarProps {
  placeholder?: string
  suggestions?: BookSuggestion[]
  onSearch: (query: string) => void
  onSuggestionSelect: (suggestion: BookSuggestion) => void
  loading?: boolean
}
```

#### DataTable Component
```typescript
interface DataTableProps<T> {
  data: T[]
  columns: ColumnDef<T>[]
  pagination?: PaginationProps
  sorting?: SortingState
  filtering?: boolean
  selection?: boolean
  loading?: boolean
}
```

### Form Components

#### BookForm Component
```typescript
interface BookFormProps {
  book?: Book
  onSubmit: (data: BookFormData) => void
  onCancel: () => void
  loading?: boolean
  validationSchema: ZodSchema
}
```

#### FilterPanel Component
```typescript
interface FilterPanelProps {
  filters: FilterOption[]
  values: FilterValues
  onChange: (values: FilterValues) => void
  onReset: () => void
}
```

## State Management Architecture

### Global Store Structure (Zustand)
```typescript
interface AppStore {
  // Authentication (existing)
  auth: AuthState
  
  // Book catalog
  books: BooksState
  categories: CategoriesState
  
  // User library
  userLibrary: UserLibraryState
  
  // UI state
  ui: UIState
  
  // Admin
  admin: AdminState
}
```

### TanStack Query Integration
```typescript
// Query keys structure
const queryKeys = {
  books: {
    all: ['books'] as const,
    lists: () => [...queryKeys.books.all, 'list'] as const,
    list: (filters: BookFilters) => [...queryKeys.books.lists(), { filters }] as const,
    details: () => [...queryKeys.books.all, 'detail'] as const,
    detail: (id: string) => [...queryKeys.books.details(), id] as const,
  },
  userLibrary: {
    all: ['userLibrary'] as const,
    dashboard: () => [...queryKeys.userLibrary.all, 'dashboard'] as const,
    borrowed: () => [...queryKeys.userLibrary.all, 'borrowed'] as const,
    // ... other queries
  }
}
```

## API Integration Layer

### HTTP Client Setup
```typescript
// API client with interceptors
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
})

// Request interceptor for auth token
apiClient.interceptors.request.use((config) => {
  const token = getAuthToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    // Handle common errors
    if (error.response?.status === 401) {
      // Redirect to login
    }
    return Promise.reject(error)
  }
)
```

### Service Layer
```typescript
// Book service
export const bookService = {
  getBooks: (params: GetBooksParams) => 
    apiClient.get<PagedResult<Book>>('/api/app/books', { params }),
  
  getBook: (id: string) => 
    apiClient.get<Book>(`/api/app/books/${id}`),
  
  borrowBook: (bookId: string) => 
    apiClient.post<BorrowResult>('/api/app/book-borrowing/borrow', { bookId }),
  
  // ... other methods
}
```

## UI/UX Requirements

### Responsive Design
- **Mobile (320-768px)**: Optimized for phone usage
- **Tablet (768-1024px)**: Adapted layout for tablets
- **Desktop (1024px+)**: Full-featured interface

### Accessibility
- **Keyboard Navigation**: Full keyboard support
- **Screen Readers**: Proper ARIA labels và landmarks
- **Color Contrast**: WCAG 2.1 AA compliance
- **Focus Management**: Clear focus indicators
- **Alternative Text**: Images và icons có alt text

### Performance
- **Core Web Vitals**: LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Bundle Size**: Optimize với code splitting
- **Lazy Loading**: Images và components
- **Caching**: Appropriate cache strategies
- **Loading States**: Skeleton loaders cho better UX

### Error Handling
- **Error Boundaries**: Catch React errors
- **Network Errors**: User-friendly error messages
- **Form Validation**: Real-time validation feedback
- **Fallback UI**: Graceful degradation
- **Retry Mechanisms**: Automatic retry cho failed requests

## Testing Strategy

### Unit Testing
```typescript
// Component testing example
describe('BookCard', () => {
  it('should display book information correctly', () => {
    render(<BookCard book={mockBook} variant="grid" />)
    expect(screen.getByText(mockBook.title)).toBeInTheDocument()
    expect(screen.getByText(mockBook.author)).toBeInTheDocument()
  })
  
  it('should call onBorrow when borrow button is clicked', () => {
    const onBorrow = jest.fn()
    render(<BookCard book={mockBook} onBorrow={onBorrow} />)
    fireEvent.click(screen.getByText('Borrow'))
    expect(onBorrow).toHaveBeenCalledWith(mockBook.id)
  })
})
```

### Integration Testing
- API integration tests
- User workflow tests
- Cross-browser testing
- Performance testing

### E2E Testing (Optional)
- Critical user journeys
- Authentication flows
- Book borrowing workflow
- Admin functionality

This frontend specification provides a comprehensive blueprint for building a modern, user-friendly book management interface that integrates seamlessly with the backend API while providing excellent user experience across all devices.