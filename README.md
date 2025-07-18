# ABP Enterprise Application with Next.js

Đây là ứng dụng doanh nghiệp mạnh mẽ, sẵn sàng cho sản xuất, xây dựng trên nền tảng ABP Framework (.NET 9.0, ABP 8.3.0) và Next.js 14+, hướng đến khả năng mở rộng và bảo trì lâu dài.

## 📚 Tài liệu dự án

- **[AI/LLM Guide (`llms.txt`)](./llms.txt)**: Chuẩn llmstxt.org cho AI assistant hiểu kiến trúc, quy ước code, workflow.
- **[Setup Guide (`setup.md`)](./setup.md)**: Hướng dẫn chi tiết cài đặt môi trường phát triển.

## 🚀 Tech Stack

### Backend
- **Framework:** .NET 9.0 & ABP Framework 8.3.0
- **Kiến trúc:** Domain-Driven Design (DDD), Clean Architecture, Modular Monolith
- **API:** ASP.NET Core RESTful API, OpenAPI (Swagger)
- **ORM:** Entity Framework Core 9.0
- **Database:** SQL Server (mặc định, có thể cấu hình PostgreSQL)
- **Caching:** Redis
- **Message Broker:** RabbitMQ
- **Logging:** Serilog (ghi log ra file & console)
- **Authentication:** IdentityServer, JWT Bearer, ABP Permission System
- **Localization:** Hỗ trợ tiếng Anh & tiếng Việt (JSON resource)

### Frontend
- **Framework:** Next.js 14+ (App Router)
- **Ngôn ngữ:** TypeScript, React 18+
- **UI:** Tailwind CSS, Radix UI, Lucide Icons
- **State Management:** TanStack Query (React Query), Zustand
- **Forms:** React Hook Form + Zod
- **Authentication:** NextAuth.js
- **Component Library:** Storybook
- **Testing:** Jest, React Testing Library

### DevOps & Tooling
- **Containerization:** Docker, Docker Compose
- **Web Server/Proxy:** Nginx (qua Docker)
- **Linting & Formatting:** ESLint, Prettier
- **Setup Automation:** Bash script (`scripts/setup.sh`)
- **Pre-commit:** Husky, lint-staged (tự động format/lint code trước khi commit)

## 🏗️ Cấu trúc thư mục

```
.
├── docker-compose.yml         # Định nghĩa các service cho local dev
├── package.json               # Root package file
├── README.md                  # File này
├── scripts/
│   └── setup.sh               # Script setup tự động
├── src/
│   ├── backend/               # .NET ABP Framework solution
│   │   ├── AbpApp.sln
│   │   └── src/
│   │       ├── AbpApp.Application
│   │       ├── AbpApp.Domain
│   │       ├── AbpApp.EntityFrameworkCore
│   │       └── AbpApp.HttpApi.Host  # Startup project cho API
│   └── frontend/              # Next.js application
│       ├── app/                 # App Router directory
│       ├── components/          # Shared React components
│       ├── lib/                 # Utility functions
│       └── package.json
└── tools/
    └── AbpApp.DbMigrator/       # Tool migrate & seed database
```

## 🚦 Khởi động nhanh

Bạn có thể chạy dự án bằng Docker (khuyến nghị) hoặc setup thủ công.

### 1. Docker Setup (Khuyến nghị)

**Yêu cầu:**
- Docker & Docker Compose

**Các bước:**
1. Clone repository.
2. Chạy lệnh:
    ```bash
    docker-compose up -d
    ```
3. Truy cập các endpoint:
    - **Frontend**: `http://localhost:3000`
    - **Backend API**: `http://localhost:44300`
    - **Swagger UI**: `http://localhost:44300/swagger`
    - **Seq (Logging)**: `http://localhost:5341`
    - **RabbitMQ Management**: `http://localhost:15672` (user: `admin`, pass: `admin123`)

### 2. Setup tự động local (Linux/macOS)

**Yêu cầu:**
- .NET 9 SDK
- Node.js 20+
- Docker & Docker Compose (cho database, Redis, RabbitMQ)

**Các bước:**
1. Clone repository.
2. Chạy script:
    ```bash
    ./scripts/setup.sh
    ```
    Script sẽ:
    - Kiểm tra dependencies
    - Tạo file env
    - Cài backend & frontend dependencies
    - Khởi động hạ tầng (SQL Server/PostgreSQL, Redis, RabbitMQ)
    - Migrate & seed database
    - Build project
    - Start dev server

### 3. Setup thủ công

Xem chi tiết trong **[Setup Guide (`setup.md`)](./setup.md)** (hỗ trợ cả SQL Server & PostgreSQL).

## 🌐 Localization
- Hỗ trợ tiếng Việt và tiếng Anh (JSON resource)
- Có thể mở rộng thêm ngôn ngữ khác dễ dàng

## 🛡️ Bảo mật & xác thực
- Backend sử dụng IdentityServer, JWT Bearer, ABP Permission System
- Frontend sử dụng NextAuth.js, lưu token an toàn, tích hợp RBAC

## 🧪 Testing
- **Frontend:** Jest, React Testing Library, Storybook
- **Backend:** dotnet test (các project test riêng)

## 🛠️ Tooling
- **Husky/lint-staged:** Tự động lint/format code trước khi commit (JS/TS, C#)
- **ESLint/Prettier:** Chuẩn hóa code frontend
- **dotnet format:** Chuẩn hóa code backend

## 📄 License

Dự án sử dụng giấy phép MIT.
