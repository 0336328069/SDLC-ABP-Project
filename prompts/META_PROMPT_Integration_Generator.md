# META-PROMPT: INTEGRATION GENERATOR

## 1. VAI TRÒ
Bạn là một AI Prompt Engineer chuyên tạo prompts cho việc generate Integration Implementation trong ABP Framework projects, đảm bảo tất cả các components (Domain, Application, API, Frontend) hoạt động seamlessly với nhau.

## 2. BỐI CẢNH
**Input cần thiết**:
1. **ImplementPlan_[FeatureName].md** - Implementation function planning với integration requirements
2. **Generated Domain Model Files** - Output từ Domain Model generation
3. **Generated Domain Service Files** - Output từ Domain Service generation  
4. **Generated Application Layer Files** - Output từ Application Layer generation
5. **Generated Backend API Files** - Output từ Backend API generation
6. **Generated Frontend Files** - Output từ Frontend generation
7. **Database Schema Changes** - EF Core migrations và database updates needed
8. **Third-party Integration Requirements** - External services integration specs
9. **Feature Name** - Tên feature cần integrate
10. **Project Path** - Đường dẫn đến thư mục gốc project

**Dynamic Project Information** (extracted from inputs):
- **Technology Stack**: {AUTO_DETECT_FROM_ALL_GENERATED_COMPONENTS}
- **Architecture Pattern**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_GENERATED_CODE}
- **Database Provider**: {DETECT_FROM_EF_CONFIGURATION}
- **Authentication System**: {DETECT_FROM_ABP_CONFIGURATION}
- **Frontend-Backend Integration**: {ANALYZE_FROM_API_AND_FRONTEND_CODE}
- **Third-party Services**: {EXTRACT_FROM_IMPLEMENTPLAN}

## 3. MỤC TIÊU
Tạo ra một prompt chi tiết để generate Integration Implementation cho bất kỳ feature nào, đảm bảo:
- Seamless integration giữa tất cả layers (Domain → Application → API → Frontend)
- Database migrations và schema updates
- ABP Framework module configuration và dependency injection
- Authentication và authorization integration
- Third-party services integration
- End-to-end testing coverage
- Performance optimization across all layers
- Error handling và logging integration

## 4. TEMPLATE GENERATION PROCESS

### Bước 1: Phân tích Generated Components
```
Scan và analyze tất cả generated files:
- Domain Model files → Extract entities, repositories, events
- Domain Service files → Extract business operations
- Application Layer files → Extract app services, DTOs
- Backend API files → Extract controllers, endpoints
- Frontend files → Extract components, services, state management
- Identify integration points và dependencies
```

### Bước 2: Identify Integration Requirements
Từ analysis, xác định:
- **Database Integration**: EF Core migrations, DbContext updates, seed data
- **Module Integration**: ABP module dependencies, service registrations
- **API Integration**: Controller registration, AutoMapper profiles
- **Frontend Integration**: API client setup, state synchronization
- **Authentication Integration**: Permission definitions, authorization policies
- **Third-party Integration**: External service configurations
- **Testing Integration**: Integration test setup, test data management

### Bước 3: Map to Integration Structure
Ánh xạ integration components:
```
{ProjectName}/
├── src/backend/
│   ├── src/{ProjectName}.EntityFrameworkCore/
│   │   ├── Migrations/                    # Auto-generated migrations
│   │   ├── EntityConfigurations/          # EF configurations
│   │   └── {ProjectName}DbContext.cs      # Updated DbContext
│   ├── src/{ProjectName}.Application/
│   │   ├── {ProjectName}ApplicationModule.cs  # Module dependencies
│   │   └── AutoMapperProfile.cs           # Object mapping
│   ├── src/{ProjectName}.HttpApi/
│   │   └── {ProjectName}HttpApiModule.cs  # API module configuration
│   └── src/{ProjectName}.Web/
│       └── {ProjectName}WebModule.cs      # Web module configuration
├── src/frontend/
│   ├── src/services/api/                  # API integration
│   ├── src/stores/                        # State management integration
│   └── src/config/                        # Configuration integration
├── tools/{ProjectName}.DbMigrator/        # Database migration tool
└── tests/                                 # Integration tests
    ├── {ProjectName}.Application.Tests/   # Application integration tests
    ├── {ProjectName}.Web.Tests/           # API integration tests
    └── {ProjectName}.TestBase/            # Shared test infrastructure
```

