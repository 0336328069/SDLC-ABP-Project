# META-PROMPT: BACKEND API GENERATOR

## 1. VAI TRÒ

Bạn là một AI Prompt Engineer chuyên tạo prompts cho việc generate Backend API Implementation trong ABP Framework projects theo Clean Architecture và RESTful API principles.

## 2. BỐI CẢNH

**Input cần thiết**:

1. **API*Swagger*[FeatureName].yaml** - API design specification
2. **PRD_[FeatureName].md** - Product requirements và user flows
3. **SRS&DM_[FeatureName].md** - Software requirements specification
4. **US_[FeatureName].md** - Use case specifications
5. **ImplementPlan_[FeatureName].md** - Implementation function planning
6. **CodeConventionDocument_[FeatureName].md** - Code standards và conventions
7. **Feature Name** - Tên feature cần generate backend API
8. **Project Path** - Đường dẫn đến thư mục gốc project liên quan đến backend

**Dynamic Project Information** (extracted from inputs):

- **Technology Stack**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Framework**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **File Organization**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Naming Conventions**: {EXTRACT_FROM_CODE_STANDARD}
- **API Endpoints**: {DETERMINE_FROM_SWAGGER_AND_USE_CASES}

## 3. MỤC TIÊU

Tạo ra một prompt chi tiết để generate Backend API Implementation cho bất kỳ feature nào, tuân thủ:

- Clean Architecture principles với clear layer separation
- RESTful API design patterns và HTTP standards
- ASP.NET Core và ABP Framework conventions
- Proper authentication, authorization, và validation
- Complete API controller implementation với DTOs
- Exception handling và logging best practices
- Complete API documentation

## 4. TEMPLATE GENERATION PROCESS

### Bước 1: Phân tích Input Documents

```
Đọc và phân tích:
- API_Swagger_[FeatureName].yaml → Extract API endpoints, request/response models
- PRD_[FeatureName].md → Extract business requirements và user stories
- SRS&DM_[FeatureName].md → Extract technical requirements và data models
- US_[FeatureName].md → Extract use case flows và business logic
- ImplementPlan_[FeatureName].md → Extract implementation details và architecture
- CodeConventionDocument_[FeatureName].md → Extract coding standards
```

### Bước 2: Identify API Components

Từ analysis, xác định:

- **API Controllers**: RESTful endpoints grouped by business functionality
- **Request/Response DTOs**: Data transfer objects for API communication
- **API Contracts**: Interface definitions cho controllers
- **Validation Logic**: Input validation và business rule enforcement
- **Exception Handling**: Error responses và status codes
- **Authorization**: Permission-based access control

### Bước 3: Map to API Structure

Ánh xạ components vào cấu trúc API:

```
{ProjectName}/
├── Controllers/{FeatureName}/
│   ├── {FeatureName}Controller.cs           # Main API controller
│   └── {FeatureName}AdminController.cs      # Admin-specific endpoints
├── Contracts/{FeatureName}/
│   ├── I{FeatureName}AppService.cs          # Application service interface
│   └── DTOs/
│       ├── {FeatureName}RequestDto.cs       # Request DTOs
│       └── {FeatureName}ResponseDto.cs      # Response DTOs
└── Tests/{FeatureName}/
    ├── {FeatureName}ControllerTests.cs      # API endpoint tests
    └── {FeatureName}IntegrationTests.cs     # Integration tests
```

## 5. PROMPT TEMPLATE

````markdown
# BACKEND API {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 1. VAI TRÒ

Bạn là một Senior Software Architect chuyên về Clean Architecture và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:

- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **API Location**: {DETECTED_API_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}

**Database**: {DATABASE_INFO}

### Input Documents đã phân tích:

- **API*Swagger*{FeatureName}.yaml**: {API_SPECIFICATION_SUMMARY}
- **PRD\_{FeatureName}.md**: {BUSINESS_REQUIREMENTS_SUMMARY}
- **SRS&DM\_{FeatureName}.md**: {TECHNICAL_REQUIREMENTS_SUMMARY}
- **US\_{FeatureName}.md**: {USE_CASES_SUMMARY}
- **ImplementPlan\_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **CodeConventionDocument\_{FeatureName}.md**: {CODE_STANDARDS_SUMMARY}

### API Endpoints Available:

{API_ENDPOINTS_LIST}

## 3. MỤC TIÊU BACKEND API

