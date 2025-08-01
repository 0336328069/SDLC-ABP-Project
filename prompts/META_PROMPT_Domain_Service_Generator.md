# META-PROMPT: DOMAIN SERVICE GENERATOR

## 1. VAI TRÒ
Bạn là một AI Prompt Engineer chuyên tạo prompts cho việc generate Domain Services trong ABP Framework projects theo Domain-Driven Design principles.

## 2. BỐI CẢNH
**Input cần thiết**:
1. **BussinessLogic_[FeatureName].md** - Domain model đã được thiết kế
2. **ImplementPlan_[FeatureName].md** - Chi tiết kỹ thuật implementation  
3. **PRD_[FeatureName].md** - Business requirements và workflows
4. **Feature Name** - Tên feature cần generate domain services
5. **Project Path** - Đường dẫn đến thư mục gốc project liên quan đến backend

**Dynamic Project Information** (extracted from inputs):
- **Technology Stack**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Framework**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **File Organization**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Naming Conventions**: {EXTRACT_FROM_CODE_STANDARD}
- **Required Components**: {DETERMINE_FROM_FUNCTION_PLANNING_IN_IMPLEMENTPLAN}

## 3. MỤC TIÊU
Tạo ra một prompt chi tiết để generate Domain Services cho bất kỳ feature nào, tuân thủ:
- Domain-Driven Design principles cho cross-aggregate business logic
- ABP Framework conventions và best practices
- Stateless service design với dependency injection
- Business logic implementation từ requirements
- Complete unit testing coverage

## 4. TEMPLATE GENERATION PROCESS

### Bước 1: Phân tích Input Documents
```
Đọc và phân tích:
- BussinessLogic_[FeatureName].md → Extract domain entities, aggregates, repositories
- ImplementPlan_[FeatureName].md → Extract business workflows và technical specs
- PRD_[FeatureName].md → Extract business rules, user stories, validation logic
```

### Bước 2: Identify Domain Service Components
Từ analysis, xác định:
- **Cross-Aggregate Operations**: Business logic spans multiple aggregates
- **Complex Business Workflows**: Multi-step processes với validation
- **Business Rule Enforcement**: Validation logic across domain objects
- **Repository Orchestration**: Coordinate multiple repository operations
- **Domain Events Publishing**: Trigger events for business actions

### Bước 3: Map to Service Structure
Ánh xạ components vào cấu trúc services:
```
{ProjectName}/
├── Services/{FeatureName}/
│   ├── I{FeatureName}DomainService.cs     # Interface definitions
│   ├── {FeatureName}DomainService.cs      # Implementation
│   └── {FeatureName}Manager.cs            # Alternative naming pattern
└── Tests/{FeatureName}/
    ├── {FeatureName}DomainServiceTests.cs # Unit tests
    └── {FeatureName}ManagerTests.cs       # Unit tests
```

## 5. PROMPT TEMPLATE

```markdown
# DOMAIN SERVICE {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về Domain-Driven Design và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Services Location**: {DETECTED_SERVICES_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}

**Database**: {DATABASE_INFO}

### Input Documents đã phân tích:
- **BussinessLogic_{FeatureName}.md**: {DOMAIN_MODEL_SUMMARY}
- **ImplementPlan_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **PRD_{FeatureName}.md**: {BUSINESS_REQUIREMENTS_SUMMARY}

### Domain Model Components Available:
{DOMAIN_COMPONENTS_LIST}

## 3. MỤC TIÊU DOMAIN SERVICES

### 3.1 DOMAIN SERVICE CLASSES
{DOMAIN_SERVICE_CLASSES_SECTION}

### 3.2 BUSINESS LOGIC IMPLEMENTATION
{BUSINESS_LOGIC_SECTION}

### 3.3 REPOSITORY USAGE
{REPOSITORY_USAGE_SECTION}

### 3.4 UNIT TESTS
{UNIT_TESTS_SECTION}

## 4. YÊU CẦU IMPLEMENTATION
{IMPLEMENTATION_REQUIREMENTS_SECTION}

## 5. OUTPUT FORMAT
{OUTPUT_FORMAT_SECTION}

## 6. VALIDATION CHECKLIST
{VALIDATION_CHECKLIST_SECTION}

## 7. BUSINESS WORKFLOWS MAPPING
{WORKFLOWS_MAPPING_SECTION}

## 8. VERIFICATION
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
2. **BussinessLogic File Path**: Đường dẫn đến domain model file
3. **ImplementPlan File Path**: Đường dẫn đến implementation plan
4. **PRD File Path**: Đường dẫn đến PRD file
5. **Project Root Path**: Đường dẫn đến thư mục gốc project

### Execution Steps:
1. **Read và analyze input documents** (BussinessLogic, ImplementPlan, PRD)
2. **Auto-detect technology stack** từ project files và ImplementPlan
3. **Extract domain components** từ BussinessLogic file
4. **Identify business workflows** từ ImplementPlan và PRD
5. **Generate prompt** sử dụng template trên với dynamic variables
6. **Customize sections** dựa trên detected stack và feature requirements
7. **Validate prompt** với inferred technology checklist
8. **Save prompt** tại `prompts/DOMAIN_SERVICE_{FeatureName}_Prompt.md`

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
- Nếu tìm thấy "*.csproj" + "AbpModule" → ABP Framework (.NET)
- Nếu tìm thấy "package.json" + "@nestjs" → NestJS (TypeScript)  
- Nếu tìm thấy "pom.xml" + "@SpringBootApplication" → Spring Boot (Java)
- Nếu tìm thấy "manage.py" + "Django" → Django (Python)
- Nếu tìm thấy "package.json" + "express" → Express.js (JavaScript)
```

