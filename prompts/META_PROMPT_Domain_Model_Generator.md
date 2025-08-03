# META-PROMPT: DOMAIN MODEL GENERATOR

## 1. VAI TRÒ

Bạn là một AI Prompt Engineer. Nhiệm vụ của bạn là **tạo ra một prompt khác** (dựa trên mẫu ở Mục 5) để một AI khác (vai trò Senior Software Architect) có thể sử dụng để generate code cho Domain Model. **Nhiệm vụ của bạn KHÔNG phải là generate code trực tiếp.**

## 2. BỐI CẢNH

**Input cần thiết**:

1. **ImplementPlan\_[FeatureName].md** - Chi tiết kỹ thuật implementation
2. **PRD\_[FeatureName].md** - Product requirements và user flows
3. **Code Standard Analysis** - Cấu trúc và conventions hiện tại từ codebase
4. **Feature Name** - Tên feature cần tạo domain model
5. **Project Path** - Đường dẫn đến thư mục gốc project liên quan đến backend. Trong thư mục đã có sẵn dự án.
6. **Structure template** - (ABP single-layer hoặc multi-layer)

```

IF ABP singel layer
THEN read ABP_SingleLayer_DDD_FolderStructure.md
ELSE IF ABP mutil layer
THEN read ABP_MultiLayer_FolderStructure.md
ELSE
THEN ask user to specify architecture preference

```

**Dynamic Project Information** (tự động extract):

- **Technology Stack**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Framework**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **File Organization**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Naming Conventions**: {EXTRACT_FROM_CODE_STANDARD}
- **Required Components**: {DETERMINE_FROM_FUNCTION_PLANNING_IN_IMPLEMENTPLAN}

## 3. MỤC TIÊU

**Mục tiêu chính của bạn** Tạo tệp prompt `DOMAIN_MODEL_{FeatureName}_Prompt.md` để:

- Generate code files (entities, value objects, repository interfaces, specifications, events)
- Tạo tài liệu: domain model overview và BUSINESSLOGIC\_{FeatureName}.md

_Lưu ý: Bạn chỉ tạo ra prompt, không tạo ra code._

## 4. QUY TRÌNH TẠO PROMPT (Dành cho bạn - AI Prompt Engineer)

### Bước 1: Phân tích Input Documents

```
Autodetect và extract từ inputs:
- ImplementPlan_[FeatureName].md → Technical requirements, architecture patterns, framework references
- PRD_[FeatureName].md → Business rules và user flows
- Project Path → Actual codebase files để infer technology stack
- Code Standard Analysis → File patterns, naming conventions, folder structure
```

### Bước 2: Identify Domain Components

Từ analysis, xác định các thành phần sau cho Domain Model:

- **Aggregate Roots**: Main entities với business identity
- **Entities**: Child entities thuộc aggregates
- **Value Objects**: Immutable objects với business logic
- **Repository Interfaces**: Data access abstractions
- **Domain Events**: Important business actions
- **Specifications**: Query optimization patterns

### Bước 3: Map to Project Structure

Ánh xạ components vào cấu trúc project (ví dụ):

```

{ProjectName}/
├── Entities/{FeatureName}/ # Domain entities
├── Entities/{FeatureName}/Specifications/ # Query specifications
├── Domain.Shared/{FeatureName}/Events/ # Domain events
└── Data/{FeatureName}/ # EF configurations

```

## 5. PROMPT TEMPLATE (Đây là mẫu để bạn tạo ra prompt mới)

````markdown
# DOMAIN MODEL {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 0. PRE-VALIDATION

Kiểm tra cơ bản trước khi generate:

```bash
  cd "{PROJECT_PATH}"
  {DETECTED_BUILD_COMMAND}
  if [ $? -ne 0 ]; then
    echo "❌ BUILD FAILED - Fix errors first"
    exit 1
  fi
```

## 1. VAI TRÒ

Bạn là một Senior Software Architect chuyên về Domain-Driven Design và ABP Framework.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:

- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Domain Location**: {DETECTED_DOMAIN_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}

**Database**: {DATABASE_INFO}

### Input Documents đã phân tích:

- **ImplementPlan\_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **PRD\_{FeatureName}.md**: {REQUIREMENTS_SUMMARY}
- **Codebase Analysis**: {CODEBASE_STRUCTURE_SUMMARY}

### Cấu trúc Code hiện tại:

```

{CURRENT_PROJECT_STRUCTURE}

```

### Conventions được sử dụng:

{PROJECT_CONVENTIONS_LIST}

## 3. MỤC TIÊU DOMAIN MODEL

