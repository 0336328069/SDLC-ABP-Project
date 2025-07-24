# Universal Low-Level Design Automation Prompt

## Context

You are a Senior Software Architect and System Designer with 15+ years of experience specializing in Low-Level Design (LLD).
Your task is to create a comprehensive, detailed Low-Level Design (LLD) document for the feature `[FeatureName]` based **strictly** on the high-level architecture and technical specifications provided below.

- Do not assume or invent any classes, methods, algorithms, data structures, or implementation patterns unless they are clearly described in the input documents.
- Always extract actual technical requirements, component specifications, and implementation constraints directly from the context.
- If the documentation lacks a detail, explicitly note it as an open question using **TBD: [missing implementation detail]**, and do not fill it in by assumption.

## Input Documents (provided in full as context):

- HighLevelDesign_[FeatureName].md
- ERD_[FeatureName].md
- PRD_[FeatureName]_v1.0.md
- SRS&DM_[FeatureName]_v1.0.md
- US_[FeatureName]_v1.0.md
- Vision_[FeatureName]_v1.0.md
- TechStack.md
- team-capabilities-file.md
- Technical_Feasibility_[FeatureName].md

---

## Output Requirement

Produce a file: `LowLevelDesign_[FeatureName].md` with the following sections:

## 1. Executive Summary
- **Module Overview**: Brief description of the module's purpose and scope
- **Architecture Pattern**: Confirm the architectural approach (e.g., Modular Monolith, Clean Architecture, DDD)
- **Technology Stack**: List all technologies from HLD with versions
- **Key Components**: High-level component summary
- **Implementation Timeline**: Development phases and milestones

## 2. Domain Layer Design
### 2.1 Domain Model Analysis
- **Bounded Context Definition**: Define the bounded context and its boundaries
- **Ubiquitous Language**: Key domain terms and their definitions
- **Core Domain Concepts**: Primary business concepts and their relationships

### 2.2 Aggregate Roots
For each Aggregate Root identified in the ERD:
- **Aggregate Name**: [Entity Name] Aggregate
- **Business Purpose**: What business problem it solves
- **Aggregate Boundaries**: What entities belong to this aggregate
- **Invariants**: Business rules that must always be true
- **Root Entity Implementation**: (code example)

### 2.3 Entities
For each Entity in the ERD:
- **Entity Definition**: Purpose and business rules
- **Properties**: All attributes with data types, constraints, and validation rules
- **Relationships**: How it relates to other entities
- **Business Methods**: Domain logic methods
- **Code Implementation**: (code example)

### 2.4 Value Objects
Identify and implement Value Objects:
- **Value Object Purpose**: What concept it represents
- **Immutability**: How immutability is enforced
- **Equality**: How equality is determined
- **Validation**: Business rule validation
- **Code Implementation**: (code example)

### 2.5 Domain Events
For each significant domain event:
- **Event Purpose**: When and why it's raised
- **Event Payload**: What data it carries
- **Event Handlers**: Who handles the event
- **Code Implementation**: (code example)

### 2.6 Domain Services
For complex business logic that doesn't belong to entities:
- **Service Purpose**: What business logic it encapsulates
- **Dependencies**: What other domain objects it depends on
- **Methods**: Business operations it provides
- **Code Implementation**: (code example)

### 2.7 Repository Interfaces
For each Aggregate Root:
- **Repository Purpose**: Data access contract
- **Custom Methods**: Specific query methods needed
- **Specifications**: Query specifications for complex queries
- **Code Implementation**: (code example)

## 3. Application Layer Design
### 3.1 Application Services
For each major use case:
- **Service Purpose**: What business use case it handles
- **Dependencies**: What domain and infrastructure services it needs
- **Methods**: Public methods that orchestrate business operations
- **Transaction Management**: How transactions are handled
- **Code Implementation**: (code example)

