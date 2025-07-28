# Entity Relationship Diagram (ERD) and Data Model: Authentication

### 1. Executive Summary
- **Project Name**: Authentication Service for ABP Enterprise Application
- **Database Overview**: This document outlines the database schema for the Authentication feature. The database is designed to securely manage user accounts, support core authentication mechanisms (login, registration), and handle password recovery processes. Its primary business value lies in securing user data, enabling user retention, and providing a trustworthy platform foundation.
- **Database Technology**: **SQL Server 2019+** (as per technical specifications).
- **Total Entities**: 2 (1 core ABP entity, 1 custom entity).
- **Key Relationships**: A one-to-many relationship exists between the User Account and the Password Reset Token.
- **Data Integrity Strategy**: Data integrity is maintained through primary keys, unique constraints (e.g., on user email), foreign key relationships with cascading rules, and application-level validation based on business rules.
- **Performance Considerations**: The design incorporates indexing on frequently queried columns (e.g., email, token) and leverages the performance features of the ABP Framework and Entity Framework Core.
- **Security Implementation**: Security is enforced by hashing all sensitive data (passwords, tokens) using Bcrypt, implementing role-based access control (RBAC) via the ABP Identity module, and ensuring all data in transit is encrypted via HTTPS.
- **Migration Strategy**: Database schema changes will be managed and deployed using **Entity Framework Core Migrations**.

**Document Information**:
- **Version**: 1.0
- **Date**: 2025-07-28
- **Prepared By**: Database Architecture Team
- **Reviewed By**: Technical Lead, Business Analyst
- **Approved By**: Project Manager, Lead Database Administrator

### 2. Domain Model Analysis
- **2.1 Domain Entities Analysis**:
  - **Core Domain Entities**:
    - **User Account**: Represents a user's digital identity within the system. It is the central entity for authentication and authorization, storing credentials and status information. This will be implemented using the existing `AbpUser` entity from the ABP Framework's Identity module to ensure consistency and leverage built-in features.
    - **Password Reset Token**: A temporary, single-use token generated to allow a user to securely reset their password without being logged in.
  - **Entity Categories**:
    - **Master Data**: `User Account`.
    - **Transaction Data**: `Password Reset Token`.
    - **Reference Data**: TBD: No specific reference data identified.
    - **Audit Data**: ABP Framework provides built-in audit properties (`CreationTime`, `CreatorId`, `LastModificationTime`, `LastModifierId`, `DeleterId`, `DeletionTime`, `IsDeleted`) for entities.

- **2.2 Domain Relationships Analysis**:
  - **Primary Relationships**:
    - **User Account to Password Reset Token**: A `User Account` can have multiple `Password Reset Tokens` over its lifetime, but each `Password Reset Token` is associated with exactly one `User Account`.
      - **Cardinality**: One-to-Many (1:N).
      - **Business Rules**: When a user requests a password reset, a new token is generated and linked to their account. The token becomes invalid after use or expiration.
  - **Relationship Categories**:
    - **Association**: The relationship between `User Account` and `Password Reset Token` is a direct association.

- **2.3 Domain Rules and Constraints**:
  - **Entity Rules**:
    - **User Account**:
      - `Email`: Mandatory, must be unique across the system, and must be a valid email format.
      - `Password`: Mandatory, must be hashed using Bcrypt, and must meet complexity requirements (≥8 chars, 1 uppercase, 1 lowercase, 1 number).
      - `Account Status`: Can be `Active`, `Locked`, or `Inactive`. A user's account is locked for 15 minutes after 5 consecutive failed login attempts.
  - **Relationship Rules**:
    - **Referential Integrity**: The `UserId` in the `PasswordResetTokens` table must correspond to a valid `Id` in the `AbpUsers` table.
    - **Cascade Rules**: Deleting a `User Account` should cascade to delete all associated `Password Reset Tokens`.

