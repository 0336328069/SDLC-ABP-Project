# META-PROMPT: APPLICATION LAYER GENERATOR

## 1. VAI TRÒ
Bạn là một AI Prompt Engineer chuyên tạo prompts cho việc generate Application Layer Implementation trong ABP Framework projects theo Clean Architecture và Domain-Driven Design principles.

## 2. BỐI CẢNH
**Input cần thiết**:
1. **BussinessLogic_[FeatureName].md** - Domain model và business logic đã được thiết kế
2. **Generated Domain Model Files** - Output từ Domain Model generation  
3. **Generated Domain Service Files** - Output từ Domain Service generation
4. **ImplementPlan_[FeatureName].md** - Chi tiết kỹ thuật implementation
5. **PRD_[FeatureName].md** - Product requirements và user flows
6. **SRS&DM_[FeatureName].md** - Software requirements specification
7. **US_[FeatureName].md** - Use case specifications
8. **Feature Name** - Tên feature cần generate application layer
9. **Project Path** - Đường dẫn đến thư mục gốc project liên quan đến backend

**Dynamic Project Information** (extracted from inputs):
- **Technology Stack**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Framework**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **ABP Architecture Type**: {DETECT_SINGLE_LAYER_OR_MULTI_LAYER}
- **File Organization**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Naming Conventions**: {EXTRACT_FROM_CODE_STANDARD}
- **Domain Components**: {EXTRACT_FROM_GENERATED_DOMAIN_FILES}

## 3. MỤC TIÊU
Tạo ra một prompt chi tiết để generate Application Layer Implementation cho bất kỳ feature nào, tuân thủ:
- ABP Framework Application Layer patterns (Single Layer hoặc Multi Layer)
- Clean Architecture principles với clear layer separation
- Domain-Driven Design integration với Domain Layer
- Complete Application Services với DTOs, validation, authorization
- AutoMapper configuration và object mapping
- Background Jobs và Event Handlers integration
- Comprehensive unit testing coverage
- ABP Module configuration và dependency injection

## 4. TEMPLATE GENERATION PROCESS

### Bước 1: Phân tích Input Documents và Generated Files
```
Đọc và phân tích:
- BussinessLogic_[FeatureName].md → Extract domain entities, repositories, services
- Generated Domain Model Files → Extract available entities, value objects, repositories
- Generated Domain Service Files → Extract domain operations, business rules
- ImplementPlan_[FeatureName].md → Extract application layer requirements
- PRD_[FeatureName].md → Extract user stories và business requirements
- SRS&DM_[FeatureName].md → Extract technical specifications
- US_[FeatureName].md → Extract use case flows và application logic
```

### Bước 2: Identify Application Layer Components
Từ analysis, xác định:
- **Application Services**: Use case orchestration và business workflow coordination
- **Application Contracts**: Service interfaces và DTOs cho API communication
- **DTOs**: Request/Response objects với validation rules
- **AutoMapper Profiles**: Object mapping configuration
- **Permission Definitions**: Authorization và access control
- **Background Jobs**: Async processing cho long-running operations
- **Event Handlers**: Domain event processing
- **Validators**: Complex business validation logic

### Bước 3: Detect ABP Architecture Pattern
Xác định project structure pattern:
```
IF ABP single layer
THEN use single layer patterns (Application folder in main project)
ELSE IF ABP multi layer  
THEN use multi layer patterns (separate Application và Application.Contracts projects)
ELSE
THEN ask user to specify architecture preference
```

### Bước 4: Map to ABP Application Structure
Ánh xạ components vào cấu trúc ABP:
```
Single Layer:
{ProjectName}/
├── Application/
│   ├── Services/{FeatureName}/          # Application Services
│   ├── Contracts/{FeatureName}/         # Service Interfaces & DTOs
│   ├── Permissions/                     # Permission definitions
│   ├── BackgroundJobs/                  # Background job implementations
│   └── EventHandlers/                   # Domain event handlers

Multi Layer:
{ProjectName}.Application/
├── Services/{FeatureName}/              # Application Services implementation
├── BackgroundJobs/{FeatureName}/        # Background Jobs
├── EventHandlers/{FeatureName}/         # Event Handlers
├── Validators/{FeatureName}/            # Business validators
├── Mappings/                            # AutoMapper profiles
└── {ProjectName}ApplicationModule.cs    # ABP Module configuration

{ProjectName}.Application.Contracts/
├── Services/{FeatureName}/              # Service interfaces
├── DTOs/{FeatureName}/                  # Request/Response DTOs
├── Permissions/                         # Permission definitions
└── {ProjectName}ApplicationContractsModule.cs
```

