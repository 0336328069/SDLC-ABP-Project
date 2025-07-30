# Entity Relationship Diagram: Authentication Feature v1.0

## Document Information

- **Version**: 1.0
- **Date**: December 19, 2024
- **Feature**: Authentication System
- **Prepared By**: Development Team
- **Reviewed By**: Technical Lead
- **Approved By**: Project Manager

---

## 1. Overview

This document presents the Entity Relationship Diagram (ERD) for the Authentication feature of the ABP Enterprise Application. The ERD illustrates the data model, relationships, and constraints required to support user registration, login, password reset, and session management functionalities.

### 1.1 Scope

The ERD covers the following authentication-related entities:
- **User Management**: User accounts and profiles
- **Session Management**: User sessions and authentication tokens
- **Password Reset**: Password reset tokens and workflow
- **Security**: Account lockout and failed login tracking

### 1.2 Technology Context

- **Framework**: ABP Framework 8.3.0 with Entity Framework Core
- **Database**: SQL Server
- **Architecture**: Domain-Driven Design (DDD) with Clean Architecture
- **Caching**: Redis for session and user data

---

## 2. Entity Relationship Diagram

### 2.1 Visual ERD

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           Authentication System ERD                             │
└─────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────┐         ┌──────────────────────────┐
│        AbpUsers          │         │       Sessions           │
│ (Extended ABP Identity)  │         │                          │
├──────────────────────────┤    1:N  ├──────────────────────────┤
│ Id (PK)                  │◄────────┤ Id (PK)                  │
│ UserName                 │         │ UserId (FK)              │
│ Email (Unique)           │         │ TokenHash                │
│ EmailConfirmed           │         │ CreatedAt                │
│ PasswordHash             │         │ ExpiresAt                │
│ SecurityStamp            │         │ IsActive                 │
│ PhoneNumber              │         │ LastAccessedAt           │
│ TwoFactorEnabled         │         │ IpAddress                │
│ LockoutEnd               │         │ UserAgent                │
│ LockoutEnabled           │         └──────────────────────────┘
│ AccessFailedCount        │
│ CreationTime             │         ┌──────────────────────────┐
│ CreatorId                │         │   PasswordResetTokens    │
│ LastModificationTime     │         │                          │
│ LastModifierId           │    1:N  ├──────────────────────────┤
│ IsDeleted                │◄────────┤ Id (PK)                  │
│ DeleterId                │         │ UserId (FK)              │
│ DeletionTime             │         │ TokenHash                │
│ TenantId                 │         │ CreatedAt                │
│ ConcurrencyStamp         │         │ ExpiresAt                │
└──────────────────────────┘         │ IsUsed                   │
                                     │ UsedAt                   │
                                     │ IpAddress                │
                                     │ UserAgent                │
                                     └──────────────────────────┘