### 3. Technical Architecture Analysis
- **3.1 System Architecture Assessment**: The system uses a modular monolith architecture based on the ABP Framework. The database technology is SQL Server. The Authentication domain will integrate seamlessly with the ABP Identity module.
- **3.2 Performance and Scalability Analysis**:
  - **Data Volume**: User base is expected to grow to 500 new accounts/week. The `PasswordResetTokens` table will have transient data, which should be periodically cleaned up.
  - **Transaction Volume**: The system must handle 1,000 concurrent authentication requests/sec with server response times under 800ms.
  - **Performance Targets**: Indexing on key lookup fields (`Email`, `NormalizedEmail`, `ResetTokenHash`) is critical to meet performance targets.
- **3.3 Security and Compliance Analysis**:
  - **Authentication**: Handled by ABP Identity using JWT Bearer tokens.
  - **Authorization**: Managed by the ABP Permission System.
  - **Encryption**: Passwords and reset tokens must be hashed using **Bcrypt**. Data in transit must be encrypted using **HTTPS (TLS 1.2+)**.
  - **Audit Logging**: ABP's built-in auditing features will be enabled for all entities to track data changes.

### 4. Entity Relationship Diagram
- **4.1 ERD Overview**:
  - **Database Design Pattern**: The design leverages the existing identity management schema provided by the ABP Framework (`AbpUser`) and extends it with a custom table for password reset tokens to meet specific business requirements.
  - **Normalization Level**: 3NF.
  - **Total Entities**: 2.
  - **Total Relationships**: 1.
  - **Design Principles**: Adherence to ABP Framework conventions, security-first (hashing sensitive data), and performance-oriented indexing.

- **4.2 ERD Diagram**:
  - **Mermaid ERD Diagram**:
    ```mermaid
    erDiagram
        AbpUsers {
            uniqueidentifier Id PK
            string UserName
            string NormalizedUserName
            string Email
            string NormalizedEmail
            string PasswordHash
            string SecurityStamp
            boolean LockoutEnabled
            datetimeoffset LockoutEnd
            int AccessFailedCount
            string ConcurrencyStamp
            boolean IsDeleted
        }

        PasswordResetTokens {
            uniqueidentifier Id PK
            uniqueidentifier UserId FK
            string ResetTokenHash
            datetime2 ExpirationTimeUtc
            boolean IsUsed
            datetime2 CreationTime
        }

        AbpUsers ||--o{ PasswordResetTokens : "has"
    ```
  - **ERD Diagram Notes**:
    - The `AbpUsers` entity represents the core user account and is a standard entity provided by the ABP Framework. Only relevant attributes for this feature are shown.
    - `PK`: Primary Key
    - `FK`: Foreign Key