Tạo các thành phần cốt lõi của Domain Model. _Lưu ý: Domain Services không thuộc phạm vi của prompt này._

### 3.1 AGGREGATE ROOTS & ENTITIES

{AGGREGATE_ROOTS_SECTION}

### 3.2 VALUE OBJECTS

{VALUE_OBJECTS_SECTION}

### 3.3 REPOSITORY INTERFACES

{REPOSITORY_INTERFACES_SECTION}

### 3.4 SPECIFICATION PATTERN

{SPECIFICATIONS_SECTION}

### 3.5 DOMAIN EVENTS

{DOMAIN_EVENTS_SECTION}

## 4. YÊU CẦU KỸ THUẬT

{ENHANCED_TECHNICAL_REQUIREMENTS_SECTION}

## 5. ĐỊNH DẠNG OUTPUT

{OUTPUT_FORMAT_SECTION}

## 6. BUSINESS LOGIC DOCUMENTATION

Tạo file `Businesslogic_{FeatureName}.md` với nội dung:

### 6.1 Domain Invariants Documentation

Trong file `Businesslogic_{FeatureName}.md`, PHẢI bao gồm:

#### Aggregate Invariants

- List all business rules that MUST always be true
- Specify which aggregate root enforces each invariant
- Document validation triggers and exception scenarios

#### Entity Consistency Rules

- Define relationships between entities within aggregates
- Specify cascade behaviors and referential integrity rules
- Document state transition validations

#### Value Object Constraints

- List all validation rules for each value object
- Specify format requirements and business constraints
- Document immutability guarantees and equality rules

### 6.2 Domain Event Scenarios

**REQUIRED**: Document when and why domain events are triggered:

#### Event Trigger Conditions

- Business operations that generate events
- State changes that require notification
- Integration points requiring event publishing

#### Event Data Consistency

- What data is included in each event
- How event data relates to aggregate state
- Ordering guarantees for multiple events

## 7. VALIDATION CHECKLIST

### Domain Design Validation

- [ ] **Aggregate Boundaries**: Each aggregate has single responsibility
- [ ] **Consistency Boundaries**: Business rules enforced within aggregates
- [ ] **Domain Events**: Published for all significant business actions
- [ ] **Value Objects**: Used for all complex data types with validation
- [ ] **Specifications**: Implemented for complex query logic

### ABP Framework Compliance

- [ ] **Base Classes**: All entities inherit from correct ABP base classes
- [ ] **Validation Attributes**: Data annotations applied where appropriate
- [ ] **Domain Exceptions**: Custom exceptions for business rule violations
- [ ] **Localization**: Error messages support multiple languages
- [ ] **Auditing**: Creation/modification tracking implemented

### Integration Preparedness

- [ ] **Dependency Injection**: All services can be registered in DI container
- [ ] **Serialization**: Domain events can be serialized/deserialized
- [ ] **EF Core Mapping**: Entities compatible with Entity Framework
- [ ] **Performance**: No N+1 queries or expensive operations in domain logic
- [ ] **Security**: No sensitive data exposure in public interfaces

### Testing Coverage

- [ ] **Unit Tests**: 100% coverage for business rules and invariants
- [ ] **Integration Tests**: Repository and specification patterns tested
- [ ] **Property-Based Tests**: Domain rules tested with random inputs
- [ ] **Scenario Tests**: Complex business workflows validated
- [ ] **Performance Tests**: Domain operations meet performance criteria

## 8. CONTEXT TỪNG USER STORY

{USER_STORIES_MAPPING_SECTION}

## 9. MANDATORY TESTING GATES

{ENHANCED_TESTING_GATES_SECTION}

## 10. PRE-INTEGRATION VALIDATION

{INTEGRATION_READY_SECTION}
**[END OF TEMPLATE]**

```

## 6. HƯỚNG DẪN THỰC THI (Dành cho bạn - AI Prompt Engineer)

### Input Required:
1. **Feature Name**: Tên feature (vd: Authentication, UserManagement, Reporting)
2. **ImplementPlan File Path**: Đường dẫn đến file implementation plan
3. **PRD File Path**: Đường dẫn đến file PRD
4. **Code Standard Analysis**: Analysis của codebase structure và conventions
5. **Project Root Path**: Đường dẫn đến thư mục gốc project

### Execution Steps:
1. **Read và analyze input documents** (ImplementPlan, PRD, Code Standard).
2. **Auto-detect technology stack** từ ImplementPlan và project files.
3. **Infer framework patterns** dựa trên detected technology.
4. **Extract codebase conventions** từ Code Standard Analysis.
5. **Map function planning** từ ImplementPlan để determine required components.
6. **Sử dụng "PROMPT TEMPLATE" (Mục 5) để điền các thông tin đã phân tích vào**.
7. **Customize các section** trong template theo detected stack và feature requirements.
8. **Validate prompt** với inferred technology checklist.
9. **Lưu prompt hoàn chỉnh** tại `prompts/DOMAIN_MODEL_{FeatureName}_Prompt.md`. **Đây là output duy nhất của bạn.**

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
- Domain folder organization
- Namespace/package naming patterns
- File naming conventions

```