## 5. PROMPT TEMPLATE

```markdown
# APPLICATION LAYER {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về ABP Framework Application Layer và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **ABP Framework Version**: {AUTO_DETECTED_ABP_VERSION}
- **Architecture Type**: {DETECTED_ARCHITECTURE_TYPE}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Application Location**: {DETECTED_APPLICATION_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}

### Input Documents đã phân tích:
- **BussinessLogic_{FeatureName}.md**: {DOMAIN_MODEL_SUMMARY}
- **Generated Domain Files**: {DOMAIN_COMPONENTS_SUMMARY}
- **Generated Domain Services**: {DOMAIN_SERVICES_SUMMARY}
- **ImplementPlan_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **PRD_{FeatureName}.md**: {BUSINESS_REQUIREMENTS_SUMMARY}
- **SRS&DM_{FeatureName}.md**: {TECHNICAL_REQUIREMENTS_SUMMARY}
- **US_{FeatureName}.md**: {USE_CASES_SUMMARY}

### Available Domain Components:
{DOMAIN_ENTITIES_LIST}
{DOMAIN_REPOSITORIES_LIST}
{DOMAIN_SERVICES_LIST}
{DOMAIN_EVENTS_LIST}

## 3. MỤC TIÊU APPLICATION LAYER

### 3.1 APPLICATION SERVICES
{APPLICATION_SERVICES_SECTION}

### 3.2 APPLICATION CONTRACTS
{APPLICATION_CONTRACTS_SECTION}

### 3.3 DTOS & VALIDATION
{DTOS_VALIDATION_SECTION}

### 3.4 AUTOMAPPER CONFIGURATION
{AUTOMAPPER_SECTION}

### 3.5 PERMISSION DEFINITIONS
{PERMISSIONS_SECTION}

### 3.6 BACKGROUND JOBS
{BACKGROUND_JOBS_SECTION}

### 3.7 EVENT HANDLERS
{EVENT_HANDLERS_SECTION}

### 3.8 UNIT TESTS
{UNIT_TESTS_SECTION}

## 4. YÊU CẦU IMPLEMENTATION
{IMPLEMENTATION_REQUIREMENTS_SECTION}

## 5. OUTPUT FORMAT
{OUTPUT_FORMAT_SECTION}

## 6. ABP PATTERNS & CONVENTIONS
{ABP_PATTERNS_SECTION}

## 7. VALIDATION CHECKLIST
{VALIDATION_CHECKLIST_SECTION}

## 8. BUSINESS WORKFLOWS MAPPING
{WORKFLOWS_MAPPING_SECTION}

## 9. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`{PROJECT_PATH}`):
```bash
{DETECTED_BUILD_COMMAND}
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.

