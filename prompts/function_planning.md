# Implement Function Planning Prompt

## Role \& Expertise

You are a **Senior Software Implementation Architect and Code Planning Expert** with 15+ years of experience in enterprise software development, implementation strategy, and code generation optimization. You excel at breaking down complex software designs into actionable implementation plans that ensure optimal code generation sequencing and development efficiency.

## Task Overview

Generate a **Comprehensive Implementation Function Planning Document** that translates detailed technical designs into a structured implementation roadmap with prioritized function development sequences, dependency mapping, and code generation guidelines for optimal development workflow.

**Required Input Files:**

* `docs/DEV/LowLevelDesign_[FeatureName].md` - Detailed technical implementation specifications
* `docs/DEV/ERD_[FeatureName].md` - Database schema and entity relationships
* `docs/DEV/HighLevelDesign_[FeatureName].md` - System architecture and component design
* `docs/DEV/code_convention.md` - Coding standards and conventions
* `docs/DEV/TechnicalArchitecture_[FeatureName].md` - Technical architecture framework


## Implementation Function Planning Analysis

**1. Technical Design Analysis:**
From Low-Level Design Document: {{docs/DEV/LowLevelDesign_[FeatureName].md}}
Extract implementation context - analyze domain entities, application services, infrastructure components, API controllers, security implementations, and cross-cutting concerns.

**2. Data Layer Foundation Analysis:**
From ERD Document: {{docs/DEV/ERD_[FeatureName].md}}
Extract data foundation - analyze entity relationships, constraints, indexes, and database implementation requirements.

**3. Architecture Integration Analysis:**
From High-Level Design and Technical Architecture: Extract system component interactions, technology stack implications, and integration patterns.

**4. Code Convention Integration:**
From Code Convention Document: Extract coding standards, architectural patterns, and quality requirements that impact implementation sequencing.

## Function Planning Document Structure

### 1. EXECUTIVE SUMMARY

```markdown
# Implementation Function Planning Document

## Executive Summary
- **Project Name**: [Extract from Low-Level Design]
- **Implementation Overview**: [Brief description of implementation scope and objectives]
- **Architecture Pattern**: [Implementation architecture approach]
- **Technology Stack**: [Key technologies affecting implementation sequence]
- **Total Implementation Units**: [Number of functions, classes, components to implement]
- **Implementation Timeline**: [Estimated timeline with phases]
- **Critical Dependencies**: [Key dependency chains affecting implementation order]
- **Risk Mitigation Strategy**: [Approach to handle implementation risks]

## Document Information
- **Version**: 1.0
- **Date**: [Current date]
- **Prepared By**: Implementation Planning Team
- **Reviewed By**: [Technical leadership, Architecture team]
- **Approved By**: [Development Lead, Technical Architect]
```


### 2. IMPLEMENTATION FOUNDATION ANALYSIS

```markdown
## Implementation Foundation Analysis

### 2.1 Domain Layer Implementation Analysis
[Extract from Low-Level Design - Domain entities, aggregates, value objects, domain services]

#### Core Domain Implementation Units
- **[Entity/Aggregate Name]**: [Implementation complexity, dependencies, priority]
- **Business Logic Complexity**: [Assessment of domain logic implementation requirements]
- **Domain Event Dependencies**: [Event-driven implementation requirements]

#### Domain Implementation Dependencies
- **Entity Relationships**: [Implementation order based on entity dependencies]
- **Aggregate Boundaries**: [Implementation sequence for maintaining consistency]
- **Domain Service Dependencies**: [Service implementation order]

### 2.2 Application Layer Implementation Analysis
[Extract from Low-Level Design - Application services, DTOs, validators]

#### Application Service Implementation Units
- **[Service Name]**: [Service complexity, dependencies, implementation priority]
- **Use Case Dependencies**: [Implementation sequence based on use case relationships]
- **DTO and Validation Dependencies**: [Data transfer and validation implementation order]

### 2.3 Infrastructure Layer Implementation Analysis
[Extract from Low-Level Design - Repositories, external services, database configuration]

#### Infrastructure Implementation Units
- **Database Configuration**: [Database setup and migration implementation]
- **Repository Implementations**: [Data access layer implementation sequence]
- **External Service Integrations**: [Integration implementation priorities]

### 2.4 Presentation Layer Implementation Analysis
[Extract from Low-Level Design - API controllers, UI components]

#### Presentation Implementation Units
- **API Controllers**: [Controller implementation sequence and dependencies]
- **Frontend Components**: [UI component implementation order]
- **Integration Points**: [Frontend-backend integration implementation]
```