┌──────────────────────────┐         ┌──────────────────────────┐
│    LoginAttempts         │         │      UserSessions        │
│   (Security Tracking)   │         │    (Active Sessions)     │
├──────────────────────────┤    1:N  ├──────────────────────────┤
│ Id (PK)                  │◄────────┤ Id (PK)                  │
│ UserId (FK)              │         │ UserId (FK)              │
│ Email                    │         │ SessionId (FK)           │
│ IpAddress                │         │ DeviceInfo               │
│ UserAgent                │         │ Location                 │
│ AttemptedAt              │         │ IsCurrentSession         │
│ IsSuccessful             │         │ CreatedAt                │
│ FailureReason            │         │ LastActivityAt           │
│ TenantId                 │         └──────────────────────────┘
└──────────────────────────┘
```

### 2.2 Entity Relationships Summary

| Parent Entity | Child Entity | Relationship | Cardinality | Description |
|---------------|--------------|--------------|-------------|-------------|
| AbpUsers | Sessions | One-to-Many | 1:N | A user can have multiple active sessions |
| AbpUsers | PasswordResetTokens | One-to-Many | 1:N | A user can have multiple reset tokens (historical) |
| AbpUsers | LoginAttempts | One-to-Many | 1:N | A user can have multiple login attempts |
| AbpUsers | UserSessions | One-to-Many | 1:N | A user can have multiple session records |
| Sessions | UserSessions | One-to-One | 1:1 | Each session has detailed session information |

---

## 3. Entity Specifications

### 3.1 AbpUsers (Extended ABP Identity)

**Purpose**: Core user entity extending ABP Framework's Identity module for authentication.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| Id | UNIQUEIDENTIFIER | PK, NOT NULL | Primary key, auto-generated GUID |
| UserName | NVARCHAR(256) | NOT NULL, UNIQUE | Username for login (can be same as email) |
| Email | NVARCHAR(256) | NOT NULL, UNIQUE | User's email address (primary identifier) |
| EmailConfirmed | BIT | NOT NULL, DEFAULT 0 | Email verification status |
| PasswordHash | NVARCHAR(512) | NOT NULL | BCrypt hashed password (cost factor 12) |
| SecurityStamp | NVARCHAR(256) | NOT NULL | Security stamp for token invalidation |
| PhoneNumber | NVARCHAR(50) | NULL | User's phone number |
| TwoFactorEnabled | BIT | NOT NULL, DEFAULT 0 | Two-factor authentication status |
| LockoutEnd | DATETIME2 | NULL | Account lockout expiration time |
| LockoutEnabled | BIT | NOT NULL, DEFAULT 1 | Whether account can be locked |
| AccessFailedCount | INT | NOT NULL, DEFAULT 0 | Failed login attempts counter |
| CreationTime | DATETIME2 | NOT NULL, DEFAULT GETUTCDATE() | Account creation timestamp |
| CreatorId | UNIQUEIDENTIFIER | NULL | ID of user who created this account |
| LastModificationTime | DATETIME2 | NULL | Last modification timestamp |
| LastModifierId | UNIQUEIDENTIFIER | NULL | ID of user who last modified |
| IsDeleted | BIT | NOT NULL, DEFAULT 0 | Soft delete flag |
| DeleterId | UNIQUEIDENTIFIER | NULL | ID of user who deleted |
| DeletionTime | DATETIME2 | NULL | Deletion timestamp |
| TenantId | UNIQUEIDENTIFIER | NULL | Multi-tenant identifier |
| ConcurrencyStamp | NVARCHAR(40) | NOT NULL | Optimistic concurrency control |

**Business Rules**:
- Email must be unique across the system
- Password must meet complexity requirements (8+ chars, uppercase, lowercase, number)
- Account locks after 5 failed login attempts within 15 minutes
- Lockout duration is 15 minutes

### 3.2 Sessions

**Purpose**: Manages user authentication sessions and JWT tokens.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| Id | UNIQUEIDENTIFIER | PK, NOT NULL | Primary key, auto-generated GUID |
| UserId | UNIQUEIDENTIFIER | FK, NOT NULL | Reference to AbpUsers.Id |
| TokenHash | NVARCHAR(512) | NOT NULL, UNIQUE | Hashed session token for security |
| CreatedAt | DATETIME2 | NOT NULL, DEFAULT GETUTCDATE() | Session creation timestamp |
| ExpiresAt | DATETIME2 | NOT NULL | Session expiration timestamp |
| IsActive | BIT | NOT NULL, DEFAULT 1 | Session active status |
| LastAccessedAt | DATETIME2 | NULL | Last activity timestamp |
| IpAddress | NVARCHAR(45) | NULL | Client IP address (IPv4/IPv6) |
| UserAgent | NVARCHAR(500) | NULL | Client browser/device information |

**Business Rules**:
- Sessions expire after 24 hours of inactivity
- Maximum 5 concurrent sessions per user
- Tokens are cryptographically secure and hashed
- Automatic cleanup of expired sessions

### 3.3 PasswordResetTokens

**Purpose**: Manages password reset tokens for secure password recovery.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| Id | UNIQUEIDENTIFIER | PK, NOT NULL | Primary key, auto-generated GUID |
| UserId | UNIQUEIDENTIFIER | FK, NOT NULL | Reference to AbpUsers.Id |
| TokenHash | NVARCHAR(512) | NOT NULL, UNIQUE | Hashed reset token for security |
| CreatedAt | DATETIME2 | NOT NULL, DEFAULT GETUTCDATE() | Token creation timestamp |
| ExpiresAt | DATETIME2 | NOT NULL | Token expiration timestamp |
| IsUsed | BIT | NOT NULL, DEFAULT 0 | Token usage status |
| UsedAt | DATETIME2 | NULL | Token usage timestamp |
| IpAddress | NVARCHAR(45) | NULL | Client IP address when requested |
| UserAgent | NVARCHAR(500) | NULL | Client browser/device information |

**Business Rules**:
- Tokens expire after 60 minutes
- One-time use only (IsUsed = true after successful reset)
- Maximum 3 reset requests per hour per email
- Automatic cleanup of expired/used tokens

### 3.4 LoginAttempts

**Purpose**: Tracks login attempts for security monitoring and account protection.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| Id | UNIQUEIDENTIFIER | PK, NOT NULL | Primary key, auto-generated GUID |
| UserId | UNIQUEIDENTIFIER | FK, NULL | Reference to AbpUsers.Id (null for non-existent users) |
| Email | NVARCHAR(256) | NOT NULL | Email used in login attempt |
| IpAddress | NVARCHAR(45) | NOT NULL | Client IP address |
| UserAgent | NVARCHAR(500) | NULL | Client browser/device information |
| AttemptedAt | DATETIME2 | NOT NULL, DEFAULT GETUTCDATE() | Login attempt timestamp |
| IsSuccessful | BIT | NOT NULL | Login attempt result |
| FailureReason | NVARCHAR(200) | NULL | Reason for failed login |
| TenantId | UNIQUEIDENTIFIER | NULL | Multi-tenant identifier |

**Business Rules**:
- Records all login attempts (successful and failed)
- Used for security analysis and threat detection
- Automatic cleanup after 90 days
- Triggers account lockout after 5 failed attempts

### 3.5 UserSessions

**Purpose**: Extended session information for user activity tracking.

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| Id | UNIQUEIDENTIFIER | PK, NOT NULL | Primary key, auto-generated GUID |
| UserId | UNIQUEIDENTIFIER | FK, NOT NULL | Reference to AbpUsers.Id |
| SessionId | UNIQUEIDENTIFIER | FK, NOT NULL | Reference to Sessions.Id |
| DeviceInfo | NVARCHAR(200) | NULL | Device type and OS information |
| Location | NVARCHAR(100) | NULL | Approximate geographic location |
| IsCurrentSession | BIT | NOT NULL, DEFAULT 0 | Current active session flag |
| CreatedAt | DATETIME2 | NOT NULL, DEFAULT GETUTCDATE() | Session creation timestamp |
| LastActivityAt | DATETIME2 | NOT NULL | Last user activity timestamp |

**Business Rules**:
- One current session per device type
- Used for "Active Sessions" management
- Automatic cleanup when parent session expires

---

## 4. Database Indexes and Constraints

### 4.1 Primary Keys
- `PK_AbpUsers` on AbpUsers(Id)
- `PK_Sessions` on Sessions(Id)
- `PK_PasswordResetTokens` on PasswordResetTokens(Id)
- `PK_LoginAttempts` on LoginAttempts(Id)
- `PK_UserSessions` on UserSessions(Id)

### 4.2 Foreign Key Constraints
- `FK_Sessions_UserId` on Sessions(UserId) → AbpUsers(Id)
- `FK_PasswordResetTokens_UserId` on PasswordResetTokens(UserId) → AbpUsers(Id)
- `FK_LoginAttempts_UserId` on LoginAttempts(UserId) → AbpUsers(Id)
- `FK_UserSessions_UserId` on UserSessions(UserId) → AbpUsers(Id)
- `FK_UserSessions_SessionId` on UserSessions(SessionId) → Sessions(Id)

### 4.3 Unique Constraints
- `UQ_AbpUsers_Email` on AbpUsers(Email)
- `UQ_AbpUsers_UserName` on AbpUsers(UserName)
- `UQ_Sessions_TokenHash` on Sessions(TokenHash)
- `UQ_PasswordResetTokens_TokenHash` on PasswordResetTokens(TokenHash)

### 4.4 Performance Indexes

#### 4.4.1 Authentication Indexes
```sql
-- User lookup by email (login)
CREATE INDEX IX_AbpUsers_Email ON AbpUsers(Email) WHERE IsDeleted = 0;