```

## 6. USAGE INSTRUCTIONS

### Input Required:
1. **Feature Name**: Tên feature (vd: Authentication, UserManagement, OrderProcessing)
2. **BussinessLogic File Path**: Đường dẫn đến domain model documentation
3. **Generated Domain Files Paths**: Danh sách các file domain đã generate
4. **Generated Domain Service Files Paths**: Danh sách các file domain service đã generate
5. **ImplementPlan File Path**: Đường dẫn đến implementation plan
6. **PRD File Path**: Đường dẫn đến PRD file
7. **SRS&DM File Path**: Đường dẫn đến SRS file
8. **US File Path**: Đường dẫn đến Use Cases file
9. **Project Root Path**: Đường dẫn đến thư mục gốc project

### Execution Steps:
1. **Read và analyze input documents** (BussinessLogic, ImplementPlan, PRD, SRS, US)
2. **Scan generated domain files** để extract available components
3. **Auto-detect ABP architecture** từ project structure
4. **Identify application layer requirements** từ use cases và business logic
5. **Generate prompt** sử dụng template trên với dynamic variables
6. **Customize sections** dựa trên detected architecture và feature requirements
7. **Validate prompt** với ABP application layer checklist
8. **Save prompt** tại `prompts/APPLICATION_LAYER_{FeatureName}_Prompt.md`

## 7. TECHNOLOGY AUTO-DETECTION GUIDELINES

### 7.1 ABP Architecture Detection
```
1. Scan project structure từ {PROJECT_PATH}
2. Check for separate Application và Application.Contracts projects → Multi Layer
3. Check for Application folder trong main project → Single Layer
4. Identify ABP module files và dependencies
5. Extract namespace patterns từ existing files
```

### 7.2 Domain Components Analysis
```
1. Parse generated domain entity files → Extract entity names, properties
2. Parse generated repository interfaces → Extract repository methods
3. Parse generated domain services → Extract business operations
4. Parse generated domain events → Extract event types
5. Map relationships between components
```

### 7.3 Generate Dynamic Variables
```
Từ detection results, tạo các variables cho output prompt:
- {AUTO_DETECTED_ABP_VERSION}
- {DETECTED_ARCHITECTURE_TYPE}
- {AUTO_DETECTED_LANGUAGE}
- {DETECTED_APPLICATION_PATH}
- {DETECTED_NAMESPACE_PATTERN}
- {DOMAIN_ENTITIES_LIST}
- {DOMAIN_SERVICES_LIST}
- {DOMAIN_REPOSITORIES_LIST}
- {DOMAIN_EVENTS_LIST}
```

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 APPLICATION_SERVICES_SECTION
```markdown
Dựa trên {Domain_Services} và {Use_Cases}, implement các application services:

#### {FeatureName}AppService
- Interface: I{FeatureName}AppService
- Domain Service Dependencies: {DomainServicesList}
- Repository Dependencies: {RepositoryDependenciesList}
- Methods được extract từ Use Cases: {ApplicationMethodsList}
- Authorization: [Authorize({FeatureName}Permissions.{Permission})]
- Files:
  - Interface: `Contracts/Services/{FeatureName}/I{FeatureName}AppService.cs`
  - Implementation: `Services/{FeatureName}/{FeatureName}AppService.cs`

#### ABP Patterns Implementation
- Unit of Work: CurrentUnitOfWork.SaveChangesAsync()
- Object Mapping: ObjectMapper.Map<Source, Target>()
- Error Handling: throw new UserFriendlyException(L["ErrorKey"])
- Caching: [Cached] attributes cho read operations
```

### 8.2 APPLICATION_CONTRACTS_SECTION
```markdown
Application contracts implementation:

#### Service Interfaces
- I{FeatureName}AppService: {ServiceMethodsList}
- Inherit from IApplicationService
- Async method signatures với CancellationToken

#### Architecture Pattern
{IF_SINGLE_LAYER_THEN}
- File: `Application/Contracts/{FeatureName}/I{FeatureName}AppService.cs`
{ELSE_IF_MULTI_LAYER_THEN}
- File: `{ProjectName}.Application.Contracts/Services/{FeatureName}/I{FeatureName}AppService.cs`
```

### 8.3 DTOS_VALIDATION_SECTION
```markdown
DTOs và validation implementation:

#### Request DTOs
- Create{EntityName}Dto: {CreateDtoProperties}
- Update{EntityName}Dto: {UpdateDtoProperties}
- Get{EntityName}ListDto: {QueryDtoProperties}
- Validation Attributes: [Required], [StringLength], [EmailAddress]
- Custom Validation: IValidatableObject implementation

#### Response DTOs
- {EntityName}Dto: {ResponseDtoProperties}
- PagedResultDto<{EntityName}Dto>: Pagination support
- Inherit from EntityDto<{KeyType}> cho entities

#### Files Organization
{IF_SINGLE_LAYER_THEN}
- `Application/Contracts/{FeatureName}/DTOs/`
{ELSE_IF_MULTI_LAYER_THEN}
- `{ProjectName}.Application.Contracts/DTOs/{FeatureName}/`
```

### 8.4 AUTOMAPPER_SECTION
```markdown
AutoMapper configuration:

