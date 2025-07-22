# Low-Level Design: Authentication v1.0

## 1. Detailed Class Implementations

### 1.1. Backend Implementation

#### AuthenticationAppService.cs

```csharp
[Authorize]
public class AuthenticationAppService : ApplicationService, IAuthenticationAppService
{
    private readonly IIdentityUserRepository _userRepository;
    private readonly IdentityUserManager _userManager;
    private readonly SignInManager<IdentityUser> _signInManager;
    private readonly IConfiguration _configuration;
    private readonly IEmailSender _emailSender;
    public AuthenticationAppService(
        IIdentityUserRepository userRepository,
        IdentityUserManager userManager,
        SignInManager<IdentityUser> signInManager,
        IConfiguration configuration,
        IEmailSender emailSender)
    {
        _userRepository = userRepository;
        _userManager = userManager;
        _signInManager = signInManager;
        _configuration = configuration;
        _emailSender = emailSender;
    }

    [AllowAnonymous]
    public async Task<AuthResultDto> RegisterAsync(RegisterDto input)
    {
        // 1. Validate input
        await ValidateRegisterInput(input);
        
        // 2. Check if email already exists
        var existingUser = await _userManager.FindByEmailAsync(input.Email);
        if (existingUser != null)
        {
            throw new BusinessException("Auth:EmailAlreadyExists")
                .WithData("Email", input.Email);
        }
        
        // 3. Create new user
        var user = new IdentityUser(
            id: GuidGenerator.Create(),
            userName: input.Email,
            email: input.Email,
            tenantId: CurrentTenant.Id
        );
        
        var identityResult = await _userManager.CreateAsync(user, input.Password);
        identityResult.CheckErrors();
        
        // 4. Generate JWT token
        var token = await GenerateJwtTokenAsync(user);
        
        // 5. Return result
        return new AuthResultDto
        {
            Token = token,
            ExpiresIn = TimeSpan.FromHours(24).TotalSeconds,
            User = ObjectMapper.Map<IdentityUser, UserInfoDto>(user)
        };
    }

    [AllowAnonymous]
    public async Task<AuthResultDto> LoginAsync(LoginDto input)
    {
        // 1. Find user by email
        var user = await _userManager.FindByEmailAsync(input.Email);
        if (user == null)
        {
            throw new BusinessException("Auth:InvalidCredentials");
        }
        
        // 2. Check if account is locked
        if (await _userManager.IsLockedOutAsync(user))
        {
            var lockoutEnd = await _userManager.GetLockoutEndDateAsync(user);
            throw new BusinessException("Auth:AccountLocked")
                .WithData("LockoutEnd", lockoutEnd?.ToString("yyyy-MM-dd HH:mm:ss"));
        }
        
        // 3. Verify password
        var signInResult = await _signInManager.CheckPasswordSignInAsync(
            user, input.Password, lockoutOnFailure: true);
        
        if (!signInResult.Succeeded)
        {
            if (signInResult.IsLockedOut)
            {
                throw new BusinessException("Auth:AccountLocked");
            }
            
            throw new BusinessException("Auth:InvalidCredentials");
        }
        
        // 4. Generate JWT token
        var token = await GenerateJwtTokenAsync(user);
        
        return new AuthResultDto
        {
            Token = token,
            ExpiresIn = TimeSpan.FromHours(24).TotalSeconds,
            User = ObjectMapper.Map<IdentityUser, UserInfoDto>(user)
        };
    }

    private async Task<string> GenerateJwtTokenAsync(IdentityUser user)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(_configuration["Jwt:SecretKey"]);
        
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.UserName),
                new Claim(ClaimTypes.Email, user.Email),
            }),
            Expires = DateTime.UtcNow.AddHours(24),
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(key),
                SecurityAlgorithms.HmacSha256Signature)
        };
        
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
```

#### DTOs and Validators

```csharp
public class RegisterDto
{
    [Required]
    [EmailAddress]
    public string Email { get; set; }
    [Required]
    [StringLength(100, MinimumLength = 8)]
    public string Password { get; set; }

    [Required]
    [Compare(nameof(Password))]
    public string ConfirmPassword { get; set; }
}

public class RegisterDtoValidator : AbstractValidator<RegisterDto>
{
    public RegisterDtoValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .WithMessage("Email không hợp lệ");
        RuleFor(x => x.Password)
            .NotEmpty()
            .MinimumLength(8)
            .Matches(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$")
            .WithMessage("Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số");
        RuleFor(x => x.ConfirmPassword)
            .Equal(x => x.Password)
            .WithMessage("Mật khẩu xác nhận không khớp");
    }
}
```

### 1.2. Frontend Implementation

#### LoginForm.tsx

