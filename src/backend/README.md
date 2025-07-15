# ABP Framework Backend

Đây là backend của ứng dụng ABP Framework được phát triển với .NET 9.0 và Entity Framework Core.

## Cấu trúc dự án

### Kiến trúc theo Domain-Driven Design (DDD)

Dự án được tổ chức theo kiến trúc DDD với các layer:

#### 1. Domain.Shared Layer (`AbpApp.Domain.Shared`)
- **Chức năng**: Chứa các shared constants, enums, và resources
- **Thành phần chính**:
  - `AbpAppDomainErrorCodes`: Định nghĩa error codes
  - `AbpAppConsts`: Application constants
  - Localization resources (tiếng Anh & tiếng Việt)
  - Global feature và module extension configurators

#### 2. Domain Layer (`AbpApp.Domain`)
- **Chức năng**: Chứa business logic core và domain entities
- **Thành phần chính**:
  - Domain modules configuration
  - Multi-tenancy support
  - Background jobs configuration
  - Event bus integration

#### 3. Application.Contracts Layer (`AbpApp.Application.Contracts`)
- **Chức năng**: Định nghĩa application service interfaces và DTOs
- **Thành phần chính**:
  - Permission definitions
  - Application service contracts
  - DTO extensions

#### 4. Application Layer (`AbpApp.Application`)
- **Chức năng**: Implement business logic và application services
- **Thành phần chính**:
  - AutoMapper profiles
  - Application services implementation
  - Business logic layer

#### 5. EntityFrameworkCore Layer (`AbpApp.EntityFrameworkCore`)
- **Chức năng**: Data access layer với EF Core
- **Thành phần chính**:
  - `AbpAppDbContext`: Database context
  - Entity configurations
  - Migration services
  - Repository implementations

#### 6. HttpApi Layer (`AbpApp.HttpApi`)
- **Chức năng**: Web API controllers
- **Thành phần chính**:
  - REST API controllers
  - HTTP API configuration
  - Conventional controllers

#### 7. HttpApi.Client Layer (`AbpApp.HttpApi.Client`)
- **Chức năng**: HTTP client proxies cho remote service calls
- **Thành phần chính**:
  - HTTP client proxies
  - Remote service configurations

#### 8. HttpApi.Host Layer (`AbpApp.HttpApi.Host`)
- **Chức năng**: Web API host application
- **Thành phần chính**:
  - Startup configuration
  - CORS settings
  - Swagger/OpenAPI documentation
  - Authentication & authorization
  - Middleware pipeline

## Tools

### DbMigrator (`tools/AbpApp.DbMigrator`)
- **Chức năng**: Console application cho database migration và data seeding
- **Tính năng**:
  - Database schema migration
  - Initial data seeding
  - Multi-tenant database support

## Công nghệ sử dụng

### Core Technologies
- **.NET 9.0**: Framework chính
- **ABP Framework 8.3.0**: Application framework
- **Entity Framework Core 9.0**: ORM
- **SQL Server**: Database engine
- **AutoMapper**: Object mapping

### Logging & Monitoring
- **Serilog**: Structured logging
- **Console & File sinks**: Log outputs

### Caching & Messaging
- **Redis**: Distributed caching
- **RabbitMQ**: Message broker

### Authentication & Authorization
- **IdentityServer**: Authentication server
- **JWT Bearer**: Token-based authentication
- **ABP Permission System**: Authorization

### API Documentation
- **Swagger/OpenAPI**: API documentation
- **Swashbuckle**: Swagger integration

## Cấu hình

### Database
- **Connection String**: SQL Server LocalDB
- **Multi-tenancy**: Enabled
- **Migrations**: Entity Framework Core Code-First

### Development Settings
```json
{
  "App": {
    "SelfUrl": "https://localhost:44300",
    "ClientUrl": "http://localhost:3000",
    "CorsOrigins": "https://localhost:44300,http://localhost:3000"
  }
}
```

### Localization
- **Supported Languages**: English (en), Vietnamese (vi)
- **Resource Files**: JSON-based localization
- **Default Language**: English

## Khởi chạy ứng dụng

1. **Cài đặt dependencies**: 
   ```bash
   dotnet restore
   ```

2. **Database migration**:
   ```bash
   cd tools/AbpApp.DbMigrator
   dotnet run
   ```

3. **Chạy API Host**:
   ```bash
   cd src/AbpApp.HttpApi.Host
   dotnet run
   ```

4. **Truy cập Swagger**: https://localhost:44300/swagger

## Features

### Built-in Modules
- **Identity Management**: User, role management
- **Tenant Management**: Multi-tenant support
- **Permission Management**: Fine-grained permissions
- **Setting Management**: Application settings
- **Background Jobs**: Async job processing

### Security Features
- CORS configuration
- Authentication middleware
- Authorization policies
- Multi-tenancy isolation

### Development Features
- Hot reload support
- Structured logging
- API documentation
- Exception handling
- Request localization