-- User lookup by username
CREATE INDEX IX_AbpUsers_UserName ON AbpUsers(UserName) WHERE IsDeleted = 0;

-- Account lockout queries
CREATE INDEX IX_AbpUsers_LockoutEnd ON AbpUsers(LockoutEnd) WHERE LockoutEnd IS NOT NULL;
```

#### 4.4.2 Session Management Indexes
```sql
-- Session validation by token
CREATE INDEX IX_Sessions_TokenHash ON Sessions(TokenHash) WHERE IsActive = 1;

-- User's active sessions
CREATE INDEX IX_Sessions_UserId_IsActive ON Sessions(UserId, IsActive);

-- Session cleanup by expiration
CREATE INDEX IX_Sessions_ExpiresAt ON Sessions(ExpiresAt) WHERE IsActive = 1;
```

#### 4.4.3 Password Reset Indexes
```sql
-- Token validation
CREATE INDEX IX_PasswordResetTokens_TokenHash ON PasswordResetTokens(TokenHash) WHERE IsUsed = 0;

-- User's reset tokens
CREATE INDEX IX_PasswordResetTokens_UserId_IsUsed ON PasswordResetTokens(UserId, IsUsed);

-- Token cleanup by expiration
CREATE INDEX IX_PasswordResetTokens_ExpiresAt ON PasswordResetTokens(ExpiresAt) WHERE IsUsed = 0;
```

#### 4.4.4 Security Monitoring Indexes
```sql
-- Failed login attempts by email
CREATE INDEX IX_LoginAttempts_Email_AttemptedAt ON LoginAttempts(Email, AttemptedAt) WHERE IsSuccessful = 0;

