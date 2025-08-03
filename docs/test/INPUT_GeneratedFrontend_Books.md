# Generated Frontend Files - Book Management

Đây là file mô phỏng output từ Frontend generation để làm input cho các META prompt khác. File này thể hiện Frontend application đã được generate cho tính năng Quản lý Sách với Next.js và React.

## Frontend Overview

Frontend đã được generate với đầy đủ các pages, components, hooks, services, và state management. Application được thiết kế theo modern React patterns với TypeScript, Tailwind CSS, và các best practices.

### Generated Application Structure

1. **Pages**: Complete routing với App Router
2. **Components**: Reusable UI components với Radix UI
3. **Hooks**: Custom hooks cho data fetching và state
4. **Services**: API integration layer
5. **Stores**: State management với Zustand
6. **Utils**: Utility functions và helpers
7. **Types**: TypeScript definitions

## Generated Files Structure

```
src/frontend/
├── app/
│   ├── books/
│   │   ├── page.tsx (Public catalog)
│   │   ├── [id]/
│   │   │   └── page.tsx (Book details)
│   │   └── search/
│   │       └── page.tsx (Advanced search)
│   ├── dashboard/
│   │   └── page.tsx (User dashboard)
│   ├── my-library/
│   │   ├── page.tsx (Main library page)
│   │   ├── borrowed/
│   │   │   └── page.tsx (Borrowed books)
│   │   ├── reservations/
│   │   │   └── page.tsx (Reservations)
│   │   ├── history/
│   │   │   └── page.tsx (Borrow history)
│   │   └── fines/
│   │       └── page.tsx (Fines)
│   └── admin/
│       ├── books/
│       │   └── page.tsx (Book management)
│       ├── categories/
│       │   └── page.tsx (Category management)
│       └── reports/
│           └── page.tsx (Reports)
├── components/
│   ├── books/
│   │   ├── BookCard.tsx
│   │   ├── BookDetails.tsx
│   │   ├── BookGrid.tsx
│   │   ├── BookList.tsx
│   │   ├── BookSearchForm.tsx
│   │   ├── BookFilters.tsx
│   │   └── BookManagementForm.tsx
│   ├── library/
│   │   ├── BorrowedBookCard.tsx
│   │   ├── ReservationCard.tsx
│   │   ├── FineCard.tsx
│   │   └── UserDashboard.tsx
│   ├── ui/
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   ├── DataTable.tsx
│   │   └── LoadingSpinner.tsx
│   └── layout/
│       ├── Header.tsx
│       ├── Sidebar.tsx
│       └── Navigation.tsx
├── hooks/
│   ├── useBooks.ts
│   ├── useBorrowing.ts
│   ├── useReservations.ts
│   ├── useFines.ts
│   └── useAuth.ts
├── services/
│   ├── api/
│   │   ├── client.ts
│   │   ├── books.ts
│   │   ├── borrowing.ts
│   │   ├── reservations.ts
│   │   └── fines.ts
│   └── types/
│       ├── book.ts
│       ├── borrowing.ts
│       ├── reservation.ts
│       └── api.ts
├── stores/
│   ├── bookStore.ts
│   ├── userLibraryStore.ts
│   └── uiStore.ts
└── utils/
    ├── formatters.ts
    ├── validators.ts
    └── constants.ts
```

## Generated Page Implementations

### 1. Book Catalog Page