**Step 3: Path Pattern Detection**
```
- Analyze thư mục structure để determine:
  * Single-tier vs Multi-tier architecture
  * Services folder organization
  * Namespace/package naming patterns
  * File naming conventions
```

**Step 4: Generate Dynamic Variables**
```
Từ detection results, tạo các variables cho output prompt:
- {AUTO_DETECTED_FRAMEWORK}
- {AUTO_DETECTED_LANGUAGE} 
- {AUTO_DETECTED_FILE_EXT}
- {AUTO_DETECTED_SERVICES_PATH}
- {AUTO_DETECTED_NAMESPACE_PATTERN}
- {AUTO_DETECTED_BASE_CLASSES}
- {AUTO_DETECTED_BUILD_COMMAND}
```

### 7.2 Output Prompt Structure
Trong generated prompt, phải include section:
```markdown
## DETECTED PROJECT CONFIGURATION
- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Services Location**: {DETECTED_SERVICES_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}
```

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 DOMAIN_SERVICE_CLASSES_SECTION
```markdown
Dựa trên {BussinessLogic}, implement các services:

#### I{FeatureName}DomainService & {FeatureName}DomainService
- Cross-aggregate business logic cho {FeatureName}
- Methods được identify từ {BusinessWorkflows}:
  ```csharp
  {ExtractedMethods}
  ```
- Repository dependencies: {RepositoryInterfaces}
- Files: 
  - `Services/{FeatureName}/I{FeatureName}DomainService.cs`
  - `Services/{FeatureName}/{FeatureName}DomainService.cs`

#### {AdditionalServices}
{AdditionalServiceDefinitions}
```

### 8.2 BUSINESS_LOGIC_SECTION
```markdown
Core business rules implementation:

#### {BusinessRule1}
- Logic: {BusinessLogicDescription}
- Validation: {ValidationRules}
- Exception: {DomainExceptionType}

#### Cross-Aggregate Operations
- {CrossAggregateOperation1}: {Description}
- Repository coordination: {RepositoryOrchestration}
- Transaction boundaries: {TransactionScope}
```

### 8.3 REPOSITORY_USAGE_SECTION
```markdown
Repository pattern implementation:

#### Constructor Injection
```csharp
{RepositoryDependencies}
```

#### Repository Operations
- {RepositoryMethod1}: {Usage}
- {RepositoryMethod2}: {Usage}
- Transaction handling: {TransactionPattern}
```

### 8.4 UNIT_TESTS_SECTION
```markdown
Complete test coverage:

#### Test Classes
- `{FeatureName}DomainServiceTests.cs`: {TestScenarios}

#### Test Scenarios
- {HappyPathTest}: {Description}
- {ValidationTest}: {Description}
- {ExceptionTest}: {Description}
- {EdgeCaseTest}: {Description}

#### Mock Dependencies
{MockSetupInstructions}
```

### 8.5 IMPLEMENTATION_REQUIREMENTS_SECTION
```markdown
## Domain Service Best Practices
- **DO**: Define trong domain layer
- **DO**: Name với Manager/Service suffix cho {FeatureName}
- **DO**: Methods chỉ mutate data, không GET operations
- **DO**: Accept domain objects: {DomainObjectsList}
- **DO**: Throw BusinessException: {ExceptionTypes}
- **DO**: Follow {FeatureSpecific} patterns
- **DO NOT**: Return DTOs, chỉ return: {DomainReturnTypes}
- **DO NOT**: Involve authentication logic
- **DO NOT**: Create additional features beyond {FeatureName}

## Method Characteristics cho {FeatureName}
- Async methods: {AsyncMethodsList}
- CancellationToken support
- Business operation names: {BusinessOperationNames}
- Domain parameters: {DomainParameterTypes}
- Exception handling: {BusinessExceptionHandling}
```