## 5. PROMPT TEMPLATE

```markdown
# INTEGRATION {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Integration Architect chuyên về ABP Framework Integration và End-to-End System Integration.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **ABP Framework Version**: {AUTO_DETECTED_ABP_VERSION}
- **Database Provider**: {AUTO_DETECTED_DB_PROVIDER}
- **Authentication**: {AUTO_DETECTED_AUTH_SYSTEM}
- **Frontend Framework**: {AUTO_DETECTED_FRONTEND}
- **Architecture**: {DETECTED_ARCHITECTURE_TYPE}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Build System**: {DETECTED_BUILD_SYSTEM}

### Generated Components Analysis:
- **Domain Entities**: {DOMAIN_ENTITIES_LIST}
- **Domain Services**: {DOMAIN_SERVICES_LIST}
- **Application Services**: {APPLICATION_SERVICES_LIST}
- **API Controllers**: {API_CONTROLLERS_LIST}
- **Frontend Components**: {FRONTEND_COMPONENTS_LIST}
- **Integration Points**: {INTEGRATION_POINTS_IDENTIFIED}

### Input Documents đã phân tích:
- **ImplementPlan_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **Generated Code Analysis**: {GENERATED_CODE_SUMMARY}
- **Database Schema Requirements**: {DATABASE_REQUIREMENTS}
- **Third-party Requirements**: {THIRD_PARTY_REQUIREMENTS}

## 3. MỤC TIÊU INTEGRATION

### 3.1 DATABASE INTEGRATION
{DATABASE_INTEGRATION_SECTION}

### 3.2 ABP MODULE INTEGRATION
{ABP_MODULE_INTEGRATION_SECTION}

### 3.3 DEPENDENCY INJECTION SETUP
{DEPENDENCY_INJECTION_SECTION}

### 3.4 API-FRONTEND INTEGRATION
{API_FRONTEND_INTEGRATION_SECTION}

### 3.5 AUTHENTICATION & AUTHORIZATION
{AUTH_INTEGRATION_SECTION}

### 3.6 OBJECT MAPPING CONFIGURATION
{MAPPING_CONFIGURATION_SECTION}

### 3.7 THIRD-PARTY SERVICES INTEGRATION
{THIRD_PARTY_INTEGRATION_SECTION}

### 3.8 END-TO-END TESTING
{E2E_TESTING_SECTION}

### 3.9 PERFORMANCE OPTIMIZATION
{PERFORMANCE_OPTIMIZATION_SECTION}

## 4. YÊU CẦU IMPLEMENTATION
{IMPLEMENTATION_REQUIREMENTS_SECTION}

## 5. OUTPUT FORMAT
{OUTPUT_FORMAT_SECTION}

## 6. INTEGRATION QUALITY STANDARDS
{QUALITY_STANDARDS_SECTION}

## 7. ERROR HANDLING & LOGGING INTEGRATION
{ERROR_LOGGING_INTEGRATION_SECTION}

## 8. DEPLOYMENT INTEGRATION
{DEPLOYMENT_INTEGRATION_SECTION}

## 9. VERIFICATION & TESTING
Sau khi đã hoàn thành integration, thực hiện các bước verification:

### Database Verification
```bash
cd "src/backend/src/{ProjectName}.EntityFrameworkCore"
dotnet ef migrations add {FeatureName}Integration
dotnet ef database update
```

### Backend Build & Test
```bash
cd "src/backend"
dotnet build
dotnet test
```

### Frontend Build & Test  
```bash
cd "src/frontend"
npm run build
npm run test
```

### End-to-End Testing
```bash
# Run integration tests
dotnet test tests/{ProjectName}.Application.Tests/
dotnet test tests/{ProjectName}.Web.Tests/
```

```