```typescript
// app/books/page.tsx
"use client";

import { useState } from "react";
import { useBooks } from "@/hooks/useBooks";
import { BookGrid } from "@/components/books/BookGrid";
import { BookSearchForm } from "@/components/books/BookSearchForm";
import { BookFilters } from "@/components/books/BookFilters";
import { LoadingSpinner } from "@/components/ui/LoadingSpinner";
import { Button } from "@/components/ui/Button";
import { Grid, List, Filter } from "lucide-react";

export default function BooksPage() {
  const [viewMode, setViewMode] = useState<"grid" | "list">("grid");
  const [showFilters, setShowFilters] = useState(false);
  const [filters, setFilters] = useState({
    searchTerm: "",
    categoryId: "",
    authorName: "",
    isAvailable: false,
    publicationYearFrom: "",
    publicationYearTo: "",
  });

  const {
    data: books,
    isLoading,
    error,
    hasNextPage,
    fetchNextPage,
    isFetchingNextPage,
  } = useBooks(filters);

  const handleSearch = (searchTerm: string) => {
    setFilters((prev) => ({ ...prev, searchTerm }));
  };

  const handleFilterChange = (newFilters: typeof filters) => {
    setFilters(newFilters);
  };

  const toggleViewMode = () => {
    setViewMode((prev) => (prev === "grid" ? "list" : "grid"));
  };

  if (error) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Oops! Something went wrong
          </h2>
          <p className="text-gray-600 mb-4">{error.message}</p>
          <Button onClick={() => window.location.reload()}>Try Again</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          Library Catalog
        </h1>
        <p className="text-gray-600">
          Discover and borrow books from our extensive collection
        </p>
      </div>

      {/* Search */}
      <div className="mb-6">
        <BookSearchForm onSearch={handleSearch} />
      </div>

      {/* Toolbar */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center space-x-4">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setShowFilters(!showFilters)}
            className="flex items-center space-x-2"
          >
            <Filter className="h-4 w-4" />
            <span>Filters</span>
          </Button>

          {books?.pages[0]?.totalCount && (
            <span className="text-sm text-gray-600">
              {books.pages[0].totalCount} books found
            </span>
          )}
        </div>

        <div className="flex items-center space-x-2">
          <Button
            variant={viewMode === "grid" ? "default" : "outline"}
            size="sm"
            onClick={() => setViewMode("grid")}
          >
            <Grid className="h-4 w-4" />
          </Button>
          <Button
            variant={viewMode === "list" ? "default" : "outline"}
            size="sm"
            onClick={() => setViewMode("list")}
          >
            <List className="h-4 w-4" />
          </Button>
        </div>
      </div>

      <div className="flex gap-6">
        {/* Filters Sidebar */}
        {showFilters && (
          <div className="w-80 flex-shrink-0">
            <BookFilters
              filters={filters}
              onChange={handleFilterChange}
              onReset={() =>
                setFilters({
                  searchTerm: "",
                  categoryId: "",
                  authorName: "",
                  isAvailable: false,
                  publicationYearFrom: "",
                  publicationYearTo: "",
                })
              }
            />
          </div>
        )}

        {/* Main Content */}
        <div className="flex-1">
          {isLoading ? (
            <div className="flex items-center justify-center py-12">
              <LoadingSpinner size="lg" />
            </div>
          ) : (
            <>
              <BookGrid
                books={books?.pages.flatMap((page) => page.items) ?? []}
                viewMode={viewMode}
                onBookSelect={(bookId) => {
                  window.location.href = `/books/${bookId}`;
                }}
              />

              {/* Load More */}
              {hasNextPage && (
                <div className="mt-8 text-center">
                  <Button
                    onClick={() => fetchNextPage()}
                    disabled={isFetchingNextPage}
                    variant="outline"
                  >
                    {isFetchingNextPage ? "Loading..." : "Load More Books"}
                  </Button>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
```

### 2. Book Details Page