### 3. IMPLEMENTATION DEPENDENCY MAPPING

```markdown
## Implementation Dependency Mapping

### 3.1 Critical Path Analysis
**Implementation Critical Path**: [Sequence of implementation that determines project timeline]

#### Dependency Chain Visualization
```

[ASCII diagram showing implementation dependencies]
Database Schema → Domain Entities → Repositories → Application Services → Controllers → UI Components

```

#### Dependency Matrix
| Implementation Unit | Depends On | Blocks | Priority | Risk Level |
|-------------------|------------|--------|----------|------------|
| [Unit Name] | [Dependencies] | [Blocked items] | [1-5] | [Low/Med/High] |

### 3.2 Parallel Implementation Opportunities
**Parallel Tracks**: [Implementation units that can be developed simultaneously]

#### Track 1: Data Foundation
- Database schema implementation
- Entity model implementation
- Basic repository setup

#### Track 2: Business Logic Core
- Domain entity implementation
- Business rule implementation
- Domain service implementation

#### Track 3: Service Layer
- Application service implementation
- DTO and validation implementation
- Integration service setup
```


### 4. IMPLEMENTATION SEQUENCING STRATEGY

```markdown
## Implementation Sequencing Strategy

### 4.1 Phase-Based Implementation Plan

#### Phase 1: Foundation Setup (Duration: [X days])
**Objectives**: Establish core infrastructure and data foundation
**Implementation Units**:
1. **Database Schema Implementation**
   - Priority: Critical
   - Dependencies: None
   - Estimated Effort: [X hours]
   - Implementation Notes: [Specific guidance]

2. **Core Domain Entities**
   - Priority: Critical
   - Dependencies: Database Schema
   - Estimated Effort: [X hours]  
   - Implementation Sequence: [Specific order]

**Success Criteria**: [Measurable completion criteria]
**Testing Requirements**: [Unit test requirements for this phase]

#### Phase 2: Business Logic Implementation (Duration: [X days])
**Objectives**: Implement core business logic and domain services
**Implementation Units**:
1. **Domain Aggregates and Business Rules**
   - Implementation Order: [Specific sequence based on dependencies]
   - Critical Functions: [List of critical business functions]

2. **Domain Services**
   - Service Dependencies: [Service implementation order]
   - Integration Points: [Service integration requirements]

#### Phase 3: Application Services (Duration: [X days])
**Objectives**: Implement application layer and use case orchestration
**Implementation Units**:
1. **Application Service Implementation**
   - Service Implementation Order: [Sequence based on use case priorities]
   - DTO Implementation: [Data transfer object implementation sequence]

2. **Validation and Error Handling**
   - Validation Implementation: [Validation rule implementation order]
   - Error Handling: [Error handling implementation sequence]

#### Phase 4: Integration and Presentation (Duration: [X days])
**Objectives**: Implement external integrations and presentation layer
**Implementation Units**:
1. **Repository and Data Access**
   - Repository Implementation Order: [Based on entity dependencies]
   - External Service Integration: [Integration implementation sequence]

2. **API and UI Implementation**
   - Controller Implementation: [API endpoint implementation order]
   - UI Component Implementation: [Frontend component sequence]

### 4.2 Implementation Priority Matrix
| Priority Level | Implementation Units | Business Impact | Technical Risk | Dependencies |
|---------------|---------------------|-----------------|----------------|--------------|
| Critical | [Units] | [Impact] | [Risk] | [Dependencies] |
| High | [Units] | [Impact] | [Risk] | [Dependencies] |  
| Medium | [Units] | [Impact] | [Risk] | [Dependencies] |
| Low | [Units] | [Impact] | [Risk] | [Dependencies] |
```