- **4.3 Entity Definitions**:
  - **Entity: `AbpUsers`** (Leveraging existing ABP Identity User)
    - **Purpose**: To store user identity, credentials, and security-related information.
    - **Business Rules**: Governed by ABP Identity module rules and extended by requirements like account lockout.
    - **Attributes**:
      | Column Name          | Data Type        | Constraints                               | Description                                                                 |
      |----------------------|------------------|-------------------------------------------|-----------------------------------------------------------------------------|
      | `Id`                 | `uniqueidentifier` | PK, Not Null                              | Unique identifier for the user.                                             |
      | `UserName`           | `nvarchar(256)`  | Not Null                                  | User's chosen username.                                                     |
      | `NormalizedUserName` | `nvarchar(256)`  | Not Null, Indexed                         | Uppercased version of the username for case-insensitive lookups.            |
      | `Email`              | `nvarchar(256)`  | Not Null                                  | User's email address.                                                       |
      | `NormalizedEmail`    | `nvarchar(256)`  | Not Null, Indexed, Unique                 | Uppercased version of the email for case-insensitive unique lookups.        |
      | `PasswordHash`       | `nvarchar(max)`  | Nullable                                  | Hashed version of the user's password using Bcrypt.                         |
      | `SecurityStamp`      | `nvarchar(max)`  | Nullable                                  | A random value that changes when user credentials change.                   |
      | `LockoutEnd`         | `datetimeoffset(7)`| Nullable                                  | The date and time until the user is locked out.                             |
      | `LockoutEnabled`     | `bit`            | Not Null                                  | Flag indicating if this user can be locked out.                             |
      | `AccessFailedCount`  | `int`            | Not Null                                  | Number of consecutive failed login attempts.                                |
    - **Indexes**:
      - `IX_AbpUsers_NormalizedUserName`: Non-clustered index on `NormalizedUserName`.
      - `IX_AbpUsers_NormalizedEmail`: Unique, non-clustered index on `NormalizedEmail`.
    - **Relationships**:
      - One-to-Many with `PasswordResetTokens`.

  - **Entity: `PasswordResetTokens`** (Custom Entity)
    - **Purpose**: To securely store single-use tokens for the password reset process.
    - **Business Rules**: A token is generated upon user request, is valid for 60 minutes, and can only be used once.
    - **Attributes**:
      | Column Name         | Data Type        | Constraints  | Description                                                 |
      |---------------------|------------------|--------------|-------------------------------------------------------------|
      | `Id`                | `uniqueidentifier` | PK, Not Null | Unique identifier for the token record.                     |
      | `UserId`            | `uniqueidentifier` | FK, Not Null | Foreign key referencing the `AbpUsers(Id)` table.           |
      | `ResetTokenHash`    | `nvarchar(max)`  | Not Null     | Hashed version of the password reset token.                 |
      | `ExpirationTimeUtc` | `datetime2`      | Not Null     | The UTC date and time when the token expires (60 mins).     |
      | `IsUsed`            | `bit`            | Not Null     | Flag indicating if the token has already been used.         |
      | `CreationTime`      | `datetime2`      | Not Null     | The UTC date and time when the token was created.           |
    - **Indexes**:
      - `IX_PasswordResetTokens_UserId`: Non-clustered index on `UserId` to speed up lookups for a user's tokens.
    - **Relationships**:
      - Many-to-One with `AbpUsers`.

### 5. Performance Optimization
- **5.1 Indexing Strategy**:
  - **Primary Indexes**: Primary keys on all tables (`Id`) will use a clustered index by default in SQL Server.
  - **Secondary Indexes**:
    | Entity       | Index Name                        | Type          | Columns             | Purpose                               | Query Pattern                               |
    |--------------|-----------------------------------|---------------|---------------------|---------------------------------------|---------------------------------------------|
    | `AbpUsers`   | `IX_AbpUsers_NormalizedEmail`     | Unique        | `NormalizedEmail`   | Fast, case-insensitive email lookup.  | `WHERE NormalizedEmail = @email`            |
    | `AbpUsers`   | `IX_AbpUsers_NormalizedUserName`  | Non-Unique    | `NormalizedUserName`| Fast, case-insensitive username lookup. | `WHERE NormalizedUserName = @username`      |
    | `PasswordResetTokens` | `IX_PasswordResetTokens_UserId` | Non-Unique    | `UserId`            | Fast lookup of tokens for a user.     | `WHERE UserId = @userId`                    |

- **5.2 Query Optimization**:
  - **Strategy**: Queries will be implemented via Entity Framework Core, leveraging LINQ which translates to parameterized SQL, preventing SQL injection. Avoid raw SQL queries.
  - **Common Query Patterns**:
    | Operation          | Query Logic                                                              | Involved Tables         | Performance Notes                               |
    |--------------------|--------------------------------------------------------------------------|-------------------------|-------------------------------------------------|
    | User Login         | `SELECT * FROM AbpUsers WHERE NormalizedEmail = @email`                  | `AbpUsers`              | Fast due to index on `NormalizedEmail`.         |
    | Token Validation   | `SELECT * FROM PasswordResetTokens WHERE ResetTokenHash = @tokenHash`    | `PasswordResetTokens`   | Requires a full scan if not indexed. **TBD: Add index on `ResetTokenHash` if performance degrades.** |
    | User Registration  | `INSERT INTO AbpUsers ...`                                               | `AbpUsers`              | Standard insert performance.                    |