## 6. USAGE INSTRUCTIONS

### Input Required:
1. **Feature Name**: Tên feature đã được generate (vd: Authentication, UserManagement)
2. **ImplementPlan File Path**: Đường dẫn đến implementation plan
3. **Generated Domain Files Paths**: Danh sách các file domain đã generate
4. **Generated Application Files Paths**: Danh sách các file application đã generate
5. **Generated API Files Paths**: Danh sách các file API đã generate
6. **Generated Frontend Files Paths**: Danh sách các file frontend đã generate
7. **Project Root Path**: Đường dẫn đến thư mục gốc project
8. **Third-party Integration Specs**: Specification cho external services (optional)

### Execution Steps:
1. **Scan all generated code files** để identify integration points
2. **Auto-detect ABP configuration** từ existing modules và setup
3. **Analyze dependencies** giữa các layers đã generate
4. **Extract database schema changes** từ domain entities
5. **Generate integration prompt** với all necessary configuration steps
6. **Create integration checklist** để verify success
7. **Save prompt** tại `prompts/INTEGRATION_{FeatureName}_Prompt.md`

## 7. TECHNOLOGY AUTO-DETECTION GUIDELINES

### 7.1 ABP Configuration Detection
```
1. Scan {ProjectName}Module.cs files for existing dependencies
2. Identify database provider from EntityFrameworkCore configuration
3. Extract authentication setup from Identity configuration
4. Analyze existing AutoMapper profiles
5. Identify third-party service registrations
```

### 7.2 Integration Points Analysis
```
1. Domain Repositories → Application Services mapping
2. Application Services → API Controllers mapping  
3. API Endpoints → Frontend Services mapping
4. Domain Events → Event Handlers mapping
5. Database Entities → EF Configurations mapping
```

### 7.3 Generate Dynamic Variables
```
- {AUTO_DETECTED_ABP_VERSION}
- {AUTO_DETECTED_DB_PROVIDER}
- {AUTO_DETECTED_AUTH_SYSTEM}
- {DETECTED_FRONTEND_FRAMEWORK}
- {INTEGRATION_POINTS_MAP}
- {REQUIRED_MIGRATIONS}
- {SERVICE_DEPENDENCIES}
```

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 DATABASE_INTEGRATION_SECTION
```markdown
Database integration requirements:

#### EF Core Migrations
- New entities: {NewEntitiesList}
- Updated entities: {UpdatedEntitiesList}
- Migration name: `Add{FeatureName}Feature`
- DbContext updates: {DbContextChanges}

#### Entity Configurations
- {EntityName}Configuration: {ConfigurationDetails}
- Relationships: {RelationshipMappings}
- Indexes: {IndexDefinitions}
- File: `EntityConfigurations/{FeatureName}/{EntityName}Configuration.cs`

#### Seed Data
- Initial data requirements: {SeedDataRequirements}
- File: `Data/{FeatureName}DataSeedContributor.cs`
```

### 8.2 ABP_MODULE_INTEGRATION_SECTION
```markdown
ABP Module configuration updates:

#### Module Dependencies
- Add dependencies: {RequiredModuleDependencies}
- Update {ProjectName}ApplicationModule.cs
- Update {ProjectName}HttpApiModule.cs
- Update {ProjectName}WebModule.cs

#### Service Registration
- Domain services: {DomainServicesRegistration}
- Application services: {ApplicationServicesRegistration}
- Repository registrations: {RepositoryRegistrations}
```

### 8.3 DEPENDENCY_INJECTION_SECTION
```markdown
Dependency injection configuration:

#### Service Lifetimes
- Transient services: {TransientServices}
- Scoped services: {ScopedServices}
- Singleton services: {SingletonServices}

#### Interface Implementations
- Repository implementations: {RepositoryImplementations}
- Service implementations: {ServiceImplementations}
- Configuration: Add to {ProjectName}Module.ConfigureServices()
```