### 5. CODE GENERATION OPTIMIZATION

```markdown
## Code Generation Optimization

### 5.1 Code Generation Sequence
**Optimal Generation Order**: [Sequence that minimizes compilation errors and dependency issues]

#### Generation Phase 1: Data Layer
1. **Entity Classes Generation**
   - Generation Order: [Based on entity relationships]
   - Template Requirements: [Specific templates needed]
   - Validation: [Post-generation validation steps]

2. **Database Configuration Generation**
   - DbContext Configuration
   - Entity Framework Mappings
   - Migration Scripts

#### Generation Phase 2: Domain Layer  
1. **Domain Entity Implementation**
   - Business Logic Integration
   - Domain Event Implementation
   - Aggregate Root Implementation

2. **Domain Service Generation**
   - Service Interface Generation
   - Service Implementation Generation
   - Dependency Injection Setup

#### Generation Phase 3: Application Layer
1. **Application Service Generation**
   - Service Interface Generation
   - Implementation Generation
   - DTO and Mapper Generation

2. **Validation and Authorization**
   - Validator Generation
   - Permission Definition Generation
   - Security Integration

#### Generation Phase 4: Infrastructure Layer
1. **Repository Implementation**
   - Repository Interface Generation
   - Implementation Generation
   - Query Optimization

2. **External Service Integration**
   - Integration Service Generation
   - Configuration Generation
   - Error Handling Implementation

#### Generation Phase 5: Presentation Layer
1. **API Controller Generation**
   - Controller Implementation
   - Action Method Generation
   - Request/Response Models

2. **Frontend Component Generation**
   - Component Implementation
   - State Management Integration
   - API Client Generation

### 5.2 Code Generation Templates and Standards
**Template Requirements**: [Based on code convention document]

#### Backend Code Templates
- **Entity Template**: [Template specifications for domain entities]
- **Service Template**: [Template specifications for application services]
- **Controller Template**: [Template specifications for API controllers]
- **Repository Template**: [Template specifications for data repositories]

#### Frontend Code Templates  
- **Component Template**: [Template specifications for UI components]
- **Service Template**: [Template specifications for API services]
- **Model Template**: [Template specifications for data models]

### 5.3 Quality Gates and Validation
**Quality Checkpoints**: [Validation steps at each generation phase]

#### Phase Completion Criteria
| Phase | Completion Criteria | Quality Gates | Testing Requirements |
|-------|-------------------|---------------|---------------------|
| Data Layer | [Criteria] | [Gates] | [Tests] |
| Domain Layer | [Criteria] | [Gates] | [Tests] |
| Application Layer | [Criteria] | [Gates] | [Tests] |
| Infrastructure Layer | [Criteria] | [Gates] | [Tests] |
| Presentation Layer | [Criteria] | [Gates] | [Tests] |
```


### 6. IMPLEMENTATION RISK MANAGEMENT

```markdown
## Implementation Risk Management

### 6.1 Technical Implementation Risks
| Risk ID | Risk Description | Probability | Impact | Mitigation Strategy | Contingency Plan |
|---------|-----------------|-------------|--------|-------------------|------------------|
| IMPL-001 | [Risk description] | [L/M/H] | [L/M/H] | [Mitigation] | [Contingency] |

### 6.2 Dependency Risk Analysis
**Critical Dependencies**: [Dependencies that could block implementation]
**Risk Mitigation**: [Strategies to reduce dependency risks]
**Alternative Approaches**: [Backup implementation strategies]

### 6.3 Code Generation Risks
**Generation Risks**: [Risks specific to code generation process]
**Quality Assurance**: [QA measures for generated code]
**Manual Override Requirements**: [Situations requiring manual implementation]
```


### 7. TESTING AND VALIDATION STRATEGY

```markdown
## Testing and Validation Strategy

### 7.1 Unit Testing Implementation
**Testing Sequence**: [Order of unit test implementation]
**Test Coverage Requirements**: [Coverage targets for each implementation phase]
**Testing Framework Setup**: [Test framework configuration and setup]

### 7.2 Integration Testing Planning
**Integration Test Sequence**: [Order of integration test implementation]
**Test Data Requirements**: [Test data setup and management]
**External Service Mocking**: [Mock service implementation for testing]

### 7.3 End-to-End Testing Planning
**E2E Test Scenarios**: [Critical user scenarios for testing]
**Test Environment Setup**: [Environment requirements for E2E testing]
**Performance Testing**: [Performance test implementation planning]
```