### 6. Security and Access Control
- **6.1 Database Security Model**:
  - **Authentication**: Application connects to SQL Server using a dedicated, least-privilege user account. Connection strings are managed securely via application settings.
  - **Authorization**: Database access is restricted to the application's service account. User-level permissions are managed by the ABP Permission System (RBAC) at the application layer, not at the database level.
- **6.2 User Roles and Permissions**:
  - **RBAC Strategy**: The ABP Identity module provides a comprehensive role-based access control system.
  - **Database Roles**:
    | Role Name | Description                               | Permissions Granted in DB                               |
    |-----------|-------------------------------------------|---------------------------------------------------------|
    | `AppUser` | The application's service account role.   | `SELECT`, `INSERT`, `UPDATE`, `DELETE` on application tables. |
    | `Admin`   | (Application Role) Full system access.    | N/A (Managed at application layer)                      |
    | `User`    | (Application Role) Standard user access.  | N/A (Managed at application layer)                      |

### 7. Implementation Strategy
- **7.1 Database Implementation Approach**:
  - **Methodology**: Code-First approach using Entity Framework Core.
  - **Environment**: Local development using SQL Server LocalDB, with production using a dedicated SQL Server instance.
  - **Version Control**: Schema changes (migrations) are stored as C# code in the `.EntityFrameworkCore` project and tracked in Git.
- **7.2 Data Migration Strategy**:
  - **Approach**: Use EF Core Migrations to apply schema changes. A dedicated migrator tool (`AbpApp.DbMigrator`) is provided in the solution to apply migrations and seed data.
  - **Validation**: Migrations will be tested in a staging environment before being applied to production.

### 8. Requirements Traceability
- **8.1 Domain Model Mapping**:
  | Domain Entity         | Database Entity(s)      | Key Attributes Mapped                               | Notes                                                                 |
  |-----------------------|-------------------------|-----------------------------------------------------|-----------------------------------------------------------------------|
  | `User Account`        | `AbpUsers`              | `Email`, `PasswordHash`, `LockoutEnd`               | Leverages the standard, feature-rich ABP Identity User entity.        |
  | `Password Reset Token`| `PasswordResetTokens`   | `ResetTokenHash`, `ExpirationTimeUtc`, `IsUsed`     | Custom entity to meet the specific requirement of storing token hashes. |

- **8.2 Business Rules Mapping**:
  | Domain Rule ID | Description                               | Database Constraint / Implementation                                                              | Validation                                                              |
  |----------------|-------------------------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
  | FR-REG-04      | Email must be unique.                     | `UNIQUE` index on `NormalizedEmail` column in `AbpUsers`.                                         | Database will throw an exception on duplicate insert.                   |
  | FR-REG-05      | Password complexity rules.                | Enforced at the application layer before saving to the database.                                  | Unit tests for the registration logic.                                  |
  | FR-LOG-06      | Lock account after 5 failed attempts.     | `AccessFailedCount` and `LockoutEnd` columns in `AbpUsers`, managed by ABP Identity.              | Integration test simulating multiple failed logins.                     |
  | FR-RP-06       | Store hashed reset token and expiry.      | `ResetTokenHash` and `ExpirationTimeUtc` columns in `PasswordResetTokens` table.                  | Verify record creation in the database during a password reset test.    |
  | NFR-SEC-01     | Hash passwords with Bcrypt.               | Implemented at the application layer via ABP's Identity Password Hasher configuration.            | Code review and verification of the password hasher implementation.     |
  | NFR-SEC-04     | Reset token expires in 60 minutes.        | `ExpirationTimeUtc` is set to `CreationTime + 60 minutes`. A background job **TBD** could clean up expired tokens. | Unit test to check token validation logic against the expiration time. |