```typescript
// app/books/[id]/page.tsx
"use client";

import { useParams } from "next/navigation";
import { useBook, useBookAvailability } from "@/hooks/useBooks";
import { useBorrowBook } from "@/hooks/useBorrowing";
import { useCreateReservation } from "@/hooks/useReservations";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Badge } from "@/components/ui/Badge";
import { LoadingSpinner } from "@/components/ui/LoadingSpinner";
import { BookOpen, Users, Calendar, Award, Heart } from "lucide-react";
import { formatDate } from "@/utils/formatters";
import Image from "next/image";

export default function BookDetailsPage() {
  const params = useParams();
  const bookId = params.id as string;
  const { user, isAuthenticated } = useAuth();

  const { data: book, isLoading, error } = useBook(bookId);
  const { data: availability } = useBookAvailability(bookId);
  const borrowMutation = useBorrowBook();
  const reserveMutation = useCreateReservation();

  const handleBorrow = async () => {
    if (!isAuthenticated) {
      window.location.href = "/auth/login";
      return;
    }

    try {
      await borrowMutation.mutateAsync(bookId);
      // Show success message
    } catch (error) {
      // Handle error
    }
  };

  const handleReserve = async () => {
    if (!isAuthenticated) {
      window.location.href = "/auth/login";
      return;
    }

    try {
      await reserveMutation.mutateAsync(bookId);
      // Show success message
    } catch (error) {
      // Handle error
    }
  };

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="flex items-center justify-center py-12">
          <LoadingSpinner size="lg" />
        </div>
      </div>
    );
  }

  if (error || !book) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Book Not Found
          </h2>
          <p className="text-gray-600 mb-4">
            The book you're looking for doesn't exist or has been removed.
          </p>
          <Button onClick={() => window.history.back()}>Go Back</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Book Cover */}
        <div className="lg:col-span-1">
          <Card className="p-6">
            <div className="aspect-[3/4] relative mb-4">
              <Image
                src={book.coverImageUrl || "/placeholder-book.jpg"}
                alt={book.title}
                fill
                className="object-cover rounded-lg"
              />
            </div>

            {/* Availability Status */}
            <div className="mb-4">
              {availability?.isAvailable ? (
                <Badge variant="success" className="mb-2">
                  Available Now
                </Badge>
              ) : (
                <Badge variant="warning" className="mb-2">
                  Currently Borrowed
                </Badge>
              )}

              <div className="text-sm text-gray-600">
                <p>
                  {availability?.availableQuantity} of{" "}
                  {availability?.totalQuantity} available
                </p>
                {availability?.queueLength > 0 && (
                  <p>{availability.queueLength} people in queue</p>
                )}
              </div>
            </div>

            {/* Action Buttons */}
            <div className="space-y-2">
              {availability?.isAvailable ? (
                <Button
                  onClick={handleBorrow}
                  disabled={borrowMutation.isPending}
                  className="w-full"
                >
                  {borrowMutation.isPending ? "Borrowing..." : "Borrow Book"}
                </Button>
              ) : (
                <Button
                  onClick={handleReserve}
                  disabled={reserveMutation.isPending}
                  variant="outline"
                  className="w-full"
                >
                  {reserveMutation.isPending ? "Reserving..." : "Reserve Book"}
                </Button>
              )}

              <Button variant="outline" className="w-full">
                <Heart className="h-4 w-4 mr-2" />
                Add to Wishlist
              </Button>
            </div>
          </Card>
        </div>

        {/* Book Information */}
        <div className="lg:col-span-2">
          <div className="mb-6">
            <h1 className="text-3xl font-bold text-gray-900 mb-2">
              {book.title}
            </h1>
            {book.subtitle && (
              <h2 className="text-xl text-gray-600 mb-4">{book.subtitle}</h2>
            )}

            <div className="flex flex-wrap gap-2 mb-4">
              {book.authors.map((author, index) => (
                <Badge key={index} variant="secondary">
                  {author}
                </Badge>
              ))}
            </div>

            <div className="flex flex-wrap gap-4 text-sm text-gray-600 mb-6">
              <div className="flex items-center">
                <BookOpen className="h-4 w-4 mr-1" />
                <span>{book.pages} pages</span>
              </div>
              <div className="flex items-center">
                <Calendar className="h-4 w-4 mr-1" />
                <span>{formatDate(book.publicationDate)}</span>
              </div>
              <div className="flex items-center">
                <Award className="h-4 w-4 mr-1" />
                <span>{book.publisher}</span>
              </div>
            </div>
          </div>

          {/* Description */}
          {book.description && (
            <Card className="p-6 mb-6">
              <h3 className="text-lg font-semibold mb-3">Description</h3>
              <p className="text-gray-700 leading-relaxed">
                {book.description}
              </p>
            </Card>
          )}

          {/* Details */}
          <Card className="p-6 mb-6">
            <h3 className="text-lg font-semibold mb-3">Details</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <dt className="font-medium text-gray-900">ISBN</dt>
                <dd className="text-gray-600">{book.isbn}</dd>
              </div>
              <div>
                <dt className="font-medium text-gray-900">Language</dt>
                <dd className="text-gray-600">{book.language}</dd>
              </div>
              <div>
                <dt className="font-medium text-gray-900">Book Type</dt>
                <dd className="text-gray-600">{book.bookType}</dd>
              </div>
              <div>
                <dt className="font-medium text-gray-900">Categories</dt>
                <dd className="flex flex-wrap gap-1">
                  {book.categories.map((category) => (
                    <Badge key={category.id} variant="outline" size="sm">
                      {category.name}
                    </Badge>
                  ))}
                </dd>
              </div>
            </div>
          </Card>

          {/* Related Books */}
          {book.relatedBooks && book.relatedBooks.length > 0 && (
            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-3">Related Books</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {book.relatedBooks.map((relatedBook) => (
                  <div key={relatedBook.id} className="border rounded-lg p-3">
                    <h4 className="font-medium text-sm">{relatedBook.title}</h4>
                    <p className="text-xs text-gray-600">
                      {relatedBook.authors.join(", ")}
                    </p>
                  </div>
                ))}
              </div>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
```

