# Code Convention Document: Authentication v1.0

## 1. General Guidelines

### 1.1. Language Standards

- **Backend**: C# 12.0 with .NET 9.0 features
- **Frontend**: TypeScript 5.0+ with strict mode enabled
- **Comments**: English for code, Vietnamese for user-facing messages

### 1.2. File Organization

**Backend Structure:**
```
src/AbpApp.Application/Authentication/
├── IAuthenticationAppService.cs
├── AuthenticationAppService.cs
├── Dto/
│   ├── LoginDto.cs
│   ├── RegisterDto.cs
│   └── ResetPasswordDto.cs
└── Validators/
    └── RegisterDtoValidator.cs
```

**Frontend Structure:**
```
src/frontend/components/auth/
├── LoginForm.tsx
├── RegisterForm.tsx
└── index.ts
```

## 2. Backend Conventions (.NET/ABP)

### 2.1. Naming Conventions

- **Classes**: PascalCase (`AuthenticationAppService`)
- **Interfaces**: I + PascalCase (`IAuthenticationAppService`)
- **Methods**: PascalCase + Async suffix (`RegisterAsync`)
- **Properties**: PascalCase (`Email`, `Password`)
- **Private fields**: _camelCase (`_userManager`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_LOGIN_ATTEMPTS`)

### 2.2. Method Structure

```csharp
public async Task<AuthResultDto> LoginAsync(LoginDto input)
{
    // 1. Validation
    await ValidateLoginInput(input);
    
    // 2. Business logic
    var user = await _userManager.FindByEmailAsync(input.Email);
    var result = await _signInManager.CheckPasswordSignInAsync(user, input.Password, lockoutOnFailure: true);

    // 3. Response mapping
    return new AuthResultDto
    {
        Token = await GenerateTokenAsync(user),
        ExpiresIn = TimeSpan.FromHours(24)
    };
}
```

### 2.3. Error Handling

```csharp
// Use ABP's BusinessException for business logic errors
throw new BusinessException("Auth:EmailAlreadyExists")
    .WithData("Email", input.Email);

// Use UserFriendlyException for user-facing errors
throw new UserFriendlyException("Tài khoản đã bị khóa do đăng nhập sai nhiều lần");
```

## 3. Frontend Conventions (Next.js/React)

### 3.1. Naming Conventions

- **Components**: PascalCase (`LoginForm.tsx`)
- **Hooks**: camelCase with 'use' prefix (`useAuthStore`)
- **Constants**: UPPER_SNAKE_CASE (`API_ENDPOINTS`)
- **Types/Interfaces**: PascalCase (`LoginFormData`)

### 3.2. Component Structure

```typescript
// LoginForm.tsx
interface LoginFormProps {
    onSuccess?: (user: User) => void;
    redirectTo?: string;
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSuccess, redirectTo }) => {
    // 1. Hooks
    const { mutate: login, isLoading } = useLoginMutation();
    const { register, handleSubmit, formState: { errors } } = useForm<LoginFormData>();

    // 2. Handlers
    const onSubmit = async (data: LoginFormData) => {
        // Implementation
    };

    // 3. Render
    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            {/* Form fields */}
        </form>
    );
};
```

### 3.3. State Management

```typescript
// stores/authStore.ts
interface AuthState {
    user: User | null;
    token: string | null;
    isAuthenticated: boolean;
    login: (token: string, user: User) => void;
    logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
    user: null,
    token: null,
    isAuthenticated: false,
    login: (token, user) => set({ token, user, isAuthenticated: true }),
    logout: () => set({ token: null, user: null, isAuthenticated: false }),
}));
```

## 4. API Design Standards

### 4.1. Endpoint Naming

- **RESTful**: `/api/auth/login`, `/api/auth/register`
- **HTTP Methods**: POST for mutations, GET for queries
- **Versioning**: `/api/v1/auth/login` (future consideration)

### 4.2. Request/Response Format

```typescript
// Request
interface LoginRequest {
    email: string;
    password: string;
}

// Response
interface LoginResponse {
    token: string;
    expiresIn: number;
    user: {
        id: string;
        email: string;
        userName: string;
    };
}

// Error Response
interface ErrorResponse {
    code: string;
    message: string;
    details?: Record<string, string[]>;
}
```

## 5. Testing Standards

### 5.1. Unit Test Naming

**Backend (xUnit):**
```csharp
[Fact]
public async Task RegisterAsync_WithValidInput_ShouldCreateUser()
{
    // Arrange
    var input = new RegisterDto { Email = "test@example.com", Password = "Password123" };
    
    // Act
    var result = await _authService.RegisterAsync(input);

    // Assert
    Assert.NotNull(result.Token);
}
```

**Frontend (Jest):**
```typescript
describe('LoginForm', () => {
    it('should submit form with valid credentials', async () => {
        // Arrange
        const mockOnSuccess = jest.fn();
        render(<LoginForm onSuccess={mockOnSuccess} />);

        // Act
        await user.type(screen.getByLabelText(/email/i), 'test@example.com');
        await user.type(screen.getByLabelText(/password/i), 'password123');
        await user.click(screen.getByRole('button', { name: /login/i }));

        // Assert
        expect(mockOnSuccess).toHaveBeenCalledWith(expect.objectContaining({
            email: 'test@example.com'
        }));
    });
});
```