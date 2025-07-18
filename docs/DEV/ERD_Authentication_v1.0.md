# Entity Relationship Diagram: Authentication v1.0

## 1. Database Schema

### 1.1. Core Tables (ABP Identity)

**AbpUsers**
```sql
CREATE TABLE AbpUsers (
    Id uniqueidentifier PRIMARY KEY,
    UserName nvarchar(256) NOT NULL,
    Email nvarchar(256) NOT NULL,
    EmailConfirmed bit NOT NULL DEFAULT 0,
    PasswordHash nvarchar(max) NULL,
    SecurityStamp nvarchar(max) NULL,
    PhoneNumber nvarchar(max) NULL,
    PhoneNumberConfirmed bit NOT NULL DEFAULT 0,
    TwoFactorEnabled bit NOT NULL DEFAULT 0,
    LockoutEnd datetimeoffset(7) NULL,
    LockoutEnabled bit NOT NULL DEFAULT 1,
    AccessFailedCount int NOT NULL DEFAULT 0,
    CreationTime datetime2(7) NOT NULL,
    CreatorId uniqueidentifier NULL,
    LastModificationTime datetime2(7) NULL,
    LastModifierId uniqueidentifier NULL,
    IsDeleted bit NOT NULL DEFAULT 0,
    DeleterId uniqueidentifier NULL,
    DeletionTime datetime2(7) NULL
);
```

**AbpUserTokens**
```sql
CREATE TABLE AbpUserTokens (
    UserId uniqueidentifier NOT NULL,
    LoginProvider nvarchar(64) NOT NULL,
    Name nvarchar(128) NOT NULL,
    Value nvarchar(max) NULL,
    CONSTRAINT PK_AbpUserTokens PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_AbpUserTokens_AbpUsers_UserId FOREIGN KEY (UserId) REFERENCES AbpUsers(Id) ON DELETE CASCADE
);
```

## 2. Entity Relationships

### 2.1. ERD Diagram
```
┌─────────────────┐     ┌─────────────────┐
│    AbpUsers     │     │ AbpUserTokens   │
├─────────────────┤     ├─────────────────┤
│ Id (PK)         │○────▶│ UserId (FK)    │
│ UserName        │     │ LoginProvider   │
│ Email           │     │ Name            │
│ PasswordHash    │     │ Value           │
│ LockoutEnd      │     │                 │
│ AccessFailedCount│    │                 │
└─────────────────┘     └─────────────────┘
```

### 2.2. Key Relationships
- **One-to-Many**: User → UserTokens
- **Foreign Key**: UserTokens.UserId → Users.Id

## 3. Indexes and Constraints

### 3.1. Required Indexes
```sql
CREATE UNIQUE INDEX IX_AbpUsers_Email ON AbpUsers(Email);
CREATE INDEX IX_AbpUsers_LockoutEnd ON AbpUsers(LockoutEnd);
CREATE INDEX IX_AbpUserTokens_UserId ON AbpUserTokens(UserId);
```

### 3.2. Business Rules
- Email must be unique across all users
- PasswordHash must never be null for active users
- LockoutEnd indicates account lockout expiration
- AccessFailedCount tracks consecutive failed login attempts