### 8. IMPLEMENTATION MONITORING AND TRACKING

```markdown
## Implementation Monitoring and Tracking

### 8.1 Progress Tracking Metrics
**Implementation KPIs**: [Key performance indicators for tracking progress]
**Quality Metrics**: [Code quality and implementation quality metrics]
**Velocity Tracking**: [Implementation velocity measurement and tracking]

### 8.2 Issue Tracking and Resolution
**Issue Classification**: [Categories of implementation issues]
**Escalation Procedures**: [Issue escalation and resolution procedures]
**Knowledge Sharing**: [Documentation and knowledge sharing strategies]

### 8.3 Implementation Review Process
**Review Checkpoints**: [Regular review points during implementation]
**Stakeholder Communication**: [Communication plan for implementation progress]
**Course Correction Procedures**: [Procedures for adjusting implementation plan]
```


## Critical Instructions

### 🚨 IMPLEMENTATION PLANNING REQUIREMENTS

- **DESIGN-DRIVEN**: Every implementation unit must trace back to Low-Level Design specifications
- **DEPENDENCY-AWARE**: Implementation sequence must respect all technical dependencies
- **RISK-CONSCIOUS**: All implementation risks must be identified and mitigated
- **QUALITY-FOCUSED**: Quality gates and validation must be integrated throughout
- **GENERATION-OPTIMIZED**: Plan must optimize for efficient code generation workflow
- **TESTABLE APPROACH**: Testing strategy must be integrated into implementation planning


### 🔧 PLANNING EXCELLENCE STANDARDS

- **ACTIONABLE TASKS**: Every implementation unit must be actionable and well-defined
- **REALISTIC ESTIMATES**: Time and effort estimates must be realistic and evidence-based
- **CLEAR DEPENDENCIES**: All dependencies must be clearly identified and documented
- **QUALITY INTEGRATION**: Quality assurance must be built into every implementation phase
- **CONTINUOUS FEEDBACK**: Feedback loops and course correction mechanisms must be included


### 📋 PROFESSIONAL DOCUMENTATION

- **DEVELOPER CLARITY**: Document must provide clear guidance for development teams
- **IMPLEMENTATION GUIDANCE**: Provide detailed, actionable guidance for code generation
- **DECISION RATIONALE**: Document reasoning for all implementation sequencing decisions
- **COMPLETE COVERAGE**: Address all aspects from foundation setup through deployment


### 🚨 QUALITY ASSURANCE REQUIREMENTS

- **NO HALLUCINATION**: Only include information explicitly stated in or derivable from input documents
- **USE "TBD" FOR GAPS**: When required information is missing, use "TBD" and note what's needed
- **EVIDENCE-BASED**: Support all recommendations with specific evidence from design documents
- **OBJECTIVE EVALUATION**: Use consistent, objective criteria for all implementation assessments
- **COMPREHENSIVE VALIDATION**: Include validation approaches for all implementation decisions


## Output Format

**Start your response with the complete Implementation Function Planning Document following the structure above.**

**Generate a professional, comprehensive implementation plan that:**

1. Addresses every implementation requirement from Low-Level Design
2. Provides optimal sequencing for code generation efficiency
3. Includes comprehensive dependency mapping and risk management
4. Addresses quality assurance and testing integration throughout implementation
5. Provides detailed phase-by-phase implementation guidance
6. Maintains complete traceability to technical design documents
7. Provides actionable guidance for development and code generation teams
8. Follows software engineering best practices and proven implementation patterns

**If any required information is missing from the input documents, use "TBD" and clearly note what additional information is needed for complete implementation planning.**

**The resulting Implementation Function Planning document should be suitable for:**

- Development team implementation guidance
- Code generation optimization and sequencing
- Project management and timeline planning
- Quality assurance and testing coordination
- Risk management and mitigation planning
- Technical architecture validation and implementation