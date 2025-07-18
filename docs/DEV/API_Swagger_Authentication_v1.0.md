# API Swagger Generator: Authentication v1.0

```yaml
openapi: 3.0.1
info:
  title: Authentication API
  description: API documentation for Authentication module
  version: "1.0"
  contact:
    name: Development Team
    email: dev@company.com

servers:
  - url: https://localhost:44300
    description: Local development server
  - url: https://api.company.com
    description: Production server

paths:
  /api/auth/register:
    post:
      tags:
        - Authentication
      summary: Register a new user account
      description: Creates a new user account with email and password
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/RegisterRequest'
            example:
              email: "user@example.com"
              password: "Password123"
              confirmPassword: "Password123"
      responses:
        '200':
          description: Registration successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AuthResponse'
              example:
                token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                expiresIn: 86400
                user:
                  id: "3fa85f64-5717-4562-b3fc-2c963f66afa6"
                  email: "user@example.com"
                  userName: "user@example.com"
        '400':
          description: Invalid input data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: "Validation:Failed"
                message: "Input validation failed"
                details:
                  Email: "Email không hợp lệ"
                  Password: "Mật khẩu phải có ít nhất 8 ký tự"
        '409':
          description: Email already exists
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: "Auth:EmailAlreadyExists"
                message: "Email already exists"
                details:
                  Email: "user@example.com"

  /api/auth/login:
    post:
      tags:
        - Authentication
      summary: Login with email and password
      description: Authenticate user and return JWT token
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LoginRequest'
            example:
              email: "user@example.com"
              password: "Password123"
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AuthResponse'
        '401':
          description: Invalid credentials or account locked
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              examples:
                invalid_credentials:
                  summary: Invalid credentials
                  value:
                    code: "Auth:InvalidCredentials"
                    message: "Email hoặc mật khẩu không chính xác"
                account_locked:
                  summary: Account locked
                  value:
                    code: "Auth:AccountLocked"
                    message: "Tài khoản đã bị khóa do đăng nhập sai nhiều lần"
                    details:
                      LockoutEnd: "2023-12-01 15:30:00"

  /api/auth/forgot-password:
    post:
      tags:
        - Authentication
      summary: Request password reset
      description: Send password reset email to user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
            example:
              email: "user@example.com"
      responses:
        '200':
          description: Password reset email sent (always returns 200 for security)
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
              example:
                message: "Nếu email tồn tại, bạn sẽ nhận được hướng dẫn đặt lại mật khẩu"

  /api/auth/reset-password:
    post:
      tags:
        - Authentication
      summary: Reset password with token
      description: Reset user password using reset token from email
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ResetPasswordRequest'
            example:
              token: "CfDJ8Mh8..."
              password: "NewPassword123"
              confirmPassword: "NewPassword123"
      responses:
        '200':
          description: Password reset successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
              example:
                message: "Mật khẩu đã được đặt lại thành công"
        '400':
          description: Invalid or expired token
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
              example:
                code: "Auth:InvalidResetToken"
                message: "Token đặt lại mật khẩu không hợp lệ hoặc đã hết hạn"

  /api/auth/logout:
    post:
      tags:
        - Authentication
      summary: Logout user
      description: Invalidate current session
      security:
        - BearerAuth: []
      responses:
        '200':
          description: Logout successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
              example:
                message: "Đăng xuất thành công"
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

components:
  schemas:
    RegisterRequest:
      type: object
      required:
        - email
        - password
        - confirmPassword
      properties:
        email:
          type: string
          format: email
          description: User email address
        password:
          type: string
          format: password
          minLength: 8
          description: User password (min 8 chars, must contain uppercase, lowercase, and number)
        confirmPassword:
          type: string
          format: password
          description: Password confirmation (must match password)

    LoginRequest:
      type: object
      required:
        - email
        - password
      properties:
        email:
          type: string
          format: email
          description: User email address
        password:
          type: string
          format: password
          description: User password

    ResetPasswordRequest:
      type: object
      required:
        - token
        - password
        - confirmPassword
      properties:
        token:
          type: string
          description: Password reset token from email
        password:
          type: string
          format: password
          minLength: 8
          description: New password
        confirmPassword:
          type: string
          format: password
          description: New password confirmation

    AuthResponse:
      type: object
      properties:
        token:
          type: string
          description: JWT access token
        expiresIn:
          type: integer
          description: Token expiration time in seconds
        user:
          $ref: '#/components/schemas/UserInfo'

    UserInfo:
      type: object
      properties:
        id:
          type: string
          format: uuid
          description: User unique identifier
        email:
          type: string
          format: email
          description: User email address
        userName:
          type: string
          description: User name

    ErrorResponse:
      type: object
      properties:
        code:
          type: string
          description: Error code
        message:
          type: string
          description: Error message
        details:
          type: object
          additionalProperties:
            type: string
          description: Additional error details

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT token authentication
```

# Error Codes Reference
# Auth:EmailAlreadyExists - Email already registered
# Auth:InvalidCredentials - Invalid email or password
# Auth:AccountLocked - Account temporarily locked
# Auth:InvalidResetToken - Invalid or expired reset token
# Validation:Failed - Input validation failed
# System:InternalError - Internal server error