### 3. User Dashboard

```typescript
// app/dashboard/page.tsx
"use client";

import { useUserDashboard } from "@/hooks/useUserLibrary";
import { useAuth } from "@/hooks/useAuth";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { LoadingSpinner } from "@/components/ui/LoadingSpinner";
import {
  BookOpen,
  Clock,
  AlertTriangle,
  DollarSign,
  TrendingUp,
  Calendar,
} from "lucide-react";
import { formatDate, formatCurrency } from "@/utils/formatters";
import Link from "next/link";

export default function DashboardPage() {
  const { user } = useAuth();
  const { data: dashboard, isLoading, error } = useUserDashboard();

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="flex items-center justify-center py-12">
          <LoadingSpinner size="lg" />
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Unable to load dashboard
          </h2>
          <p className="text-gray-600 mb-4">{error.message}</p>
          <Button onClick={() => window.location.reload()}>Try Again</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Welcome back, {user?.name}!
        </h1>
        <p className="text-gray-600">
          Here's what's happening with your library account
        </p>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <Card className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                Books Borrowed
              </p>
              <p className="text-2xl font-bold text-gray-900">
                {dashboard?.stats.currentBorrows}
              </p>
            </div>
            <BookOpen className="h-8 w-8 text-blue-600" />
          </div>
        </Card>

        <Card className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                Active Reservations
              </p>
              <p className="text-2xl font-bold text-gray-900">
                {dashboard?.stats.activeReservations}
              </p>
            </div>
            <Clock className="h-8 w-8 text-orange-600" />
          </div>
        </Card>

        <Card className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Due Soon</p>
              <p className="text-2xl font-bold text-gray-900">
                {dashboard?.stats.dueSoon}
              </p>
            </div>
            <AlertTriangle className="h-8 w-8 text-yellow-600" />
          </div>
        </Card>

        <Card className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">
                Outstanding Fines
              </p>
              <p className="text-2xl font-bold text-gray-900">
                {formatCurrency(dashboard?.stats.outstandingFines ?? 0)}
              </p>
            </div>
            <DollarSign className="h-8 w-8 text-red-600" />
          </div>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Current Borrows */}
        <Card className="p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold">Currently Borrowed</h2>
            <Link href="/my-library/borrowed">
              <Button variant="outline" size="sm">
                View All
              </Button>
            </Link>
          </div>

          {dashboard?.currentBorrows.length === 0 ? (
            <div className="text-center py-8">
              <BookOpen className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No books currently borrowed</p>
              <Link href="/books">
                <Button className="mt-4">Browse Books</Button>
              </Link>
            </div>
          ) : (
            <div className="space-y-4">
              {dashboard?.currentBorrows.slice(0, 3).map((borrow) => (
                <div
                  key={borrow.id}
                  className="flex items-start space-x-4 p-4 border rounded-lg"
                >
                  <div className="flex-1 min-w-0">
                    <h3 className="font-medium text-gray-900 truncate">
                      {borrow.bookTitle}
                    </h3>
                    <p className="text-sm text-gray-600">
                      by {borrow.bookAuthors.join(", ")}
                    </p>
                    <div className="flex items-center mt-2 space-x-4">
                      <span className="text-xs text-gray-500">
                        Due: {formatDate(borrow.dueDate)}
                      </span>
                      {borrow.isOverdue && (
                        <Badge variant="destructive" size="sm">
                          Overdue
                        </Badge>
                      )}
                      {borrow.daysUntilDue <= 3 && !borrow.isOverdue && (
                        <Badge variant="warning" size="sm">
                          Due Soon
                        </Badge>
                      )}
                    </div>
                  </div>
                  <div className="flex flex-col space-y-2">
                    {borrow.canRenew && (
                      <Button size="sm" variant="outline">
                        Renew
                      </Button>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>

        {/* Active Reservations */}
        <Card className="p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold">Active Reservations</h2>
            <Link href="/my-library/reservations">
              <Button variant="outline" size="sm">
                View All
              </Button>
            </Link>
          </div>

          {dashboard?.activeReservations.length === 0 ? (
            <div className="text-center py-8">
              <Clock className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No active reservations</p>
            </div>
          ) : (
            <div className="space-y-4">
              {dashboard?.activeReservations.slice(0, 3).map((reservation) => (
                <div
                  key={reservation.id}
                  className="flex items-start space-x-4 p-4 border rounded-lg"
                >
                  <div className="flex-1 min-w-0">
                    <h3 className="font-medium text-gray-900 truncate">
                      {reservation.bookTitle}
                    </h3>
                    <p className="text-sm text-gray-600">
                      by {reservation.bookAuthors.join(", ")}
                    </p>
                    <div className="flex items-center mt-2 space-x-4">
                      <span className="text-xs text-gray-500">
                        Position: #{reservation.queuePosition}
                      </span>
                      <span className="text-xs text-gray-500">
                        Est. available:{" "}
                        {formatDate(reservation.estimatedAvailableDate)}
                      </span>
                    </div>
                  </div>
                  <Button size="sm" variant="outline">
                    Cancel
                  </Button>
                </div>
              ))}
            </div>
          )}
        </Card>
      </div>

      {/* Quick Actions */}
      <Card className="p-6 mt-8">
        <h2 className="text-lg font-semibold mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Link href="/books">
            <Button className="w-full" variant="outline">
              <BookOpen className="h-4 w-4 mr-2" />
              Browse Books
            </Button>
          </Link>
          <Link href="/my-library/history">
            <Button className="w-full" variant="outline">
              <TrendingUp className="h-4 w-4 mr-2" />
              View History
            </Button>
          </Link>
          <Link href="/my-library/fines">
            <Button className="w-full" variant="outline">
              <DollarSign className="h-4 w-4 mr-2" />
              Pay Fines
            </Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
```