### 8.4 API_FRONTEND_INTEGRATION_SECTION
```markdown
API-Frontend integration setup:

#### API Client Configuration
- Base URL configuration: {API_BASE_URL}
- Authentication headers: {AuthHeaderSetup}
- Error handling: {APIErrorHandling}
- File: `src/frontend/src/services/api/apiClient.js`

#### State Management Integration
- API response mapping: {ResponseMappingLogic}
- State synchronization: {StateSyncPatterns}
- Cache management: {CacheStrategy}

#### Type Definitions
- Sync API DTOs → Frontend types: {TypeSyncStrategy}
- Generate TypeScript definitions: {TypeGenerationProcess}
```

### 8.5 AUTH_INTEGRATION_SECTION
```markdown
Authentication và authorization integration:

#### Permission Definitions
- Permission provider: {FeatureName}PermissionDefinitionProvider
- Permission names: {PermissionNamesList}
- File: `Permissions/{FeatureName}Permissions.cs`

#### Authorization Policies
- Policy requirements: {PolicyRequirements}
- Role-based access: {RoleBasedRules}
- Resource-based access: {ResourceBasedRules}

#### Frontend Authentication
- Token management: {TokenManagementStrategy}
- Route protection: {RouteProtectionSetup}
- Permission checking: {PermissionCheckingLogic}
```

### 8.6 MAPPING_CONFIGURATION_SECTION
```markdown
Object mapping configuration:

#### AutoMapper Profiles
- Domain → Application mapping: {DomainToApplicationMapping}
- Application → API mapping: {ApplicationToAPIMapping}
- Custom converters: {CustomConvertersList}
- File: `{FeatureName}ApplicationAutoMapperProfile.cs`

#### Mapping Validation
- Validation rules: {MappingValidationRules}
- Performance considerations: {MappingPerformanceNotes}
```

### 8.7 THIRD_PARTY_INTEGRATION_SECTION
```markdown
Third-party services integration:

#### External Service Clients
- Service implementations: {ExternalServicesList}
- Configuration: {ExternalServiceConfig}
- Error handling: {ExternalServiceErrorHandling}

#### Webhook Integration
- Webhook endpoints: {WebhookEndpointsList}
- Event processing: {WebhookEventProcessing}
- Security: {WebhookSecurity}
```

### 8.8 E2E_TESTING_SECTION
```markdown
End-to-end testing setup:

#### Integration Test Infrastructure
- Test database setup: {TestDatabaseSetup}
- Test data management: {TestDataManagement}
- Authentication mocking: {AuthMockingStrategy}

#### Test Scenarios
- Happy path tests: {HappyPathTestsList}
- Error scenario tests: {ErrorScenarioTestsList}
- Performance tests: {PerformanceTestsList}

#### Test Files
- Application integration tests: `tests/{ProjectName}.Application.Tests/{FeatureName}Tests.cs`
- API integration tests: `tests/{ProjectName}.Web.Tests/{FeatureName}ControllerTests.cs`
```

### 8.9 IMPLEMENTATION_REQUIREMENTS_SECTION
```markdown
## Integration Implementation Best Practices
- **DO**: Follow ABP Framework module patterns
- **DO**: Use proper dependency injection lifetimes
- **DO**: Implement comprehensive error handling
- **DO**: Setup proper logging throughout all layers
- **DO**: Use transactions for data consistency
- **DO**: Implement proper caching strategies
- **DO NOT**: Bypass ABP Framework conventions
- **DO NOT**: Create tight coupling between layers
- **DO NOT**: Ignore performance implications

## Integration Checklist cho {FeatureName}
- Database migrations applied successfully
- All services registered in DI container
- AutoMapper profiles configured correctly
- API endpoints accessible và functional
- Frontend successfully consumes API
- Authentication/authorization working
- Error handling consistent across layers
- Logging implemented throughout
- Tests passing at all levels
```

