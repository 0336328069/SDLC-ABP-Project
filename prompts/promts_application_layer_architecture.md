# 1. VAI TRÒ
Bạn là một Senior Software Architect chuyên về Domain-Driven Design, Clean Architecture


# 2. INPUT REQUIREMENTS
## 2.1 Business Requirements Document (BRD)
**INPUT DOCUMENTS:** PRD_[FeatureName].md

## 2.2 Software Requirements Specification (SRS)  
**INPUT DOCUMENTS:** SRS&DM_[FeatureName].md

## 2.3 Use Case Specifications
**INPUT DOCUMENTS:** US_[FeatureName].md

## 2.4 Implement Function Planning
**INPUT DOCUMENTS:** ImplementPlan_[FeatureName].md

## 2.5 Code Standards:
**INPUT DOCUMENTS:** CodeConventionDocument_[FeatureName].md

# 3. MỤC TIÊU SINH MÃ
Tạo **HOÀN CHỈNH Application Layer Architecture** cho module bao gồm:

## 3.1 Application Contracts Layer
### DTOs (Data Transfer Objects)
- **Input DTOs**: Cho các operations (Create, Update, Request)
- **Output DTOs**: Cho response data 
- **Entity DTOs**: Mapping từ domain entities
- **List DTOs**: Cho pagination và filtering
- **Validation Attributes**: Data annotations và custom validators

### Application Service Interfaces
- **I{FeatureName}AppService**: Primary service interface extending IApplicationService
- **Method Signatures**: Async methods với proper return types
- **CRUD Operations**: Create, Read, Update, Delete với business logic
- **Business Operations**: Specific use cases từ requirements

### AutoMapper Profiles
- **DTO ↔ Entity Mappings**: Bidirectional mappings
- **Custom Mappings**: Complex property mappings
- **Conditional Mappings**: Business rule-based mapping logic

## 3.2 Application Services Implementation
### Application Services
- **{FeatureName}AppService**: Implementing I{FeatureName}AppService
- **Constructor Injection**: Repository, domain services, UoW dependencies
- **Use Case Implementation**: Business workflow orchestration
- **DTO Conversion**: Input validation và output mapping
- **Transaction Management**: Unit of Work pattern với ABP UoW
- **Exception Handling**: Business exceptions và validation errors
- **Authorization**: Permission-based access control
- **Audit Logging**: Change tracking và business operation logs

### CQRS Implementation (nếu cần)
- **Command Objects**: State-changing operations
- **Query Objects**: Data retrieval operations  
- **Command Handlers**: Business logic execution
- **Query Handlers**: Optimized data access

### Validation Services
- **FluentValidation**: Complex business rule validation
- **Input Validators**: DTO validation logic
- **Business Rule Validators**: Domain-specific constraints

## 3.3 Unit Tests
### Service Tests
- **Application Service Tests**: Use case testing
- **Mocking Strategy**: Repository và domain service mocks
- **Test Data Builders**: Consistent test data creation
- **Exception Testing**: Error handling verification
- **Integration Tests**: End-to-end workflow testing

# 4. YÊU CẦU KỸ THUẬT CHI TIẾT

## 4.1 ABP Framework Integration
- **ApplicationService Base Class**: Inherit từ ABP ApplicationService
- **IApplicationService Interface**: Proper service registration
- **Localization Support**: Multi-language resource usage  
- **Permission Authorization**: ABP permission system integration
- **Unit of Work**: Automatic transaction management
- **Dependency Injection**: Constructor injection pattern
- **Settings Management**: Configuration access
- **Current User**: User context access

## 4.2 Clean Architecture Compliance
- **Dependency Direction**: Application → Domain, no reverse dependencies
- **DTO Usage**: No domain entities in application service interfaces
- **Separation of Concerns**: Clear layer boundaries
- **Single Responsibility**: Each service focused on specific business capability

## 4.3 Domain-Driven Design Integration
- **Use Case Orchestration**: Coordinate domain services và aggregates
- **Business Rule Enforcement**: Domain logic encapsulation
- **Domain Event Publishing**: Event-driven architecture support
- **Repository Pattern**: Abstract data access via interfaces
- **Aggregate Boundaries**: Respect domain model constraints

## 4.4 Error Handling & Validation
- **BusinessException**: Meaningful business error messages
- **Validation Pipeline**: Multi-layer validation strategy
- **Localized Messages**: Internationalization support
- **Structured Logging**: Comprehensive operation logging

# 5. ĐỊNH DẠNG OUTPUT - MULTIPLE CODE FILES

**QUAN TRỌNG**: Sinh ra actual code files, không phải markdown documentation.

Sử dụng mutil-agent generation, 

# 6. CODE GENERATION REQUIREMENTS

## 6.1 Code Quality Standards
- **Compilable Code**: All files phải compile successfully
- **Complete Implementations**: No placeholder comments hoặc TODO items
- **Proper Namespaces**: Consistent namespace structure
- **XML Documentation**: Comprehensive method và class documentation
- **Async/Await Pattern**: Proper async programming practices
- **Null Safety**: Appropriate null checking và handling
- **Same Name**: Các thuộc tính của class không được trùng với tên của method trong class đó
- **Name Method**: Tên method phải rõ ràng, ngắn gọn, và mô tả chính xác những gì method thực hiện.

## 6.2 Business Logic Integration
- **Use Case Mapping**: Mỗi use case có corresponding service method
- **Business Rule Implementation**: Domain constraints properly enforced
- **Data Flow**: Input validation → business logic → output mapping
- **Exception Scenarios**: Handle all error conditions từ requirements
- **Performance Considerations**: Efficient queries và caching strategies

## 6.3 Testing Requirements
- **Unit Test Coverage**: Test all public methods
- **Mock Strategy**: Mock external dependencies
- **Test Scenarios**: Happy path, edge cases, error conditions
- **Data Builders**: Reusable test data creation
- **Integration Tests**: End-to-end workflow verification

# 7. VALIDATION CHECKLIST

Trước khi output, đảm bảo:
- [ ] Tất cả business requirements từ BRD/SRS được implement
- [ ] Tất cả các file được using directives/using statements chính xác. Reference đến các packages được sử dụng (ex: using System.Linq).
- [ ] Use cases có corresponding application service methods
- [ ] DTOs có proper validation attributes
- [ ] AutoMapper profiles cover all entity ↔ DTO mappings
- [ ] Exception handling comprehensive và meaningful
- [ ] Unit tests cover critical business scenarios
- [ ] ABP Framework integration correct (inheritance, DI, UoW)
- [ ] Clean Architecture principles followed
- [ ] File structure organized và consistent
- [ ] Code follows C# naming conventions
- [ ] No domain entities leak into application interfaces
- [ ] Repository interfaces used correctly
- [ ] Business logic delegated to domain services
- [ ] Transaction boundaries properly defined
- [ ] Performance optimized (async, caching, efficient queries)

Kết thúc bằng: **END_OF_APPLICATION_LAYER_GENERATION**