## Generated Component Implementations

### BookCard Component

```typescript
// components/books/BookCard.tsx
"use client";

import { Book } from "@/services/types/book";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { BookOpen, Users, Calendar } from "lucide-react";
import { formatDate } from "@/utils/formatters";
import Image from "next/image";
import Link from "next/link";

interface BookCardProps {
  book: Book;
  variant?: "grid" | "list" | "compact";
  showActions?: boolean;
  onBorrow?: (bookId: string) => void;
  onReserve?: (bookId: string) => void;
  onViewDetails?: (bookId: string) => void;
}

export function BookCard({
  book,
  variant = "grid",
  showActions = true,
  onBorrow,
  onReserve,
  onViewDetails,
}: BookCardProps) {
  const handleBorrow = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    onBorrow?.(book.id);
  };

  const handleReserve = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    onReserve?.(book.id);
  };

  if (variant === "list") {
    return (
      <Card className="p-4 hover:shadow-md transition-shadow">
        <Link href={`/books/${book.id}`} className="block">
          <div className="flex space-x-4">
            <div className="w-20 h-28 flex-shrink-0">
              <Image
                src={book.coverImageUrl || "/placeholder-book.jpg"}
                alt={book.title}
                width={80}
                height={112}
                className="w-full h-full object-cover rounded"
              />
            </div>

            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-gray-900 truncate">
                {book.title}
              </h3>
              {book.subtitle && (
                <p className="text-sm text-gray-600 truncate">
                  {book.subtitle}
                </p>
              )}
              <p className="text-sm text-gray-600 mt-1">
                by {book.authors.join(", ")}
              </p>

              <div className="flex items-center space-x-4 mt-2 text-xs text-gray-500">
                <div className="flex items-center">
                  <Calendar className="h-3 w-3 mr-1" />
                  {formatDate(book.publicationDate)}
                </div>
                <div className="flex items-center">
                  <BookOpen className="h-3 w-3 mr-1" />
                  {book.pages} pages
                </div>
              </div>

              <div className="flex items-center justify-between mt-3">
                <div className="flex items-center space-x-2">
                  {book.isAvailable ? (
                    <Badge variant="success" size="sm">
                      Available
                    </Badge>
                  ) : (
                    <Badge variant="warning" size="sm">
                      Borrowed
                    </Badge>
                  )}
                  <span className="text-xs text-gray-500">
                    {book.availableQuantity} of {book.totalQuantity} available
                  </span>
                </div>

                {showActions && (
                  <div className="flex space-x-2">
                    {book.isAvailable ? (
                      <Button size="sm" onClick={handleBorrow}>
                        Borrow
                      </Button>
                    ) : (
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={handleReserve}
                      >
                        Reserve
                      </Button>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        </Link>
      </Card>
    );
  }

  return (
    <Card className="p-4 hover:shadow-md transition-shadow h-full">
      <Link href={`/books/${book.id}`} className="block h-full">
        <div className="flex flex-col h-full">
          <div className="aspect-[3/4] relative mb-3">
            <Image
              src={book.coverImageUrl || "/placeholder-book.jpg"}
              alt={book.title}
              fill
              className="object-cover rounded"
            />
          </div>

          <div className="flex-1 flex flex-col">
            <h3 className="font-semibold text-gray-900 line-clamp-2 mb-1">
              {book.title}
            </h3>
            <p className="text-sm text-gray-600 line-clamp-1 mb-2">
              by {book.authors.join(", ")}
            </p>

            <div className="flex items-center justify-between mb-3">
              {book.isAvailable ? (
                <Badge variant="success" size="sm">
                  Available
                </Badge>
              ) : (
                <Badge variant="warning" size="sm">
                  Borrowed
                </Badge>
              )}
              <span className="text-xs text-gray-500">
                {book.availableQuantity}/{book.totalQuantity}
              </span>
            </div>

            {showActions && (
              <div className="mt-auto">
                {book.isAvailable ? (
                  <Button className="w-full" size="sm" onClick={handleBorrow}>
                    Borrow
                  </Button>
                ) : (
                  <Button
                    className="w-full"
                    size="sm"
                    variant="outline"
                    onClick={handleReserve}
                  >
                    Reserve
                  </Button>
                )}
              </div>
            )}
          </div>
        </div>
      </Link>
    </Card>
  );
}
```