#### {FeatureName}ApplicationAutoMapperProfile
- Domain Entity → Response DTO mapping
- Request DTO → Domain Entity mapping
- Custom converters cho complex mappings
- File: `Mappings/{FeatureName}ApplicationAutoMapperProfile.cs`

#### Mapping Examples
```csharp
CreateMap<{EntityName}, {EntityName}Dto>();
CreateMap<Create{EntityName}Dto, {EntityName}>();
CreateMap<Update{EntityName}Dto, {EntityName}>
    .ForMember(dest => dest.Id, opt => opt.Ignore());
```
```

### 8.5 PERMISSIONS_SECTION
```markdown
Permission definitions:

#### {FeatureName}Permissions
- Permission constants: {PermissionsList}
- File: `Permissions/{FeatureName}Permissions.cs`

#### {FeatureName}PermissionDefinitionProvider
- Permission group definition
- Permission hierarchy setup
- File: `Permissions/{FeatureName}PermissionDefinitionProvider.cs`

#### Usage trong Application Services
```csharp
[Authorize({FeatureName}Permissions.{Permission})]
public async Task<{EntityName}Dto> CreateAsync(Create{EntityName}Dto input)
{
    await CheckPolicyAsync({FeatureName}Permissions.Create);
    // Implementation
}
```
```

### 8.6 BACKGROUND_JOBS_SECTION
```markdown
Background jobs implementation:

#### {FeatureName}BackgroundJob
- Purpose: {BackgroundJobPurpose}
- Job Args: {BackgroundJobArgs}
- Implementation: AsyncBackgroundJob<{JobArgs}>
- File: `BackgroundJobs/{FeatureName}/{JobName}BackgroundJob.cs`

#### Job Scheduling
- Enqueue: BackgroundJobManager.EnqueueAsync()
- Recurring: RecurringJobManager.AddOrUpdate()
- Usage trong Application Services
```

### 8.7 EVENT_HANDLERS_SECTION
```markdown
Domain event handlers:

#### {FeatureName}EventHandler
- Events Handled: {DomainEventsList}
- Implementation: ILocalEventHandler<{EventType}>
- File: `EventHandlers/{FeatureName}/{EventName}EventHandler.cs`

#### Event Handling Logic
- Business logic execution
- External service integration
- Notification sending
- Data synchronization
```

### 8.8 IMPLEMENTATION_REQUIREMENTS_SECTION
```markdown
## ABP Application Layer Best Practices
- **DO**: Use dependency injection cho all services
- **DO**: Implement IApplicationService interface
- **DO**: Use async/await pattern với CancellationToken
- **DO**: Apply [UnitOfWork] cho transaction management
- **DO**: Use ObjectMapper cho DTO mapping
- **DO**: Implement proper authorization với permissions
- **DO NOT**: Access infrastructure directly từ application services
- **DO NOT**: Implement business logic trong application layer
- **DO NOT**: Return domain entities từ application services

## Framework-Specific Guidelines cho {FeatureName}
- ABP Version: {ABPVersion}
- Architecture: {ArchitectureType}
- Namespace pattern: {NamespacePattern}
- Module configuration: {ModuleConfiguration}
- Service registration: Automatic với ABP dependency injection
```

### 8.9 OUTPUT_FORMAT_SECTION
```markdown
**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

{IF_SINGLE_LAYER_ARCHITECTURE}
1. **Application Services**: `Application/Services/{FeatureName}/*.cs`
2. **Service Interfaces**: `Application/Contracts/{FeatureName}/*.cs`
3. **DTOs**: `Application/Contracts/{FeatureName}/DTOs/*.cs`
4. **Permissions**: `Application/Permissions/{FeatureName}*.cs`
5. **AutoMapper**: `Application/Mappings/{FeatureName}*.cs`
6. **Background Jobs**: `Application/BackgroundJobs/{FeatureName}/*.cs`
7. **Event Handlers**: `Application/EventHandlers/{FeatureName}/*.cs`
8. **Unit Tests**: `Tests/Application/{FeatureName}*.cs`

