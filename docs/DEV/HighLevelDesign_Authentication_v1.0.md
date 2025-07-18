# High-Level Design: Authentication v1.0

## 1. Module Architecture

### 1.1. Backend Modules (ABP Framework)

```
AbpApp.HttpApi
├── Controllers/
│   └── AuthenticationController.cs
│       ├── POST /api/auth/register
│       ├── POST /api/auth/login
│       ├── POST /api/auth/forgot-password
│       ├── POST /api/auth/reset-password
│       └── POST /api/auth/logout

AbpApp.Application
├── Authentication/
│   ├── AuthenticationAppService.cs
│   ├── Dto/
│   │   ├── RegisterDto.cs
│   │   ├── LoginDto.cs
│   │   └── ResetPasswordDto.cs
│   └── Validators/
│       └── RegisterDtoValidator.cs

AbpApp.Domain
├── Users/
│   ├── User.cs (Entity)
│   └── UserManager.cs (Domain Service)
```

### 1.2. Frontend Modules (Next.js)

```
src/frontend/
├── app/
│   ├── auth/
│   │   ├── login/page.tsx
│   │   ├── register/page.tsx
│   │   └── forgot-password/page.tsx
├── components/
│   ├── auth/
│   │   ├── LoginForm.tsx
│   │   ├── RegisterForm.tsx
│   │   └── ForgotPasswordForm.tsx
├── lib/
│   ├── validators/auth.ts (Zod schemas)
│   └── api/auth.ts (API calls)
└── stores/
    └── authStore.ts (Zustand)
```

## 2. Business Logic Flow

### 2.1. User Registration Flow

1. **UI**: User fills RegisterForm with email, password, confirmPassword
2. **Validation**: Zod schema validates client-side
3. **API Call**: POST /api/auth/register
4. **Backend Processing**:
   - Check email uniqueness
   - Validate password complexity
   - Hash password with Bcrypt
   - Create user in database
   - Generate JWT token
5. **Response**: Return token and user info
6. **Frontend**: Store token in NextAuth.js session

### 2.2. User Login Flow

1. **UI**: User enters credentials
2. **API Call**: POST /api/auth/login
3. **Backend Processing**:
   - Validate credentials
   - Check account lockout status
   - Increment failed attempts if invalid
   - Generate JWT token if valid
4. **Response**: Return token or error
5. **Frontend**: Update auth state

## 3. Data Flow Diagram

```
[User] → [UI Form] → [Validation] → [API] → [Controller] → [AppService] → [Domain] → [Database]
    ↑                                                                                    ↓
[Session Update] ← [Token Storage] ← [Response] ← [JWT Token] ← [Auth Result] ← [User Entity]
```

## 4. Error Handling Strategy

- **Validation Errors**: Client-side with Zod + server-side with FluentValidation
- **Business Errors**: Custom exceptions with specific error codes
- **System Errors**: Global exception handler with logging
- **Security Errors**: Audit logging for failed attempts
