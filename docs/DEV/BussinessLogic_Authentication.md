# Authentication Domain Model - Business Logic Documentation

## Overview

This document describes the business logic, rules, and workflows implemented in the Authentication domain model. The domain model follows Domain-Driven Design principles and implements secure authentication patterns using ABP Framework.

## Business Rules

### User Registration Rules

1. **Email Uniqueness**: Each user must have a unique email address across the system
   - Implemented in: ABP Identity framework validation
   - Validation occurs at application layer before entity creation

2. **Password Complexity**: Passwords must meet security requirements
   - Minimum 8 characters
   - At least one uppercase letter (A-Z)
   - At least one lowercase letter (a-z)
   - At least one digit (0-9)
   - Implemented in: `Password` value object validation

3. **Email Format Validation**: Email addresses must follow standard email format
   - Implemented in: `EmailAddress` value object using regex validation
   - Case-insensitive validation and storage

4. **Automatic Login**: Successfully registered users are automatically logged in
   - Implemented in: Application service layer after user creation

### Authentication Rules

5. **Account Lockout**: User accounts are locked after 5 consecutive failed login attempts
   - Implemented in: ABP Identity framework `AccessFailedCount` property
   - Automatic unlock after specified time period

6. **Password Verification**: Passwords are verified using secure hashing
   - Implemented in: `Password` value object using BCrypt
   - Cost factor of 12 for enhanced security

### Password Reset Rules

7. **Token Expiration**: Password reset tokens expire after 60 minutes
   - Implemented in: `PasswordResetToken.ExpirationTimeUtc` property
   - Constant: `PasswordResetToken.ExpirationMinutes = 60`

8. **Single Use Tokens**: Each password reset token can only be used once
   - Implemented in: `PasswordResetToken.IsUsed` property
   - Enforced by `MarkAsUsed()` method

9. **Token Security**: Reset tokens are stored as hashes, never in plain text
   - Plain text tokens are only used in email notifications
   - Hashed using secure hashing algorithm before database storage

10. **Silent Failure**: Password reset requests for non-existent emails fail silently
    - Prevents email enumeration attacks
    - Returns success response regardless of email existence

## Entity Behaviors

### AppUser Entity

The `AppUser` entity extends ABP Framework's `IdentityUser` and inherits comprehensive user management functionality:

- **User Creation**: Creates user with validated email and hashed password
- **Profile Management**: Supports user profile updates through ABP Identity
- **Role Assignment**: Integrates with ABP permission system
- **Multi-tenancy**: Supports tenant isolation when enabled

**Key Methods inherited from IdentityUser**:
- Email and username validation
- Password hashing and verification
- Account lockout management
- Email confirmation workflows

### PasswordResetToken Entity

The `PasswordResetToken` entity manages secure password reset workflows:

**Key Methods**:
- `MarkAsUsed()`: Marks token as consumed and prevents reuse
- `IsExpired()`: Checks if token has passed expiration time
- `IsValid()`: Validates token is not expired and not used

**Business Logic**:
- Tokens are created with 60-minute expiration
- Constructor validates expiration time is in future
- Token hash must be provided (never null)
- Audit properties track creation and usage

## Value Object Logic

### EmailAddress Value Object

Encapsulates email validation and manipulation logic:

**Validation Logic**:
- Regex pattern validates standard email format
- Null/empty/whitespace validation
- Case normalization (converts to lowercase)

**Business Operations**:
- `GetDomain()`: Extracts domain portion (e.g., "gmail.com")
- `GetLocalPart()`: Extracts local portion (e.g., "user")
- `BelongsToDomain()`: Checks if email belongs to specific domain
- `IsValid()`: Static method for format validation

**Security Features**:
- Immutable design prevents modification after creation
- Input sanitization through trimming and case normalization

### Password Value Object

Encapsulates password security and complexity logic:

**Creation Methods**:
- `Create()`: Creates from plain text with validation and hashing
- `FromHash()`: Creates from existing hash (for database loading)

**Security Operations**:
- `ValidateComplexity()`: Enforces password complexity rules
- `Hash()`: Uses BCrypt with cost factor 12
- `Verify()`: Compares plain text against stored hash
- `ChangePassword()`: Creates new password with validation

**Security Features**:
- Never stores plain text passwords
- Immutable design prevents hash modification
- ToString() returns masked value for security
- Hash format validation for integrity checks

## Domain Event Scenarios

### UserRegisteredEventData

**Triggered When**: New user completes registration successfully

**Properties**:
- User ID, email, username, registration timestamp
- IP address and user agent for security audit
- Tenant ID for multi-tenant scenarios

**Use Cases**:
- Send welcome email
- Initialize user preferences
- Security logging and monitoring
- Analytics and reporting

### PasswordResetRequestedEventData

**Triggered When**: User requests password reset

**Properties**:
- User ID, email, plain text reset token
- Request timestamp and expiration time
- IP address and user agent for security

**Use Cases**:
- Send password reset email with token
- Security monitoring for unusual patterns
- Rate limiting implementation
- Audit trail for compliance

### PasswordResetCompletedEventData

**Triggered When**: User successfully resets password using token

**Properties**:
- User ID, email, reset timestamp
- Token ID used for reset
- Completion duration for analytics
- IP address and user agent

**Use Cases**:
- Security notification emails
- Audit logging for compliance
- Performance monitoring
- Fraud detection

### UserLoginEventData

**Triggered When**: User successfully authenticates

**Properties**:
- User ID, email, username, login timestamp
- Previous failed attempts and lockout status
- Device and location information
- IP address and user agent

