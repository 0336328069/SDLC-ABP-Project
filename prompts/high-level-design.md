# Universal High-Level Design Automation Prompt

## Context

You are a Senior Solution Architect and System Designer.
Your task is to create a comprehensive, actionable High-Level Design (HLD) document for the feature `[FeatureName]` based **strictly** on the technical documentation and requirements provided below.

- Do not assume or invent any system architecture, technology stack, infrastructure pattern, integration approach, or deployment model unless it is clearly described in the input documents.
- Always extract actual business requirements, functional specifications, system boundaries, and architectural constraints. If the documentation lacks a detail, explicitly note it as an open question using **TBD: [missing detail]**, and do not fill it in by assumption.

## Dev Documentation (provided in full as context):

- PRD_[FeatureName]_v1.0.md
- SRS&DM_[FeatureName]_v1.0.md
- TechStack.md
- Technical_Feasibility_[FeatureName].md

---

## Output Requirement

**IMPORTANT: You must create and save the output file to the correct location: `docs/DEV/HighLevelDesign_[FeatureName].md`**

**CRITICAL INSTRUCTIONS:**
1. **File Creation**: Generate the complete High-Level Design document and save it as `docs/DEV/HighLevelDesign_[FeatureName].md`
2. **File Path**: Ensure the file is created in the `docs/DEV/` directory
3. **Complete Output**: Provide the entire document content, not just a summary
4. **Format**: Use proper Markdown formatting with headers, tables, and diagrams
5. **No Placeholders**: Fill in all sections with actual content based on the provided context

Produce a complete file: `docs/DEV/HighLevelDesign_[FeatureName].md` with the following sections:

### 1. Executive Summary
- System overview and architectural vision for `[FeatureName]`
- Key architectural decisions and rationale
- Business drivers and technical constraints
- High-level technology choices and integration approach
- Implementation strategy and timeline (phased if applicable)
- Risk assessment summary
- Success criteria (technical, business, delivery)

### 2. Requirements Analysis
- **2.1 Business Requirements Summary**: Extract and summarize key business requirements from input docs
  - Core business functions, user requirements, integration needs, business rules
  - Business constraints: effort, timeline, compliance, organizational
- **2.2 Technical Requirements Analysis**: Performance, quality attributes, security, scalability, etc.
- **2.3 Technical Architecture Analysis** (if applicable):
  - Current architecture, technology stack, system components, integration points, infrastructure
  - Gap analysis: functional, technical, performance, security, scalability
  - Migration/enhancement considerations
- **2.4 Technology and Team Constraints**: Existing infrastructure, standards, team skills, learning capacity, resource availability

### 3. Technology Selection
- **3.1 Technology Selection Criteria**: Requirements alignment, architecture compatibility, team capabilities, organizational fit, effort, maturity, migration feasibility
- **3.2 Recommended Technology Stack**:
  - Frontend: technology, justification, benefits, implementation considerations, effort
  - Backend: technology, justification, benefits, implementation considerations, effort
  - Database: technology, justification, benefits, implementation considerations, effort
  - Development & Deployment: tools, CI/CD, testing, monitoring, effort estimation
- **3.3 Alternative Technology Options**: Alternatives, decision factors, migration path

### 4. System Architecture Overview
- **Overall Architecture Pattern**: (microservices|monolithic|serverless|hybrid|other)
- **System Boundaries**: Internal vs external system interfaces
- **Core Components**: Major system modules and their responsibilities
- **Technology Stack Summary**: Based strictly on TechStack.md specifications
- **Deployment Architecture**: Environment and infrastructure overview

### 5. Functional Architecture
- **Business Logic Components**: Core business rule processing modules
- **Data Flow Architecture**: How data moves through the system
- **Integration Points**: Internal service communication patterns
- **User Interface Architecture**: Presentation layer organization
- **External Dependencies**: Third-party services and APIs

### 6. Technical Architecture Layers
- **Presentation Layer**: UI frameworks, client applications, user interaction patterns
- **Application Layer**: Business logic, workflow engines, service orchestration
- **Data Layer**: Database architecture, data access patterns, caching strategy
- **Infrastructure Layer**: Server architecture, containerization, networking
- **Security Layer**: Authentication, authorization, data protection