### 3.2 Data Transfer Objects (DTOs)
For each entity and operation:
- **DTO Purpose**: What data it transfers
- **Validation**: Input validation rules
- **Mapping**: How it maps to/from domain entities
- **Code Implementation**: (code example)

### 3.3 AutoMapper Profiles
- **Mapping Configuration**: How DTOs map to domain entities
- **Custom Mappings**: Special mapping logic
- **Code Implementation**: (code example)

### 3.4 Application Service Interfaces
- **Contract Definition**: Public interface for each application service
- **Method Signatures**: All public methods with parameters and return types
- **Code Implementation**: (code example)

### 3.5 Validators
For input validation:
- **Validation Rules**: Business and technical validation
- **Custom Validators**: Complex validation logic
- **Code Implementation**: (code example)

## 4. Infrastructure Layer Design
### 4.1 Entity Framework Configuration
- **DbContext Implementation**: Database context configuration
- **Entity Configurations**: Fluent API configurations for each entity
- **Connection String**: Database connection configuration
- **Code Implementation**: (code example)

### 4.2 Repository Implementations
For each repository interface:
- **Implementation Details**: How queries are executed
- **Performance Optimization**: Indexing and query optimization
- **Code Implementation**: (code example)

### 4.3 External Service Integrations
For each external service from HLD:
- **Service Purpose**: What external service it integrates with
- **Configuration**: How it's configured
- **Error Handling**: How failures are handled
- **Code Implementation**: (code example)

### 4.4 Database Migration Scripts
- **Migration Strategy**: How database changes are applied
- **Initial Migration**: Creating the initial schema
- **Seed Data**: Reference data setup
- **Code Implementation**: (code example)

## 5. Presentation Layer Design
### 5.1 API Controllers
For each major entity:
- **Controller Purpose**: What API endpoints it provides
- **HTTP Methods**: GET, POST, PUT, DELETE implementations
- **Authorization**: Role-based access control
- **Code Implementation**: (code example)

### 5.2 React/Next.js Components
For each UI component:
- **Component Purpose**: What UI functionality it provides
- **Props Interface**: Input properties and their types
- **State Management**: How state is managed
- **Code Implementation**: (code example)

### 5.3 API Client Implementation
- **HTTP Client Configuration**: Axios or fetch setup
- **Type Definitions**: TypeScript interfaces for API responses
- **Error Handling**: How API errors are handled
- **Code Implementation**: (code example)

## 6. Security Implementation
### 6.1 Authentication Implementation
- **Authentication Provider**: How users are authenticated
- **Token Management**: JWT token handling
- **Code Implementation**: (code example)

### 6.2 Authorization Implementation
- **Permission Definitions**: All permissions for the module
- **Role-Based Access**: How roles are mapped to permissions
- **Code Implementation**: (code example)

### 6.3 Data Protection
- **Encryption**: How sensitive data is encrypted
- **Audit Logging**: What actions are logged
- **Code Implementation**: (code example)

## 7. Cross-Cutting Concerns
### 7.1 Logging Implementation
- **Logging Framework**: What logging framework is used
- **Log Levels**: When different log levels are used
- **Structured Logging**: How logs are structured
- **Code Implementation**: (code example)

### 7.2 Caching Strategy
- **Cache Layers**: What is cached and where
- **Cache Invalidation**: How cache is invalidated
- **Code Implementation**: (code example)

### 7.3 Exception Handling
- **Exception Types**: Custom exception classes
- **Error Responses**: How errors are returned to clients
- **Code Implementation**: (code example)

## 8. Testing Strategy
### 8.1 Unit Testing
- **Test Framework**: Testing framework and tools
- **Test Coverage**: What should be tested
- **Test Examples**: (code example)

### 8.2 Integration Testing
- **Integration Test Strategy**: How integration tests are structured
- **Test Data**: How test data is managed
- **Code Implementation**: (code example)