-- User login history
CREATE INDEX IX_LoginAttempts_UserId_AttemptedAt ON LoginAttempts(UserId, AttemptedAt);

-- IP-based security analysis
CREATE INDEX IX_LoginAttempts_IpAddress_AttemptedAt ON LoginAttempts(IpAddress, AttemptedAt);
```

---

## 5. Data Integrity and Security

### 5.1 Data Validation Rules

#### 5.1.1 Email Validation
- Must conform to RFC 5322 standard
- Maximum length: 256 characters
- Must be unique across the system
- Case-insensitive comparison

#### 5.1.2 Password Security
- Minimum 8 characters
- Must contain: uppercase, lowercase, and numeric characters
- Stored as BCrypt hash with cost factor 12
- Security stamp updated on password change

#### 5.1.3 Token Security
- Cryptographically secure random generation
- SHA-256 hashing before storage
- Time-based expiration enforcement
- One-time use for reset tokens

### 5.2 Audit Trail

All entities include audit fields following ABP Framework conventions:
- **CreationTime**: When the record was created
- **CreatorId**: Who created the record
- **LastModificationTime**: When last modified
- **LastModifierId**: Who last modified
- **IsDeleted**: Soft delete flag
- **DeletionTime**: When deleted
- **DeleterId**: Who deleted

### 5.3 Multi-Tenancy Support

The system supports multi-tenancy through:
- **TenantId**: Tenant isolation identifier
- **Tenant-aware queries**: Automatic filtering by tenant
- **Cross-tenant security**: Prevention of data leakage

---

## 6. Performance Considerations

### 6.1 Query Optimization

#### 6.1.1 Most Frequent Queries
1. **User Login**: `SELECT * FROM AbpUsers WHERE Email = @email AND IsDeleted = 0`
2. **Session Validation**: `SELECT * FROM Sessions WHERE TokenHash = @tokenHash AND IsActive = 1`
3. **Password Reset**: `SELECT * FROM PasswordResetTokens WHERE TokenHash = @tokenHash AND IsUsed = 0`

#### 6.1.2 Caching Strategy
- **User Profile**: Redis cache with 1-hour TTL
- **Active Sessions**: Redis cache with session expiration TTL
- **Failed Login Attempts**: Redis cache with 15-minute TTL

### 6.2 Scalability Measures

#### 6.2.1 Database Partitioning
- **LoginAttempts**: Partition by date (monthly)
- **Sessions**: Partition by creation date
- **PasswordResetTokens**: Automatic cleanup of expired tokens

#### 6.2.2 Connection Pooling
- Entity Framework Core connection pooling
- Maximum pool size: 100 connections
- Connection timeout: 30 seconds

---

## 7. Data Migration and Maintenance

### 7.1 Initial Data Setup

```sql
-- Default admin user (created during migration)
INSERT INTO AbpUsers (Id, UserName, Email, EmailConfirmed, PasswordHash, SecurityStamp, CreationTime)
VALUES (NEWID(), 'admin', 'admin@abpapp.com', 1, '[BCrypt_Hash]', NEWID(), GETUTCDATE());
```

### 7.2 Maintenance Procedures

#### 7.2.1 Cleanup Jobs
```sql
-- Clean expired sessions (daily)
DELETE FROM Sessions WHERE ExpiresAt < GETUTCDATE() AND IsActive = 0;