**Use Cases**:
- Security monitoring and alerting
- Session management
- Location-based security checks
- User behavior analytics

### UserLogoutEventData

**Triggered When**: User ends session

**Properties**:
- User ID, email, username, logout timestamp
- Session duration and logout type
- Logout reason (manual, expired, forced)
- IP address and user agent

**Use Cases**:
- Session cleanup and invalidation
- Security audit trail
- User activity analytics
- Session timeout management

## Invariants

### System-Wide Invariants

1. **Email Uniqueness**: No two users can have the same email address
2. **Password Security**: All passwords must be securely hashed using BCrypt
3. **Token Integrity**: Reset tokens must be cryptographically secure and expire
4. **Audit Compliance**: All authentication events must be logged

### Entity Invariants

#### PasswordResetToken Invariants
- Token expiration time must be in the future when created
- Token hash cannot be null or empty
- Used tokens cannot be used again
- Expired tokens cannot be marked as used

#### EmailAddress Invariants
- Email value must be valid format
- Email is always stored in lowercase
- Email cannot be null, empty, or whitespace

#### Password Invariants
- Password hash must be valid BCrypt format
- Plain text passwords are never stored
- Password complexity rules must be satisfied before hashing

## Validation Rules

### Input Validation

1. **Email Validation**:
   - Format validation using regex
   - Length limits (standard email constraints)
   - Case normalization

2. **Password Validation**:
   - Minimum length: 8 characters
   - Character complexity requirements
   - Maximum length: 100 characters (practical limit)

3. **Token Validation**:
   - Hash format validation
   - Expiration time validation
   - Usage status validation

### Business Rule Validation

1. **Registration Validation**:
   - Email uniqueness check
   - Password complexity verification
   - Input sanitization

2. **Authentication Validation**:
   - Account status verification (not locked)
   - Password verification against hash
   - Failed attempt tracking

3. **Password Reset Validation**:
   - Token existence and validity
   - Expiration time check
   - Single-use enforcement

## Business Workflows

### User Registration Workflow

1. **Input Validation**:
   - Validate email format using `EmailAddress` value object
   - Validate password complexity using `Password` value object
   - Check password confirmation match

2. **Business Rule Enforcement**:
   - Verify email uniqueness in system
   - Hash password using BCrypt

3. **Entity Creation**:
   - Create `AppUser` entity with validated data
   - Set appropriate audit properties

4. **Event Publishing**:
   - Publish `UserRegisteredEventData` for downstream processing

5. **Auto-Login**:
   - Generate authentication session
   - Return authenticated user context

### User Login Workflow

1. **Input Processing**:
   - Normalize email using `EmailAddress` value object
   - Validate input format

2. **User Lookup**:
   - Find user by normalized email
   - Check account status (not locked, confirmed)

3. **Authentication**:
   - Verify password using `Password.Verify()`
   - Update failed attempt counters
   - Apply lockout logic if needed

4. **Session Creation**:
   - Generate JWT token or session
   - Update last login timestamp

5. **Event Publishing**:
   - Publish `UserLoginEventData` with security context

### Password Reset Request Workflow

1. **Input Validation**:
   - Validate email format using `EmailAddress` value object

2. **User Lookup**:
   - Find user by email (silent failure if not found)
   - Check account status

3. **Token Generation**:
   - Generate cryptographically secure token
   - Hash token for database storage
   - Create `PasswordResetToken` entity with 60-minute expiration

4. **Cleanup**:
   - Invalidate existing unused tokens for user
   - Store new token in repository

5. **Event Publishing**:
   - Publish `PasswordResetRequestedEventData` with plain text token for email

### Password Reset Completion Workflow

1. **Token Validation**:
   - Find token by hash using specification
   - Verify token is not expired using `IsValid()`
   - Verify token is not already used

2. **Password Update**:
   - Validate new password complexity
   - Create new `Password` value object with hashing
   - Update user password hash

3. **Token Consumption**:
   - Mark token as used via `MarkAsUsed()`
   - Prevent further use of token

4. **Security Cleanup**:
   - Invalidate all sessions for user
   - Clear failed login attempts

5. **Event Publishing**:
   - Publish `PasswordResetCompletedEventData` for audit

### User Logout Workflow

1. **Session Validation**:
   - Verify active session exists
   - Extract user context

2. **Session Cleanup**:
   - Invalidate JWT token or session
   - Clear client-side authentication data

3. **Audit Logging**:
   - Calculate session duration
   - Determine logout type (manual, forced, expired)

4. **Event Publishing**:
   - Publish `UserLogoutEventData` with session metadata

## Security Considerations

### Data Protection
- Passwords are never stored in plain text
- Reset tokens are hashed before storage
- Sensitive data is masked in logs

### Attack Prevention
- Email enumeration prevention through silent failures
- Brute force protection via account lockout
- Token replay protection through single-use enforcement
- Session fixation prevention through token regeneration

### Compliance
- Audit trails for all authentication events
- Secure password storage using industry standards
- Token expiration for minimal exposure window
- Multi-factor authentication readiness (extensible design)

## Performance Considerations

### Database Optimization
- Indexes on frequently queried fields (email, token hash)
- Soft delete for audit trail preservation
- Bulk cleanup operations for expired tokens

### Caching Strategy
- User profile caching for frequent lookups
- Session data caching in Redis
- Email validation result caching

### Query Optimization
- Specification pattern for reusable, optimized queries
- AsNoTracking() for read-only operations
- Pagination for large result sets