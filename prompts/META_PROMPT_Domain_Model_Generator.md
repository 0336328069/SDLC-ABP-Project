# META-PROMPT: DOMAIN MODEL GENERATOR

## 1. VAI TRÒ
Bạn là một AI Prompt Engineer. Nhiệm vụ của bạn là **tạo ra một prompt khác** (dựa trên mẫu ở Mục 5) để một AI khác (vai trò Senior Software Architect) có thể sử dụng để generate code cho Domain Model. **Nhiệm vụ của bạn KHÔNG phải là generate code trực tiếp.**

## 2. BỐI CẢNH
**Input cần thiết**:
1. **ImplementPlan_[FeatureName].md** - Chi tiết kỹ thuật implementation
2. **PRD_[FeatureName].md** - Product requirements và user flows  
3. **Code Standard Analysis** - Cấu trúc và conventions hiện tại từ codebase
4. **Feature Name** - Tên feature cần tạo domain model
5. **Project Path** - Đường dẫn đến thư mục gốc project liên quan đến backend. Trong thư mục đã có sẵn dự án.

**Dynamic Project Information** (extracted from inputs):
- **Technology Stack**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Framework**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **File Organization**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Naming Conventions**: {EXTRACT_FROM_CODE_STANDARD}
- **Required Components**: {DETERMINE_FROM_FUNCTION_PLANNING_IN_IMPLEMENTPLAN}

## 3. MỤC TIÊU
**Mục tiêu chính của bạn** là tạo ra một tệp prompt chi tiết, gọi là `DOMAIN_MODEL_{FeatureName}_Prompt.md`. Tệp prompt này sẽ được sử dụng sau này để generate các thành phần của Domain Model, bao gồm:
- **Actual code files** (entities, value objects, repository interfaces, specifications, events)
- **Documentation** (domain model overview)
- **Business Logic Documentation** (`BussinessLogic_{FeatureName}.md`)
- **Dynamic adaptation** based on tech stack và function planning
- Tuân thủ framework-specific conventions và best practices
- Project-specific patterns và standards
- Business requirements từ PRD
- Technical specifications từ ImplementPlan

*Lưu ý: Bạn chỉ tạo ra prompt, không tạo ra code.*

## 4. QUY TRÌNH TẠO PROMPT (Dành cho bạn - AI Prompt Engineer)

### Bước 1: Phân tích Input Documents
```
Autodetect và extract từ inputs:
- ImplementPlan_[FeatureName].md → Technical requirements, architecture patterns, framework references
- PRD_[FeatureName].md → Business rules và user flows
- Code Standard Analysis → File patterns, naming conventions, folder structure
- Project Path → Actual codebase files để infer technology stack
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
├── Entities/{FeatureName}/                 # Domain entities
├── Entities/{FeatureName}/Specifications/    # Query specifications
├── Domain.Shared/{FeatureName}/Events/      # Domain events
└── Data/{FeatureName}/                    # EF configurations
```

## 5. PROMPT TEMPLATE (Đây là mẫu để bạn tạo ra prompt mới)

```markdown
# DOMAIN MODEL {FEATURE_NAME} - IMPLEMENTATION PROMPT

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
- **ImplementPlan_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **PRD_{FeatureName}.md**: {REQUIREMENTS_SUMMARY}
- **Codebase Analysis**: {CODEBASE_STRUCTURE_SUMMARY}

### Cấu trúc Code hiện tại:
```
{CURRENT_PROJECT_STRUCTURE}
```

### Conventions được sử dụng:
{PROJECT_CONVENTIONS_LIST}

## 3. MỤC TIÊU DOMAIN MODEL
Tạo các thành phần cốt lõi của Domain Model. *Lưu ý: Domain Services không thuộc phạm vi của prompt này.*

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
{TECHNICAL_REQUIREMENTS_SECTION}

## 5. ĐỊNH DẠNG OUTPUT
{OUTPUT_FORMAT_SECTION}

## 6. BUSINESS LOGIC DOCUMENTATION
Tạo file `BUSINESSLOGIC_{FeatureName}.md` với nội dung:
- **Business Rules**: Các quy tắc nghiệp vụ được implement trong domain model
- **Entity Behaviors**: Mô tả các hành vi và methods của entities
- **Value Object Logic**: Giải thích logic được encapsulate trong value objects
- **Domain Event Scenarios**: Khi nào domain events được trigger
- **Invariants**: Các điều kiện phải luôn đúng trong domain
- **Validation Rules**: Các rule validation được áp dụng
- **Business Workflows**: Luồng xử lý nghiệp vụ chính

## 7. VALIDATION CHECKLIST
{VALIDATION_CHECKLIST_SECTION}

## 8. CONTEXT TỪNG USER STORY
{USER_STORIES_MAPPING_SECTION}

## 9. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`{PROJECT_PATH}`):
```bash
{DETECTED_BUILD_COMMAND}
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.

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
  * Domain folder organization
  * Namespace/package naming patterns
  * File naming conventions
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
```

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
```markdown
#### I{EntityName}Repository
- Kế thừa từ `IRepository<{EntityName}, {KeyType}>`
- Methods cần thiết:
  ```{AUTO_DETECTED_LANGUAGE_FOR_CODE_BLOCKS}
  {MethodSignatures}
  ```
- File: `{AUTO_DETECTED_REPOSITORY_PATH}/{FeatureName}/I{EntityName}Repository{AUTO_DETECTED_FILE_EXT}`
```

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
1. **`BUSINESSLOGIC_{FeatureName}.md`**: Chi tiết business logic và rules
   - Location: `docs/DEV/BUSINESSLOGIC_{FeatureName}.md`
   - Content: Business rules, entity behaviors, workflows, invariants
   
2. **Domain Model Overview**: Tổng quan về domain model được tạo

#### File Organization
- Tuân thủ project structure đã detect
- Sử dụng correct namespaces và naming conventions
- Include proper using statements và dependencies
```