### 8.10 OUTPUT_FORMAT_SECTION
```markdown
**QUAN TRỌNG**: Generate ACTUAL INTEGRATION FILES:

1. **Database Files**:
   - `Migrations/{Timestamp}_Add{FeatureName}Feature.cs`
   - `EntityConfigurations/{FeatureName}/*.cs`
   - `Data/{FeatureName}DataSeedContributor.cs`

2. **Module Configuration Files**:
   - Updated `{ProjectName}ApplicationModule.cs`
   - Updated `{ProjectName}HttpApiModule.cs`
   - Updated `{ProjectName}WebModule.cs`

3. **Mapping Files**:
   - `{FeatureName}ApplicationAutoMapperProfile.cs`

4. **Permission Files**:
   - `Permissions/{FeatureName}Permissions.cs`
   - `Permissions/{FeatureName}PermissionDefinitionProvider.cs`

5. **Frontend Integration Files**:
   - `src/frontend/src/services/api/{FeatureName}ApiService.js`
   - `src/frontend/src/types/{FeatureName}.ts`

6. **Test Files**:
   - `tests/{ProjectName}.Application.Tests/{FeatureName}IntegrationTests.cs`
   - `tests/{ProjectName}.Web.Tests/{FeatureName}E2ETests.cs`

7. **Configuration Files**:
   - Updated `appsettings.json` (if needed)
   - Updated frontend configuration files

Each file must be complete và ready for deployment.
```

## 9. VALIDATION RULES

### Technical Validation:
- [ ] All database migrations apply successfully
- [ ] All services resolve from DI container
- [ ] API endpoints return expected responses
- [ ] Frontend successfully authenticates và calls APIs
- [ ] AutoMapper configurations are valid
- [ ] No circular dependencies in DI

### Business Validation:
- [ ] End-to-end user flows work completely
- [ ] Business rules enforced across all layers
- [ ] Data consistency maintained across transactions
- [ ] Authorization works correctly for all endpoints
- [ ] Error scenarios handled gracefully
- [ ] Performance meets requirements

### Integration Validation:
- [ ] Database schema matches domain model
- [ ] API contracts match frontend expectations
- [ ] Authentication tokens flow correctly
- [ ] Logging captures sufficient information
- [ ] Caching improves performance
- [ ] Third-party integrations functional

## 10. EXAMPLE USAGE

```bash
# Input
Feature Name: "OrderProcessing"
ImplementPlan: "docs/DEV/ImplementPlan_OrderProcessing.md"
Generated Domain: ["Entities/Order.cs", "Services/OrderDomainService.cs"]
Generated Application: ["OrderAppService.cs", "DTOs/OrderDto.cs"]
Generated API: ["OrderController.cs"]
Generated Frontend: ["OrderManagement.jsx", "OrderService.js"]
Project Root: "D:/MyABPProject"

# Output Generated
Database: "Migrations/*_AddOrderProcessingFeature.cs"
Modules: "Updated *Module.cs files"
Mapping: "OrderApplicationAutoMapperProfile.cs"
Permissions: "Permissions/OrderProcessingPermissions.cs"
Tests: "tests/**/OrderProcessing*Tests.cs"
Prompt: "prompts/INTEGRATION_OrderProcessing_Prompt.md"
```

## 11. EXTENSIBILITY

### Adding New Integration Patterns:
1. **Extend DATABASE_INTEGRATION_SECTION**
2. **Update ABP_MODULE_INTEGRATION_SECTION**
3. **Modify AUTH_INTEGRATION_SECTION**
4. **Test với existing features**

### Third-party Service Patterns:
1. **Extend THIRD_PARTY_INTEGRATION_SECTION**
2. **Add new service client templates**
3. **Update error handling patterns**
4. **Add monitoring integration**

### Performance Integration Patterns:
1. **Extend PERFORMANCE_OPTIMIZATION_SECTION**
2. **Add caching strategies**
3. **Database optimization patterns**
4. **Frontend performance patterns**

**Meta-Prompt Ready** - Sử dụng để generate integration prompts cho bất kỳ feature nào với complete ABP Framework integration và end-to-end functionality.