### 7. System Components and Interfaces
- **Component Diagram**: Visual representation of major system components
- **Interface Specifications**: API contracts and communication protocols
- **Data Models**: High-level entity relationships and data structures
- **Service Dependencies**: Component interaction and dependency mapping

### 8. Performance and Scalability Design
- **Performance Requirements**: Response time, throughput, availability targets
- **Scalability Strategy**: Horizontal and vertical scaling approaches
- **Load Distribution**: Load balancing and traffic management
- **Resource Optimization**: Caching, CDN, database optimization strategies

### 9. Security Architecture
- **Security Framework**: Overall security approach and principles
- **Authentication & Authorization**: User access control mechanisms
- **Data Security**: Encryption, data protection, privacy compliance
- **Network Security**: Communication security, firewall, API security
- **Security Implementation Strategy**: Secure coding, security testing, code review, configuration, update management, incident response

### 10. Integration Architecture
- **Internal Integrations**: Service-to-service communication patterns
- **External Integrations**: Third-party API integration approaches
- **Messaging Architecture**: Event-driven communication, queues, brokers
- **Error Handling**: Fault tolerance, retry mechanisms, circuit breakers

### 11. Technology Stack and Infrastructure
- **Development Stack**: Programming languages, frameworks, development tools
- **Runtime Environment**: Application servers, containers, orchestration
- **Database Technology**: Primary and secondary storage solutions
- **Infrastructure Components**: Cloud services, networking, monitoring

### 12. Deployment and DevOps Strategy
- **Deployment Model**: On-premise, cloud, hybrid deployment approach
- **CI/CD Pipeline**: Build, test, deployment automation
- **Environment Strategy**: Development, staging, production environments
- **Monitoring and Logging**: System observability and troubleshooting
- **Implementation Timeline**: Phased plan with deliverables, effort estimation, and success criteria for each phase

### 13. Requirements Traceability
- **Functional Requirements Mapping**: Table mapping each requirement to component, technology, validation method
- **Non-Functional Requirements Mapping**: Mapping each non-functional requirement to design decision, technology, success criteria
- **Security Requirements Mapping**: Mapping each security requirement to design approach, implementation, validation

### 14. Success Criteria
- **Technical Success Criteria**: Functional completeness, performance, security, integration, quality
- **Business Success Criteria**: User acceptance, business process support, compliance, development efficiency
- **Delivery Success Criteria**: Timeline, effort, quality, team capability

### 15. Risk Management
- **Technical Risks**: Key technical risks and mitigation strategies
- **Project Risks**: Timeline, resource, delivery risks
- **Mitigation Monitoring**: How risks are monitored and managed

### 16. Team Organization and Training
- **Team Structure**: Development team organization and responsibilities
- **Skill Requirements**: Key skills needed for implementation
- **Training Plan**: Technology training and knowledge transfer plan

---

## Enhanced Guidelines for Multi-stack/Enterprise Context

- **Only** use architectural patterns, technology choices, and design decisions as specified in the input documentation.
- **Do not** default to popular or trendy technologies unless explicitly mentioned in context.
- **Mark all missing architectural details as**
  > **TBD: [missing architectural detail]**
- **Never** hard-code specific technologies or architectural patterns unless clearly defined in input.
- Write in clear, architectural English suitable for technical stakeholders.
- **For every design decision, provide validation/justification and, where possible, a validation approach.**
- **Do not reference input file names in the output document.**

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs as plain text under the prompt.
- Feed the combined text into your preferred AI architecture tool.
- Use this design for both technical team guidance and stakeholder communication.

---

## FINAL INSTRUCTION:

**CRITICAL**: After generating the High-Level Design content, you MUST:
1. **Create the complete file** with all sections filled out
2. **Save it to the correct path**: `docs/DEV/HighLevelDesign_[FeatureName].md`
3. **Provide the full document content** in your response
4. **Do not stop until the entire document is complete**
5. **Include all required sections** with actual content, not placeholders

**START CREATING THE FILE NOW: `docs/DEV/HighLevelDesign_[FeatureName].md`**