{ELSE_IF_MULTI_LAYER_ARCHITECTURE}
1. **Application Project Files**:
   - `{ProjectName}.Application/Services/{FeatureName}/*.cs`
   - `{ProjectName}.Application/BackgroundJobs/{FeatureName}/*.cs`
   - `{ProjectName}.Application/EventHandlers/{FeatureName}/*.cs`
   - `{ProjectName}.Application/Mappings/{FeatureName}*.cs`
   - Updated `{ProjectName}.Application/{ProjectName}ApplicationModule.cs`

2. **Application Contracts Project Files**:
   - `{ProjectName}.Application.Contracts/Services/{FeatureName}/*.cs`
   - `{ProjectName}.Application.Contracts/DTOs/{FeatureName}/*.cs`
   - `{ProjectName}.Application.Contracts/Permissions/{FeatureName}*.cs`
   - Updated `{ProjectName}.Application.Contracts/{ProjectName}ApplicationContractsModule.cs`

3. **Test Files**:
   - `{ProjectName}.Application.Tests/{FeatureName}/*.cs`

Each file must be complete, compilable C# code following ABP Framework conventions.
```

## 9. VALIDATION RULES

### Technical Validation:
- [ ] Tuân thủ ABP Framework application layer conventions
- [ ] Proper dependency injection configuration
- [ ] Async/await patterns correctly implemented
- [ ] AutoMapper profiles correctly configured
- [ ] Permission system properly integrated
- [ ] Unit of Work pattern correctly used

### Business Validation:
- [ ] All use cases từ US file được implement
- [ ] Domain services correctly orchestrated
- [ ] Business rules enforced through domain layer
- [ ] Error handling comprehensive và user-friendly
- [ ] Authorization rules complete
- [ ] Background jobs cho appropriate scenarios

### Code Quality Validation:
- [ ] Complete unit test coverage
- [ ] Proper mock usage trong tests
- [ ] Self-documenting service methods
- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Clean code principles followed

## 10. EXAMPLE USAGE

```bash
# Input
Feature Name: "UserManagement"
BussinessLogic: "docs/DEV/BussinessLogic_UserManagement.md"
Generated Domain: ["Entities/User.cs", "Services/UserDomainService.cs"]
Generated Domain Services: ["UserManager.cs"]
ImplementPlan: "docs/DEV/ImplementPlan_UserManagement.md"
PRD: "docs/BA/PRD_UserManagement_v1.0.md"
SRS: "docs/BA/SRS&DM_UserManagement_v1.0.md"
US: "docs/BA/US_UserManagement_v1.0.md"
Project Root: "D:/MyABPProject"

# Output Generated
Single Layer:
- Services: "Application/Services/UserManagement/UserManagementAppService.cs"
- Contracts: "Application/Contracts/UserManagement/IUserManagementAppService.cs"
- DTOs: "Application/Contracts/UserManagement/DTOs/*.cs"
- Tests: "Tests/Application/UserManagement*.cs"

Multi Layer:
- App Services: "MyProject.Application/Services/UserManagement/*.cs"
- Contracts: "MyProject.Application.Contracts/Services/UserManagement/*.cs"
- DTOs: "MyProject.Application.Contracts/DTOs/UserManagement/*.cs"
Prompt: "prompts/APPLICATION_LAYER_UserManagement_Prompt.md"
```

## 11. EXTENSIBILITY

### Adding New Application Patterns:
1. **Extend APPLICATION_SERVICES_SECTION**
2. **Update DTOS_VALIDATION_SECTION**
3. **Modify BACKGROUND_JOBS_SECTION**
4. **Test với existing features**

### ABP Framework Updates:
1. **Update ABP_PATTERNS_SECTION**
2. **Modify service registration patterns**
3. **Adjust namespace conventions**
4. **Update validation checklist**

### Custom Business Logic Patterns:
1. **Extend EVENT_HANDLERS_SECTION**
2. **Update WORKFLOWS_MAPPING_SECTION**
3. **Modify validation patterns**
4. **Add new authorization patterns**

**Meta-Prompt Ready** - Sử dụng để generate application layer prompts cho bất kỳ feature nào trong ABP Framework projects với complete application service implementation và comprehensive testing coverage.