### 3.1 API CONTROLLERS

{API_CONTROLLERS_SECTION}

### 3.2 API MODELS (REQUEST/RESPONSE DTOS)

{API_MODELS_SECTION}

### 3.3 API CONTRACTS

{API_CONTRACTS_SECTION}

### 3.4 MAPPING & ORCHESTRATION

{MAPPING_ORCHESTRATION_SECTION}

### 3.5 EXCEPTION HANDLING & LOGGING

{EXCEPTION_HANDLING_SECTION}

### 3.6 UNIT TESTS / INTEGRATION TESTS

{TESTING_SECTION}

### 3.7 DOCUMENTATION

{DOCUMENTATION_SECTION}

## 4. YÊU CẦU IMPLEMENTATION

{IMPLEMENTATION_REQUIREMENTS_SECTION}

## 5. OUTPUT FORMAT

{OUTPUT_FORMAT_SECTION}

## 6. API QUALITY STANDARDS

{QUALITY_STANDARDS_SECTION}

## 7. SECURITY & VALIDATION REQUIREMENTS

{SECURITY_VALIDATION_SECTION}

## 8. BUSINESS WORKFLOWS MAPPING

{WORKFLOWS_MAPPING_SECTION}

## 9. VERIFICATION

Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`{PROJECT_PATH}`):

```bash
{DETECTED_BUILD_COMMAND}
```
````

Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.

```

## 6. USAGE INSTRUCTIONS

### Input Required:
1. **Feature Name**: Tên feature (vd: Authentication, UserManagement, OrderProcessing)
2. **API_Swagger File Path**: Đường dẫn đến API specification file
3. **PRD File Path**: Đường dẫn đến PRD file
4. **SRS&DM File Path**: Đường dẫn đến SRS file
5. **US File Path**: Đường dẫn đến Use Cases file
6. **ImplementPlan File Path**: Đường dẫn đến implementation plan
7. **CodeConvention File Path**: Đường dẫn đến code convention document
8. **Project Root Path**: Đường dẫn đến thư mục gốc project

### Execution Steps:
1. **Read và analyze input documents** (API_Swagger, PRD, SRS, US, ImplementPlan, CodeConvention)
2. **Auto-detect technology stack** từ project files và ImplementPlan
3. **Extract API endpoints** từ Swagger specification
4. **Identify use case flows** từ US và PRD files
5. **Generate prompt** sử dụng template trên với dynamic variables
6. **Customize sections** dựa trên detected stack và feature requirements
7. **Validate prompt** với API quality checklist
8. **Save prompt** tại `prompts/BACKEND_API_{FeatureName}_Prompt.md`

## 7. TECHNOLOGY AUTO-DETECTION GUIDELINES

### 7.1 Detection Algorithm (Dynamic Instructions)
Khi chạy prompt này, bạn phải thực hiện các bước sau để auto-detect technology stack:

**Step 1: Scan Project Structure**
```

1. Read project files từ {PROJECT_PATH}
2. Identify configuration files (.csproj, package.json, pom.xml, requirements.txt, etc.)
3. Analyze folder structure patterns
4. Extract framework indicators từ code files

```

**Step 2: Framework Detection Rules**
```

- Nếu tìm thấy "\*.csproj" + "AbpModule" → ABP Framework (.NET)
- Nếu tìm thấy "package.json" + "@nestjs" → NestJS (TypeScript)
- Nếu tìm thấy "pom.xml" + "@SpringBootApplication" → Spring Boot (Java)
- Nếu tìm thấy "manage.py" + "Django" → Django (Python)
- Nếu tìm thấy "package.json" + "express" → Express.js (JavaScript)

```

**Step 3: Path Pattern Detection**
```

- Analyze thư mục structure để determine:
  - Single-tier vs Multi-tier architecture
  - Controllers folder organization
  - Namespace/package naming patterns
  - File naming conventions

```

**Step 4: Generate Dynamic Variables**
```

Từ detection results, tạo các variables cho output prompt:

- {AUTO_DETECTED_FRAMEWORK}
- {AUTO_DETECTED_LANGUAGE}
- {AUTO_DETECTED_FILE_EXT}
- {AUTO_DETECTED_CONTROLLERS_PATH}
- {AUTO_DETECTED_NAMESPACE_PATTERN}
- {AUTO_DETECTED_BASE_CONTROLLERS}
- {AUTO_DETECTED_BUILD_COMMAND}

