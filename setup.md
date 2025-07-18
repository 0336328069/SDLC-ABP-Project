# ABP Enterprise Application - Setup Guide

## 🚀 Hướng dẫn Setup

### Yêu cầu hệ thống

#### Backend Requirements
- **.NET 8 SDK** - [Download](https://dotnet.microsoft.com/download/dotnet/8.0)
- **PostgreSQL 15+** - [Download](https://www.postgresql.org/download/) (Khuyến nghị cho Docker setup)
- **SQL Server** (Nếu bạn muốn chạy local không dùng Docker, xem `README-SQL-SERVER-LOCAL.md`)
- **Redis 7+** - [Download](https://redis.io/download)
- **Docker & Docker Compose** - [Download](https://docs.docker.com/get-docker/)

#### Frontend Requirements
- **Node.js 20+** - [Download](https://nodejs.org/)
- **npm 10+** (đi kèm với Node.js)

#### Development Tools (Tùy chọn)
- **Visual Studio 2022** hoặc **Visual Studio Code**
- **SQL Server Management Studio** hoặc **pgAdmin**
- **Redis Commander** hoặc **RedisInsight**

---

## 📋 Các bước setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd abp-enterprise-app
```

### 2. Setup Backend (.NET)

#### 2.1. Cài đặt dependencies

```bash
cd src/backend
dotnet restore
```

#### 2.2. Cấu hình Database

**Cách 1: Sử dụng Docker (Khuyến nghị)**

```bash
# Từ thư mục root
docker-compose up -d postgres redis rabbitmq
```

**Cách 2: Cài đặt thủ công**

1. Cài đặt PostgreSQL và tạo database:
```sql
CREATE DATABASE abpapp;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE abpapp TO postgres;
```

2. Cài đặt Redis theo hướng dẫn trên trang chủ

#### 2.3. Cập nhật Connection String

Chỉnh sửa file `src/backend/src/AbpApp.HttpApi.Host/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "Default": "Server=localhost;Database=abpapp;User Id=postgres;Password=postgres;"
  },
  "Redis": {
    "Configuration": "localhost:6379"
  }
}
```

#### 2.4. Chạy Migration

```bash
# Lệnh này được chạy từ thư mục src/backend
dotnet ef database update --project src/AbpApp.EntityFrameworkCore
```

#### 2.5. Seed dữ liệu mẫu

```bash
# Quay lại thư mục gốc của dự án
cd ../.. 
# Chạy DbMigrator từ thư mục gốc
dotnet run --project tools/AbpApp.DbMigrator
```

#### 2.6. Chạy Backend API

```bash
dotnet run --project src/AbpApp.HttpApi.Host
```

Backend sẽ chạy tại: `https://localhost:44300`

### 3. Setup Frontend (Next.js)

#### 3.1. Cài đặt dependencies

```bash
cd src/frontend
npm install
```

#### 3.2. Cấu hình Environment Variables

Copy file environment:
```bash
# Đối với Linux/macOS
cp .env.example .env.local

# Đối với Windows (Command Prompt)
copy .env.example .env.local
```

Chỉnh sửa `.env.local`:
```env
NEXT_PUBLIC_API_URL=http://localhost:44300
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

#### 3.3. Chạy Frontend

```bash
npm run dev
```

Frontend sẽ chạy tại: `http://localhost:3000`

---

## 🐳 Setup với Docker (All-in-one)

### 1. Setup tất cả services

```bash
# Build và chạy tất cả services
docker-compose up -d

# Xem logs
docker-compose logs -f
```

### 2. Seed dữ liệu

```bash
# Chạy database migrator
docker-compose exec backend dotnet run --project tools/AbpApp.DbMigrator
```

### 3. Truy cập ứng dụng

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:44300
- **Swagger UI**: http://localhost:44300/swagger
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **RabbitMQ Management**: http://localhost:15672 (admin/admin123)
- **Seq Logs**: http://localhost:5341