```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useMutation } from '@tanstack/react-query';
import { useAuthStore } from '@/stores/authStore';
import { authApi } from '@/lib/api/auth';

const loginSchema = z.object({
    email: z.string().email('Email không hợp lệ'),
    password: z.string().min(1, 'Mật khẩu không được để trống'),
});

type LoginFormData = z.infer<typeof loginSchema>;

interface LoginFormProps {
    onSuccess?: (user: User) => void;
    redirectTo?: string;
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSuccess, redirectTo }) => {
    const { login } = useAuthStore();

    const {
        register,
        handleSubmit,
        formState: { errors },
        setError,
    } = useForm<LoginFormData>({
        resolver: zodResolver(loginSchema),
    });

    const loginMutation = useMutation({
        mutationFn: authApi.login,
        onSuccess: (data) => {
            login(data.token, data.user);
            onSuccess?.(data.user);
            if (redirectTo) {
                window.location.href = redirectTo;
            }
        },
        onError: (error: ApiError) => {
            if (error.code === 'Auth:InvalidCredentials') {
                setError('root', { message: 'Email hoặc mật khẩu không chính xác' });
            } else if (error.code === 'Auth:AccountLocked') {
                setError('root', { message: 'Tài khoản đã bị khóa do đăng nhập sai nhiều lần' });
            } else {
                setError('root', { message: 'Có lỗi xảy ra, vui lòng thử lại' });
            }
        },
    });

    const onSubmit = async (data: LoginFormData) => {
        loginMutation.mutate(data);
    };

    return (
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                    Email
                </label>
                <input
                    {...register('email')}
                    type="email"
                    id="email"
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    placeholder="your@email.com"
                />
                {errors.email && (
                    <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
                )}
            </div>
            <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                    Mật khẩu
                </label>
                <input
                    {...register('password')}
                    type="password"
                    id="password"
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                    placeholder="Nhập mật khẩu"
                />
                {errors.password && (
                    <p className="mt-1 text-sm text-red-600">{errors.password.message}</p>
                )}
            </div>
            {errors.root && (
                <div className="rounded-md bg-red-50 p-4">
                    <p className="text-sm text-red-800">{errors.root.message}</p>
                </div>
            )}
            <button
                type="submit"
                disabled={loginMutation.isPending}
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
            >
                {loginMutation.isPending ? 'Đang đăng nhập...' : 'Đăng nhập'}
            </button>
        </form>
    );
};
```

#### API Service Layer

```typescript
// lib/api/auth.ts
import { ApiClient } from './client';

export interface LoginRequest {
    email: string;
    password: string;
}

export interface RegisterRequest {
    email: string;
    password: string;
    confirmPassword: string;
}

export interface AuthResponse {
    token: string;
    expiresIn: number;
    user: {
        id: string;
        email: string;
        userName: string;
    };
}

export const authApi = {
    login: async (data: LoginRequest): Promise<AuthResponse> => {
        const response = await ApiClient.post('/api/auth/login', data);
        return response.data;
    },

    register: async (data: RegisterRequest): Promise<AuthResponse> => {
        const response = await ApiClient.post('/api/auth/register', data);
        return response.data;
    },

    forgotPassword: async (email: string): Promise<void> => {
        await ApiClient.post('/api/auth/forgot-password', { email });
    },

    resetPassword: async (token: string, password: string): Promise<void> => {
        await ApiClient.post('/api/auth/reset-password', { token, password });
    },

    logout: async (): Promise<void> => {
        await ApiClient.post('/api/auth/logout');
    },
};
```

## 2. Algorithms and Data Structures

### 2.1. Password Hashing Algorithm

```csharp
public static class PasswordHasher
{
    private const int WorkFactor = 12;

    public static string HashPassword(string password)
    {
        return BCrypt.Net.BCrypt.HashPassword(password, WorkFactor);
    }

    public static bool VerifyPassword(string password, string hashedPassword)
    {
        return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
    }
}
```

### 2.2. Rate Limiting Implementation

```csharp
public class RateLimitingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IDistributedCache _cache;

    public RateLimitingMiddleware(RequestDelegate next, IDistributedCache cache)
    {
        _next = next;
        _cache = cache;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var key = $"rate_limit:{context.Connection.RemoteIpAddress}";
        var attempts = await _cache.GetStringAsync(key);
        
        if (int.TryParse(attempts, out var attemptCount) && attemptCount >= 5)
        {
            context.Response.StatusCode = 429;
            await context.Response.WriteAsync("Too many requests");
            return;
        }
        
        await _next(context);
        
        if (context.Response.StatusCode == 401)
        {
            await _cache.SetStringAsync(key, 
                (attemptCount + 1).ToString(),
                TimeSpan.FromMinutes(15));
        }
    }
}
```

## 3. Exception Handling Details

### 3.1. Custom Exception Classes

```csharp
public class AuthenticationException : BusinessException
{
    public AuthenticationException(string code, string message = null)
        : base(code, message)
    {
    }
}

public class AccountLockedException : AuthenticationException
{
    public DateTimeOffset LockoutEnd { get; }

    public AccountLockedException(DateTimeOffset lockoutEnd) 
        : base("Auth:AccountLocked", "Account is temporarily locked")
    {
        LockoutEnd = lockoutEnd;
    }
}
```

### 3.2. Global Exception Handler

```csharp
public class GlobalExceptionHandler : IExceptionHandler
{
    public async Task<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        var response = exception switch
        {
            BusinessException businessEx => new ErrorResponse
            {
                Code = businessEx.Code,
                Message = businessEx.Message,
                Details = businessEx.Data
            },
            ValidationException validationEx => new ErrorResponse
            {
                Code = "Validation:Failed",
                Message = "Input validation failed",
                Details = validationEx.Errors.ToDictionary(x => x.PropertyName, x => x.ErrorMessage)
            },
            _ => new ErrorResponse
            {
                Code = "System:InternalError",
                Message = "An internal error occurred"
            }
        };

        httpContext.Response.StatusCode = GetStatusCode(exception);
        httpContext.Response.ContentType = "application/json";
        
        await httpContext.Response.WriteAsync(
            JsonSerializer.Serialize(response), 
            cancellationToken);
        
        return true;
    }
}
```