## Generated Custom Hooks

### useBooks Hook

```typescript
// hooks/useBooks.ts
import {
  useInfiniteQuery,
  useQuery,
  useMutation,
  useQueryClient,
} from "@tanstack/react-query";
import { bookService } from "@/services/api/books";
import { BookFilters, Book } from "@/services/types/book";

export function useBooks(filters: BookFilters) {
  return useInfiniteQuery({
    queryKey: ["books", filters],
    queryFn: ({ pageParam = 0 }) =>
      bookService.getBooks({
        ...filters,
        skipCount: pageParam,
        maxResultCount: 20,
      }),
    initialPageParam: 0,
    getNextPageParam: (lastPage, allPages) => {
      const totalLoaded = allPages.reduce(
        (sum, page) => sum + page.items.length,
        0
      );
      return totalLoaded < lastPage.totalCount ? totalLoaded : undefined;
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useBook(bookId: string) {
  return useQuery({
    queryKey: ["books", bookId],
    queryFn: () => bookService.getBook(bookId),
    enabled: !!bookId,
    staleTime: 10 * 60 * 1000, // 10 minutes
  });
}

export function useBookAvailability(bookId: string) {
  return useQuery({
    queryKey: ["books", bookId, "availability"],
    queryFn: () => bookService.getBookAvailability(bookId),
    enabled: !!bookId,
    refetchInterval: 30 * 1000, // Refresh every 30 seconds
  });
}

export function useSearchSuggestions(query: string) {
  return useQuery({
    queryKey: ["books", "suggestions", query],
    queryFn: () => bookService.getSearchSuggestions(query),
    enabled: query.length >= 2,
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
}

export function useBorrowBook() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: bookService.borrowBook,
    onSuccess: () => {
      // Invalidate relevant queries
      queryClient.invalidateQueries({ queryKey: ["books"] });
      queryClient.invalidateQueries({ queryKey: ["userLibrary"] });
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
  });
}
```