### 8.3 End-to-End Testing
- **E2E Test Strategy**: How end-to-end tests are structured
- **Test Scenarios**: Key user scenarios to test
- **Code Implementation**: (code example)

## 9. Performance Optimization
### 9.1 Database Optimization
- **Query Optimization**: How queries are optimized
- **Indexing Strategy**: What indexes are created
- **Connection Pooling**: How database connections are managed
- **Implementation Details**: (code example)

### 9.2 Application Performance
- **Caching Strategy**: What and how to cache
- **Async Operations**: How async operations are implemented
- **Memory Management**: How memory is managed
- **Code Implementation**: (code example)

### 9.3 Frontend Performance
- **Bundle Optimization**: How frontend bundles are optimized
- **Lazy Loading**: What components are lazy loaded
- **Code Implementation**: (code example)

## 10. Deployment Configuration
### 10.1 Environment Configuration
- **Configuration Management**: How configuration is managed
- **Environment Variables**: What environment variables are needed
- **Code Implementation**: (code example)

### 10.2 Database Migration
- **Migration Scripts**: How database migrations are run
- **Data Seeding**: How initial data is seeded
- **Code Implementation**: (code example)

### 10.3 Monitoring and Logging
- **Application Monitoring**: How application is monitored
- **Log Aggregation**: How logs are collected and analyzed
- **Performance Monitoring**: How performance is monitored
- **Configuration**: (code example)

## 11. Implementation Checklist
### 11.1 Development Checklist
- [ ] Domain layer implemented with all entities, value objects, and aggregates
- [ ] Application layer implemented with all services and DTOs
- [ ] Infrastructure layer implemented with repositories and external services
- [ ] Presentation layer implemented with controllers and UI components
- [ ] Security implemented with authentication and authorization
- [ ] Cross-cutting concerns implemented (logging, caching, exception handling)
- [ ] Unit tests written for all major components
- [ ] Integration tests written for all services
- [ ] Performance testing completed
- [ ] Security testing completed

### 11.2 Code Quality Checklist
- [ ] Code follows Clean Architecture principles
- [ ] Domain logic is properly encapsulated
- [ ] Business rules are enforced in the domain layer
- [ ] Proper error handling is implemented
- [ ] Logging is comprehensive and structured
- [ ] Code is well-documented
- [ ] Performance considerations are addressed
- [ ] Security best practices are followed

### 11.3 Deployment Checklist
- [ ] Database migrations are ready
- [ ] Configuration is environment-specific
- [ ] Monitoring is configured
- [ ] Logging is configured
- [ ] Security certificates are in place
- [ ] Performance baselines are established
- [ ] Backup and recovery procedures are documented
- [ ] Rollback procedures are documented

## 12. Troubleshooting Guide
### 12.1 Common Issues and Solutions
- **Issue**: [Common problem]
  - **Cause**: [Root cause]
  - **Solution**: [How to fix]
  - **Prevention**: [How to prevent]

### 12.2 Performance Issues
- **Issue**: [Performance problem]
  - **Diagnosis**: [How to diagnose]
  - **Solution**: [How to fix]
  - **Monitoring**: [How to monitor]

### 12.3 Security Issues
- **Issue**: [Security problem]
  - **Diagnosis**: [How to diagnose]
  - **Solution**: [How to fix]
  - **Prevention**: [How to prevent]

---

## Enhanced Guidelines for Implementation Context

- **Only** include implementation details that are directly supported by the technology stack in TechStack.md.
- **Do not** design generic solutions that don't address specific business requirements.
- **Mark all missing implementation details as**
  > **TBD: [missing implementation detail]**
- **Never** assume specific libraries or frameworks unless explicitly mentioned in documentation.
- Write in detailed, implementation-focused language suitable for developers.
- For every design decision, provide rationale and, where possible, a code example.
- Do not reference input file names in the output document.

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs as plain text under the prompt.
- Feed the combined text into your preferred AI implementation design tool.
- Use this design as a direct blueprint for development implementation.

---