-- Clean expired reset tokens (daily)
DELETE FROM PasswordResetTokens WHERE ExpiresAt < GETUTCDATE() OR IsUsed = 1;

-- Archive old login attempts (weekly)
DELETE FROM LoginAttempts WHERE AttemptedAt < DATEADD(DAY, -90, GETUTCDATE());
```

#### 7.2.2 Health Checks
- Monitor failed login attempt rates
- Track session creation/expiration ratios
- Alert on unusual password reset patterns

---

## 8. Integration Points

### 8.1 ABP Framework Integration

The ERD integrates with ABP Framework modules:
- **Identity Module**: Extends AbpUsers entity
- **Permission Management**: User-role associations
- **Audit Logging**: Automatic audit trail
- **Multi-Tenancy**: Tenant isolation support

### 8.2 External Dependencies

#### 8.2.1 Email Service Integration
- **SendGrid**: Password reset email delivery
- **Templates**: Branded email templates
- **Tracking**: Delivery and open rates

#### 8.2.2 Caching Integration
- **Redis**: Session and user data caching
- **Distributed Cache**: Multi-instance support
- **Cache Invalidation**: Coordinated cache updates

---

## 9. Security Compliance

### 9.1 Data Protection

#### 9.1.1 GDPR Compliance
- **Right to be Forgotten**: Soft delete with anonymization
- **Data Portability**: User data export capabilities
- **Consent Management**: Email confirmation tracking

#### 9.1.2 Security Standards
- **OWASP**: Follows OWASP authentication guidelines
- **NIST**: Password policy compliance
- **ISO 27001**: Security management alignment

### 9.2 Encryption and Hashing

#### 9.2.1 Data at Rest
- **Database**: TDE (Transparent Data Encryption)
- **Backups**: Encrypted backup files
- **Logs**: Sensitive data redaction

#### 9.2.2 Data in Transit
- **HTTPS**: TLS 1.2+ for all communications
- **API Security**: JWT token-based authentication
- **Certificate Management**: Automated certificate renewal

---

## 10. Conclusion

This Entity Relationship Diagram provides a comprehensive data model for the Authentication feature, supporting:

### 10.1 Key Features Supported
- ✅ User registration with email verification
- ✅ Secure login with password validation
- ✅ Password reset via email tokens
- ✅ Session management and logout
- ✅ Account lockout protection
- ✅ Security monitoring and audit trails

### 10.2 Non-Functional Requirements Met
- **Security**: BCrypt password hashing, secure token generation
- **Performance**: Optimized indexes for sub-800ms response times
- **Scalability**: Support for 1,000+ concurrent users
- **Reliability**: 99.9% uptime through proper data design
- **Maintainability**: Clean, normalized database structure

### 10.3 Future Extensibility
The ERD is designed to support future enhancements:
- Two-factor authentication (2FA)
- Social media login integration
- Advanced user profile management
- Role-based access control (RBAC)
- Single sign-on (SSO) capabilities

This data model serves as the foundation for implementing a robust, secure, and scalable authentication system that meets all current requirements while providing flexibility for future growth.

---

**Document Status**: ✅ Ready for Implementation  
**Next Steps**: Database schema creation and Entity Framework Core model configuration