## Generated API Services

```typescript
// services/api/books.ts
import { apiClient } from "./client";
import {
  Book,
  BookFilters,
  BookSuggestion,
  BookAvailability,
  PagedResult,
  BorrowResult,
} from "../types";

export const bookService = {
  async getBooks(
    params: BookFilters & { skipCount: number; maxResultCount: number }
  ): Promise<PagedResult<Book>> {
    const response = await apiClient.get("/api/app/books", { params });
    return response.data;
  },

  async getBook(id: string): Promise<Book> {
    const response = await apiClient.get(`/api/app/books/${id}`);
    return response.data;
  },

  async getBookAvailability(id: string): Promise<BookAvailability> {
    const response = await apiClient.get(`/api/app/books/${id}/availability`);
    return response.data;
  },

  async getSearchSuggestions(query: string): Promise<BookSuggestion[]> {
    const response = await apiClient.get("/api/app/book-search/suggestions", {
      params: { query, maxResults: 10 },
    });
    return response.data;
  },

  async borrowBook(bookId: string): Promise<BorrowResult> {
    const response = await apiClient.post("/api/app/book-borrowing/borrow", {
      bookId,
    });
    return response.data;
  },

  async createBook(data: CreateBookData): Promise<Book> {
    const response = await apiClient.post("/api/app/books", data);
    return response.data;
  },

  async updateBook(id: string, data: UpdateBookData): Promise<Book> {
    const response = await apiClient.put(`/api/app/books/${id}`, data);
    return response.data;
  },

  async deleteBook(id: string): Promise<void> {
    await apiClient.delete(`/api/app/books/${id}`);
  },
};
```

## Generated Type Definitions

```typescript
// services/types/book.ts
export interface Book {
  id: string;
  isbn: string;
  title: string;
  subtitle?: string;
  description?: string;
  authors: string[];
  publisher: string;
  publicationDate: string;
  language: string;
  pages: number;
  categories: Category[];
  totalQuantity: number;
  availableQuantity: number;
  borrowedQuantity: number;
  reservedQuantity: number;
  bookType: BookType;
  coverImageUrl?: string;
  isAvailable: boolean;
  relatedBooks?: Book[];
}

export interface BookFilters {
  searchTerm?: string;
  categoryId?: string;
  authorName?: string;
  isAvailable?: boolean;
  publicationYearFrom?: string;
  publicationYearTo?: string;
}

export interface BookSuggestion {
  id: string;
  title: string;
  authors: string[];
  type: "title" | "author" | "isbn";
}

export interface BookAvailability {
  bookId: string;
  isAvailable: boolean;
  totalQuantity: number;
  availableQuantity: number;
  queueLength: number;
  estimatedAvailableDate?: string;
}

export enum BookType {
  Regular = "Regular",
  Reference = "Reference",
  NewRelease = "NewRelease",
  Textbook = "Textbook",
  Journal = "Journal",
}

export interface Category {
  id: string;
  name: string;
  description?: string;
  parentCategoryId?: string;
  isActive: boolean;
  displayOrder: number;
}
```

This generated frontend provides a comprehensive, modern React application with TypeScript, proper state management, and excellent user experience that integrates seamlessly with the backend API.