````

### 7.2 Output Prompt Structure
Trong generated prompt, phải include section:
```markdown
## DETECTED PROJECT CONFIGURATION
- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **API Location**: {DETECTED_API_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}
````

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 API_CONTROLLERS_SECTION

```markdown
Dựa trên {API_Swagger}, implement các controllers:

#### {FeatureName}Controller

- RESTful endpoints cho {FeatureName} operations
- HTTP Methods được extract từ {Swagger}: {ExtractedEndpoints}
- Authorization: {PermissionRequirements}
- Files:
  - `Controllers/{FeatureName}/{FeatureName}Controller.cs`

#### {AdditionalControllers}

{AdditionalControllerDefinitions}
```

### 8.2 API_MODELS_SECTION

```markdown
Request/Response DTOs implementation:

#### Request DTOs

- {RequestDto1}: {Description}
- Properties: {RequestProperties}
- Validation: {ValidationRules}

#### Response DTOs

- {ResponseDto1}: {Description}
- Properties: {ResponseProperties}
- Mapping: {MappingLogic}

#### Files Organization

- `Contracts/{FeatureName}/DTOs/{DtoName}.cs`
```

### 8.3 API_CONTRACTS_SECTION

```markdown
Interface definitions cho API services:

#### I{FeatureName}AppService

- Application service interface
- Methods: {ApplicationServiceMethods}
- File: `Contracts/{FeatureName}/I{FeatureName}AppService.cs`
```

### 8.4 MAPPING_ORCHESTRATION_SECTION

```markdown
Mapping và orchestration logic:

#### DTO Mapping

- API DTO → Application DTO → Domain Entity
- AutoMapper configuration: {MappingProfiles}

#### Service Orchestration

- Controller → Application Service → Domain Service
- Dependency injection: {ServiceDependencies}
```

### 8.5 EXCEPTION_HANDLING_SECTION

```markdown
Exception handling implementation:

#### Global Exception Filter

- Handle business exceptions
- HTTP status code mapping: {StatusCodeMapping}
- Error response format: {ErrorResponseFormat}

#### Logging Strategy

- Request/Response logging
- Business error logging
- Performance monitoring
```

### 8.6 TESTING_SECTION

```markdown
Testing strategy implementation:

#### Unit Tests

- Controller endpoint tests: {ControllerTests}
- Mock application services: {MockSetup}

#### Integration Tests

- End-to-end API tests: {IntegrationTests}
- Authentication scenarios: {AuthTests}
```

### 8.7 DOCUMENTATION_SECTION

```markdown
Backend API documentation:

#### BackendAPI\_{FeatureName}.md

Tạo comprehensive API documentation file tại `docs/DEV/Documents_Backend_API_{FeatureName}.md` với nội dung:

##### API Requirements Specification

- Technology Stack Context: {TechnologyStackDetails}
- API Architecture Principles: {ArchitecturePrinciples}
- Authentication & Authorization Strategy: {AuthStrategy}

##### Controller Specifications

{FOR_EACH_CONTROLLER}

###### {ControllerName}Controller

- **Base Route**: `{BaseRoute}`
- **Purpose**: {ControllerPurpose}
- **Authorization Requirements**: {AuthorizationDetails}

**Endpoints:**

{FOR_EACH_ENDPOINT}

**{HTTP_METHOD} {ENDPOINT_PATH}**

- **Purpose**: {EndpointDescription}
- **Authorization**: {PermissionRequired}
- **Parameters**: {ParametersList}
- **Request Body**: {RequestBodyType}
- **Response**: {ResponseType}
- **Status Codes**: {StatusCodesList}
- **Example Request**:
  ```json
  {RequestExample}
  ```
- **Example Response**:
  ```json
  {ResponseExample}
  ```
- **Business Rules**: {BusinessRulesApplied}
- **Error Scenarios**: {ErrorScenarios}

##### API Response Standards

###### Success Response Format
```json
{
  "data": { /* Actual response data */ },
  "success": true,
  "error": null,
  "unAuthorizedRequest": false,
  "__abp": true
}
```

###### Error Response Format
```json
{
  "error": {
    "code": "{ErrorCode}",
    "message": "{ErrorMessage}",
    "details": "{ErrorDetails}",
    "data": {},
    "validationErrors": [
      {
        "message": "{ValidationMessage}",
        "members": ["{FieldName}"]
      }
    ]
  },
  "success": false,
  "unAuthorizedRequest": false,
  "__abp": true
}
```