**Step 4: Generate Dynamic Variables**
```

Từ detection results, tạo các variables cho output prompt:

- {AUTO_DETECTED_FRAMEWORK}
- {AUTO_DETECTED_LANGUAGE}
- {AUTO_DETECTED_FILE_EXT}
- {AUTO_DETECTED_ENTITY_PATH}
- {AUTO_DETECTED_NAMESPACE_PATTERN}
- {AUTO_DETECTED_BASE_CLASSES}
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
- **Domain Location**: {DETECTED_DOMAIN_PATH}
- **Namespace Pattern**: {DETECTED_NAMESPACE_PATTERN}
- **Build Command**: {DETECTED_BUILD_COMMAND}
```

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 AGGREGATE_ROOTS_SECTION

```markdown
Dựa trên {ImplementPlan}, cần tạo:

#### {EntityName} (Aggregate Root)

- Primary Key: `{KeyType} {KeyName}`
- Properties theo {ERD/Requirements}:
  - `{PropertyType} {PropertyName}` ({Description})
- Audit: Implement `{AuditInterface}`
- Namespace: `{ProjectNamespace}.{FeatureName}`
- File: `{AUTO_DETECTED_ENTITY_PATH}/{FeatureName}/{EntityName}{AUTO_DETECTED_FILE_EXT}`
```

### 8.2 VALUE_OBJECTS_SECTION

```markdown
#### {ValueObjectName}

- Encapsulate logic {BusinessLogicDescription}
- Properties: `{PropertyType} {PropertyName}`
- Methods: `{Method1}()`, `{Method2}()`
- File: `{AUTO_DETECTED_VALUE_OBJECT_PATH}/{FeatureName}/ValueObjects/{ValueObjectName}{AUTO_DETECTED_FILE_EXT}`
```

### 8.3 REPOSITORY_INTERFACES_SECTION

````markdown
#### I{EntityName}Repository

- Kế thừa từ `IRepository<{EntityName}, {KeyType}>`
- Methods cần thiết:
  ```
  {AUTO_DETECTED_LANGUAGE_FOR_CODE_BLOCKS}
  {MethodSignatures}
  ```
- File: `{AUTO_DETECTED_REPOSITORY_PATH}/{FeatureName}/I{EntityName}Repository{AUTO_DETECTED_FILE_EXT}`
````

### 8.4 SPECIFICATIONS_SECTION

```markdown
Tạo các Specification classes để optimize queries:

#### {SpecificationName}

- {SpecificationDescription}
- File: `{AUTO_DETECTED_QUERY_PATH}/{FeatureName}/Specifications/{SpecificationName}{AUTO_DETECTED_FILE_EXT}`
```

### 8.5 DOMAIN_EVENTS_SECTION

```markdown
#### {EventName}

- Trigger khi {EventTriggerCondition}
- Properties: {EventProperties}
- File: `{AUTO_DETECTED_EVENT_PATH}/{FeatureName}/Events/{EventName}{AUTO_DETECTED_FILE_EXT}`
```

### 8.6 OUTPUT_FORMAT_SECTION

```markdown
### OUTPUT REQUIREMENTS

#### Code Files

Tạo tất cả các file code theo structure đã định nghĩa:

1. **Entities**: Aggregate roots và child entities
2. **Value Objects**: Business logic encapsulation
3. **Repository Interfaces**: Data access abstractions
4. **Specifications**: Query optimization patterns
5. **Domain Events**: Business event definitions

#### Documentation Files

1. **`Businesslogic_{FeatureName}.md`**: Chi tiết business logic và rules
   - Location: `docs/DEV/Businesslogic_{FeatureName}.md`
   - Content: Business rules, entity behaviors, workflows, invariants
2. **Domain Model Overview**: Tổng quan về domain model được tạo

#### File Organization

- Tuân thủ project structure đã detect
- Sử dụng correct namespaces và naming conventions
- Include proper using statements và dependencies
```

### 8.7 ENHANCED_TECHNICAL_REQUIREMENTS_SECTION

Phần này tương ứng với “## 4. ENHANCED TECHNICAL REQUIREMENTS” trong Prompt Template.