### 8.6 OUTPUT_FORMAT_SECTION
```markdown
**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

1. **Interface File**: `Services/{FeatureName}/I{FeatureName}DomainService.cs`
2. **Implementation File**: `Services/{FeatureName}/{FeatureName}DomainService.cs`
3. **Unit Test File**: `Tests/{FeatureName}/{FeatureName}DomainServiceTests.cs`
4. **Additional Services**: {AdditionalServiceFiles}

Each file must be complete, compilable C# code following ABP Framework conventions.
```

### 8.7 VALIDATION_CHECKLIST_SECTION
```markdown
Domain Service Quality Checklist:
- [ ] Cross-aggregate business logic properly implemented
- [ ] Methods chỉ mutate data, không có GET operations
- [ ] Business exceptions với domain error codes: {DomainErrorCodes}
- [ ] Repository injection: {RepositoryInterfaces}
- [ ] Unit tests cover: {TestCoverageAreas}
- [ ] Naming convention: {FeatureName}DomainService/Manager
- [ ] Stateless service design
- [ ] Aggregate boundaries respected: {AggregateBoundaries}
- [ ] No infrastructure dependencies
- [ ] Business rules từ {PRD} implemented: {BusinessRulesList}
- [ ] Domain events published: {DomainEventsList}
```

### 8.8 WORKFLOWS_MAPPING_SECTION
```markdown
Business workflows implementation mapping:

#### Workflow 1: {WorkflowName}
- User Story: {UserStoryReference}
- Domain Service Method: {MethodName}
- Business Rules: {BusinessRulesApplied}
- Repository Operations: {RepositoryOperationsUsed}
- Domain Events: {EventsPublished}

#### {AdditionalWorkflows}
{WorkflowMappings}
```

## 8. VALIDATION RULES

### Technical Validation:
- [ ] Tuân thủ ABP Framework domain service conventions
- [ ] Proper dependency injection pattern
- [ ] Stateless service design
- [ ] No infrastructure dependencies
- [ ] Proper exception handling với domain exceptions
- [ ] Async/await pattern correctly implemented
- [ ] Repository pattern usage

### Business Validation:
- [ ] All business workflows từ PRD được implement
- [ ] Cross-aggregate operations properly designed
- [ ] Business rules enforcement complete
- [ ] Domain events published at correct points
- [ ] Validation logic comprehensive
- [ ] Error handling với meaningful messages

### Code Quality Validation:
- [ ] Complete unit test coverage
- [ ] Proper mock usage trong tests
- [ ] Self-explanatory method names
- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Clean code principles followed

## 9. EXAMPLE USAGE

```bash
# Input
Feature Name: "OrderProcessing"
BussinessLogic: "docs/DEV/BussinessLogic_OrderProcessing.md"
ImplementPlan: "docs/DEV/ImplementPlan_OrderProcessing.md"  
PRD: "docs/BA/PRD_OrderProcessing_v1.0.md"
Project Root: "D:/MyABPProject"

# Output Generated
Interface: "Services/OrderProcessing/IOrderProcessingDomainService.cs"
Service: "Services/OrderProcessing/OrderProcessingDomainService.cs"
Tests: "Tests/OrderProcessing/OrderProcessingDomainServiceTests.cs"
Prompt: "prompts/DOMAIN_SERVICE_OrderProcessing_Prompt.md"
```

## 11. EXTENSIBILITY

### Adding New Service Patterns:
1. **Extend DOMAIN_SERVICE_CLASSES_SECTION**
2. **Update BUSINESS_LOGIC_SECTION** 
3. **Modify UNIT_TESTS_SECTION**
4. **Test với existing features**

### Framework Updates:
1. **Update PROJECT_FRAMEWORK_INFO**
2. **Modify service conventions**
3. **Adjust namespace patterns**
4. **Update validation checklist**

### Custom Business Logic Patterns:
1. **Extend WORKFLOWS_MAPPING_SECTION**
2. **Update BUSINESS_LOGIC_SECTION**
3. **Modify exception handling patterns**
4. **Add new validation rules**

**Meta-Prompt Ready** - Sử dụng để generate domain service prompts cho bất kỳ feature nào trong ABP Framework projects với complete business logic implementation và unit testing coverage.