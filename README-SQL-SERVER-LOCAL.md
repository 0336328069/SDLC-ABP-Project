# ABP Enterprise Application - SQL Server Local Setup

## Yêu cầu hệ thống

### 1. Cài đặt các công cụ cần thiết

**A. .NET 9 SDK**
```bash
# Tải và cài đặt từ: https://dotnet.microsoft.com/download/dotnet/9.0
dotnet --version  # Kiểm tra phiên bản (phải >= 9.0)
```

**B. SQL Server LocalDB (Đã có sẵn trong Visual Studio 2022)**
```bash
# Kiểm tra LocalDB đã cài đặt chưa
sqllocaldb info

# Nếu chưa có, tải SQL Server Express LocalDB:
# https://www.microsoft.com/en-us/sql-server/sql-server-downloads
```

**C. Node.js (cho frontend)**
```bash
# Tải và cài đặt từ: https://nodejs.org (LTS version)
node --version  # Kiểm tra phiên bản
npm --version
```

### 2. Tools khuyến nghị (tùy chọn)

- **SQL Server Management Studio (SSMS)**: Quản lý database trực quan
- **Azure Data Studio**: Tool cross-platform để làm việc với SQL Server
- **Visual Studio 2022** hoặc **VS Code**: IDE phát triển

## Cấu hình và Chạy ứng dụng

### Bước 1: Clone và Setup Backend

```bash
# Di chuyển vào thư mục backend
cd src/backend

# Restore NuGet packages
dotnet restore

# Build solution
dotnet build
```

### Bước 2: Tạo và Migrate Database

```bash
# Di chuyển vào thư mục DbMigrator
cd tools/AbpApp.DbMigrator

# Chạy migrations (tạo database và seed data)
dotnet run

# Kết quả thành công sẽ hiển thị:
# "Successfully completed all database migrations."
# "You can safely end this process..."
```

**Connection String được sử dụng:**
```
Server=(localdb)\MSSQLLocalDB;Database=AbpApp;Trusted_Connection=true;TrustServerCertificate=true
```

### Bước 3: Chạy Backend API

```bash
# Di chuyển vào thư mục HttpApi.Host
cd src/backend/src/AbpApp.HttpApi.Host

# Chạy API server
dotnet run

# Server sẽ chạy tại:
# - HTTPS: https://localhost:44300
# - Swagger UI: https://localhost:44300/swagger
```

### Bước 4: Setup và Chạy Frontend

```bash
# Di chuyển vào thư mục frontend
cd src/frontend

# Cài đặt dependencies
npm install

# Chạy development server
npm run dev

# Frontend sẽ chạy tại: http://localhost:3000
```

## Thông tin đăng nhập mặc định

- **Username**: `admin`
- **Password**: `1q2w3E*`

## Kiểm tra Database

### Sử dụng SSMS

1. Mở SQL Server Management Studio
2. Connect với thông tin:
   - **Server name**: `(localdb)\MSSQLLocalDB`
   - **Authentication**: Windows Authentication
3. Database `AbpApp` sẽ xuất hiện trong danh sách

### Sử dụng Command Line

```bash
# Kết nối với LocalDB
sqlcmd -S "(localdb)\MSSQLLocalDB" -E

# Liệt kê databases
SELECT name FROM sys.databases;
GO

# Sử dụng AbpApp database
USE AbpApp;
GO

# Kiểm tra các bảng
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
GO
```

## Các URL quan trọng

- **Frontend**: http://localhost:3000
- **Backend API**: https://localhost:44300
- **Swagger Documentation**: https://localhost:44300/swagger
- **Health Check**: https://localhost:44300/health

## Troubleshooting

### Lỗi thường gặp

**1. Lỗi kết nối LocalDB**
```bash
# Khởi động LocalDB instance
sqllocaldb start MSSQLLocalDB

# Kiểm tra trạng thái
sqllocaldb info MSSQLLocalDB
```

**2. Port đã được sử dụng**
```json
// Thay đổi port trong appsettings.json
{
  "App": {
    "SelfUrl": "https://localhost:45000"  // Đổi port khác
  }
}
```

**3. Trust development certificate**
```bash
dotnet dev-certs https --trust
```

**4. Clean và Rebuild**
```bash
# Clean solution
dotnet clean
dotnet restore
dotnet build
```

### Reset Database

```bash
# Xóa database và tạo lại
cd tools/AbpApp.DbMigrator
dotnet run
```

## Cấu trúc Database

Sau khi migration, database sẽ có các bảng chính:

- **AbpUsers**: Quản lý người dùng
- **AbpRoles**: Quản lý vai trò
- **AbpTenants**: Quản lý tenant (multi-tenancy)
- **AbpPermissions**: Quản lý quyền hạn
- **Products**: Bảng sản phẩm (custom entity)
- **Categories**: Bảng danh mục (custom entity)

## Phát triển tiếp

### Thêm Entity mới

1. Tạo entity trong `src/backend/src/AbpApp.Domain/Entities/`
2. Thêm DbSet vào `AbpAppDbContext.cs`
3. Tạo migration: `dotnet ef migrations add AddNewEntity`
4. Chạy migration: `dotnet run` trong DbMigrator

### Thêm API mới

1. Tạo Application Service trong `src/backend/src/AbpApp.Application/`
2. Tạo Controller trong `src/backend/src/AbpApp.HttpApi/`
3. Thêm Permission trong `AbpAppPermissions.cs`

## Liên hệ hỗ trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra logs trong thư mục `Logs/`
2. Xem Swagger documentation tại `/swagger`
3. Kiểm tra console output khi chạy ứng dụng