###### Pagination Response Format
```json
{
  "totalCount": 150,
  "items": [ /* Array of items */ ]
}
```

##### Security & Validation

###### Authentication
- JWT token requirements: {JWTRequirements}
- Token validation process: {TokenValidation}
- Token expiration handling: {ExpirationHandling}

###### Authorization
- Permission-based access control: {PermissionSystem}
- Role-based endpoint access: {RoleBasedAccess}
- Resource ownership validation: {OwnershipValidation}

###### Input Validation
- Model validation rules: {ValidationRules}
- Custom validation attributes: {CustomValidation}
- Business rule validation: {BusinessRuleValidation}

###### Rate Limiting
- Request limits per endpoint: {RateLimits}
- Burst allowance policies: {BurstPolicies}
- Rate limit exceeded responses: {RateLimitResponses}

##### Performance Requirements

###### Response Time Targets
- Simple operations: {SimpleOperationTargets}
- Search operations: {SearchOperationTargets}
- Complex operations: {ComplexOperationTargets}
- File operations: {FileOperationTargets}

###### Caching Strategy
- Cache policies: {CachePolicies}
- Cache invalidation: {CacheInvalidation}
- Cache keys: {CacheKeys}

###### Database Optimization
- Pagination implementation: {PaginationStrategy}
- Query optimization: {QueryOptimization}
- Performance monitoring: {PerformanceMonitoring}

##### Error Handling

###### Custom Exception Types
- Business exceptions: {BusinessExceptions}
- Validation exceptions: {ValidationExceptions}
- Security exceptions: {SecurityExceptions}

###### HTTP Status Code Usage
- Success codes: {SuccessCodes}
- Client error codes: {ClientErrorCodes}
- Server error codes: {ServerErrorCodes}

##### API Testing Strategy

###### Unit Testing
- Controller testing: {ControllerTests}
- Mock setup: {MockSetup}
- Test scenarios: {TestScenarios}

###### Integration Testing
- End-to-end workflows: {E2EWorkflows}
- Authentication testing: {AuthTesting}
- Performance testing: {PerformanceTesting}

##### Swagger/OpenAPI Documentation

###### Configuration
- API versioning: {APIVersioning}
- Documentation generation: {DocGeneration}
- Interactive testing: {InteractiveTesting}

###### Examples and Schemas
- Request examples: {RequestExamples}
- Response examples: {ResponseExamples}
- Schema definitions: {SchemaDefinitions}

##### Monitoring and Observability

###### Logging Strategy
- Request/Response logging: {RequestResponseLogging}
- Error logging: {ErrorLogging}
- Performance logging: {PerformanceLogging}

###### Metrics and Monitoring
- API metrics: {APIMetrics}
- Health checks: {HealthChecks}
- Alerting: {AlertingStrategy}
```

### 8.8 IMPLEMENTATION_REQUIREMENTS_SECTION

```markdown
## API Implementation Best Practices

- **DO**: Follow RESTful design principles
- **DO**: Use proper HTTP verbs và status codes
- **DO**: Implement proper authorization với {AuthorizationStrategy}
- **DO**: Validate all input using {ValidationFramework}
- **DO**: Return consistent error responses
- **DO**: Follow {FeatureSpecific} naming conventions
- **DO NOT**: Expose domain logic in controllers
- **DO NOT**: Return sensitive data in responses
- **DO NOT**: Create additional features beyond {FeatureName}

## Controller Characteristics cho {FeatureName}

- Async methods: All API endpoints
- CancellationToken support
- Authorization attributes: {AuthorizationAttributes}
- Validation attributes: {ValidationAttributes}
- Exception handling: Global exception filter
```

### 8.9 OUTPUT_FORMAT_SECTION

```markdown
**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

1. **Controller Files**: `Controllers/{FeatureName}/{FeatureName}Controller.cs`
2. **DTO Files**: `Contracts/{FeatureName}/DTOs/*.cs`
3. **Contract Files**: `Contracts/{FeatureName}/I{FeatureName}AppService.cs`
4. **Test Files**: `Tests/{FeatureName}/*Tests.cs`
5. **Additional Files**: {AdditionalAPIFiles}

#### Documentation Files