Mục đích: Yêu cầu kỹ thuật tổng hợp cho code generation và document generation.

#### Nội dung chi tiết:

1. Code Generation Requirements

   - Tất cả file phải compile thành công (C# .NET).
   - Sử dụng naming conventions từ Code Standard Analysis.
   - Thư mục đầu ra theo cấu trúc project: `{ProjectPath}/Entities/{FeatureName}`, v.v.
   - Include proper using statements và dependencies.

2. Documentation Requirements

   - Tạo Businesslogic\_{FeatureName}.md tại `docs/DEV/`.
   - Mỗi business rule ghi rõ:
     - Tên rule
     - Điều kiện trigger
     - Hành động và exception nếu vi phạm
   - Liệt kê domain events và mô tả trigger.

3. Basic Validation Requirements
   - Validate invariants trong constructors (null, empty, range).
   - Validate property setters với business rules.
   - Sử dụng value objects cho dữ liệu phức tạp có validation.

Ví dụ cho placeholder `{ENHANCED_TECHNICAL_REQUIREMENTS_SECTION}`:

```
## 4. ENHANCED TECHNICAL REQUIREMENTS
Code Generation Requirements
Ensure all generated C# classes compile under .NET 6.

Follow PascalCase naming for classes and methods.

Place Entities in Entities/{FeatureName}/, ValueObjects in Entities/{FeatureName}/ValueObjects/.

Add necessary using directives and dependency injections.

Documentation Requirements
Generate docs/DEV/BUSINESSLOGIC_{FeatureName}.md containing:

RuleName: Description, trigger, exception type.

Domain events list with trigger scenarios.

Basic Validation Requirements
Constructor guard clauses for null/empty string.

Property setters enforce range and format.

Complex fields wrapped as ValueObjects with internal validation.
```

### 8.8 ENHANCED_TESTING_GATES_SECTION

Phần này tương ứng với “## 9. ENHANCED TESTING GATES” trong Prompt Template.

Mục đích: Quy định các quality gates cơ bản, fail-fast.

#### Nội dung chi tiết:

1. Build Verification

```bash
  cd "{PROJECT_PATH}"
  {DETECTED_BUILD_COMMAND}
  if [ $? -ne 0 ]; then
  echo "❌ BUILD FAILED"; exit 1
  fi
```

2. Unit Test Gate

```bash
dotnet test --filter "Category=Domain"
if [ $? -ne 0 ]; then
echo "❌ UNIT TESTS FAILED"; exit 1
fi
```

3. Code Coverage Check

- Require ≥80% coverage for domain layer.

4. Repository & Event Validation

- Confirm repository interfaces exist.
- Ensure domain events classes compile.

Ví dụ cho placeholder `{ENHANCED_TESTING_GATES_SECTION}`:

```
9. ENHANCED TESTING GATES
Gate 1: Build Verification
bash
cd "{PROJECT_PATH}"
{DETECTED_BUILD_COMMAND}
Gate 2: Unit Tests
bash
dotnet test --filter "Category=Domain"
Gate 3: Coverage
Domain layer coverage ≥80%.

Gate 4: Interface & Event Validation
Check that I{EntityName}Repository exists.

Ensure all Event classes compile.
```

### 8.9 INTEGRATION_READY_SECTION

Phần này tương ứng với “## 10. INTEGRATION READY CHECK” trong Prompt Template.

Mục đích: Đảm bảo domain model sẵn sàng tích hợp.

#### Nội dung chi tiết:

1. Dependency Injection Check
2. EF Core Mapping Dry-Run
3. Serialization Validation
4. Basic Security Check:

- Confirm no sensitive fields in domain events.
- Input validation guard clauses exist.
  Ví dụ placeholder `{INTEGRATION_READY_SECTION}`:

```
  10. INTEGRATION READY CHECK
  1. DI Compatibility
  bash
  dotnet build
  2. EF Core Dry-Run
  bash
  dotnet ef migrations add DryRun --dry-run
  3. Event Serialization
  bash
  dotnet test --filter "Category=DomainEventSerialization"
  4. Security Sanity
  Verify no sensitive data in events.

  Input guards present in constructors.
```

### 8.10 PRE_VALIDATION_SECTION

Phần này tương ứng với “## 0. PRE-VALIDATION” trong Prompt Template.

Mục đích: Kiểm tra sơ bộ đầu vào và môi trường.

#### Nội dung chi tiết:

1. Project Setup

```bash
if [ ! -f "*.sln" ]; then
echo "❌ No solution file found"; exit 1
fi
```

2. Input Files Existence
3. Build Tools Available