6. **Backend API Documentation**: `docs/DEV/Documents_Backend_API_{FeatureName}.md`
   - Complete API specification với endpoint documentation
   - Request/Response examples và schemas
   - Authentication và authorization requirements
   - Security và validation guidelines
   - Performance requirements và caching strategies
   - Error handling và status code usage
   - Testing strategies và examples
   - Swagger/OpenAPI configuration
   - Monitoring và observability setup

Each file must be complete, compilable code following ABP Framework conventions.
Each documentation file must be comprehensive và accessible for API consumers.
```

### 8.10 QUALITY_STANDARDS_SECTION

```markdown
API Quality Checklist:

- [ ] RESTful design với proper HTTP verbs
- [ ] Correct HTTP status codes (200, 201, 400, 401, 404, 500)
- [ ] Content-Type headers set correctly
- [ ] URL conventions: plural nouns, /api/[controller]/[action]
- [ ] Consistent error structure using ProblemDetails
- [ ] Business exceptions với meaningful messages
- [ ] OAuth 2.0/JWT authentication implemented
- [ ] Role-based authorization với [Authorize]
- [ ] Input validation và sanitization
- [ ] HTTPS enforcement
- [ ] Async programming với CancellationToken
- [ ] Constructor dependency injection
- [ ] Clean architecture layer separation
```

### 8.11 WORKFLOWS_MAPPING_SECTION

```markdown
Business workflows to API mapping:

#### Workflow 1: {WorkflowName}

- Use Case: {UseCaseReference}
- API Endpoint: {EndpointMapping}
- HTTP Method: {HTTPMethod}
- Request DTO: {RequestDtoUsed}
- Response DTO: {ResponseDtoUsed}
- Business Rules: {BusinessRulesApplied}

#### {AdditionalWorkflows}

{WorkflowMappings}
```

## 9. VALIDATION RULES

### Technical Validation:

- [ ] Tuân thủ ASP.NET Core API conventions
- [ ] Proper routing và endpoint mapping
- [ ] Consistent DTO naming và structure
- [ ] Global exception handling implemented
- [ ] Async/await pattern correctly used
- [ ] Dependency injection properly configured

### Business Validation:

- [ ] All use cases từ US file được implement
- [ ] API endpoints match Swagger specification
- [ ] Business rules enforcement complete
- [ ] Proper authorization cho sensitive operations
- [ ] Input validation comprehensive
- [ ] Error responses meaningful và consistent

### Code Quality Validation:

- [ ] Complete unit test coverage
- [ ] Integration tests cho critical paths
- [ ] Self-documenting API documentation
- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Clean code principles followed

## 10. EXAMPLE USAGE

```bash
# Input
Feature Name: "UserManagement"
API_Swagger: "docs/DEV/API_Swagger_UserManagement.yaml"
PRD: "docs/BA/PRD_UserManagement_v1.0.md"
SRS: "docs/BA/SRS&DM_UserManagement_v1.0.md"
US: "docs/BA/US_UserManagement_v1.0.md"
ImplementPlan: "docs/DEV/ImplementPlan_UserManagement.md"
CodeConvention: "docs/DEV/CodeConventionDocument_UserManagement.md"
Project Root: "D:/MyABPProject"

# Output Generated
Controller: "Controllers/UserManagement/UserManagementController.cs"
DTOs: "Contracts/UserManagement/DTOs/*.cs"
Contract: "Contracts/UserManagement/IUserManagementAppService.cs"
Tests: "Tests/UserManagement/*Tests.cs"
Documentation: "docs/DEV/Documents_Backend_API_UserManagement.md"
Prompt: "prompts/BACKEND_API_UserManagement_Prompt.md"
```

## 11. EXTENSIBILITY

### Adding New API Patterns:

1. **Extend API_CONTROLLERS_SECTION**
2. **Update API_MODELS_SECTION**
3. **Modify TESTING_SECTION**
4. **Test với existing features**

### Framework Updates:

1. **Update PROJECT_FRAMEWORK_INFO**
2. **Modify API conventions**
3. **Adjust namespace patterns**
4. **Update quality checklist**

### Custom Business Logic Patterns:

1. **Extend WORKFLOWS_MAPPING_SECTION**
2. **Update EXCEPTION_HANDLING_SECTION**
3. **Modify authorization patterns**
4. **Add new validation rules**

**Meta-Prompt Ready** - Sử dụng để generate backend API prompts cho bất kỳ feature nào trong ABP Framework projects với complete RESTful API implementation và comprehensive testing coverage.
