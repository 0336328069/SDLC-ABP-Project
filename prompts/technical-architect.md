# Universal System Architecture Design Automation Prompt

## Context

You are a Lead System Architect and Chief Security Architect.  
Your task is to design a comprehensive, actionable enterprise system architecture and security framework for the use case below, strictly according to the provided documentation.

- Do **not** assume or invent any technology, folder, file name, code snippet, standard, or convention unless it is clearly described in these input documents.
- Only extract tech stack, frameworks, structure, naming, policies, and workflow from these files.
- If any detail is missing, explicitly note it as an open question using **TBD: [missing detail]**.

## Dev Documentation (provided in full as context):

- PRD_[FeatureName]_v1.0.md
- SRS&DM_[FeatureName]_v1.0.md
- TechStack.md
- Technical_Feasibility_[FeatureName].md

> *(All contents are provided in full after this prompt.  Use only facts, requirements, and conventions found in these documents.  
If any file/section is missing or empty, list it as “TBD: [detail]”. Never assume or invent any technology or best practice beyond what is present.)*

---

## Output Requirement

**IMPORTANT: You must create and save the output file to the correct location: `docs/DEV/System_Architecture_Design_[FeatureName].md`**

**CRITICAL INSTRUCTIONS:**
1. **File Creation**: Generate the complete System Architecture Design document and save it as `docs/DEV/System_Architecture_Design_[FeatureName].md`
2. **File Path**: Ensure the file is created in the `docs/DEV/` directory
3. **Complete Output**: Provide the entire document content, not just a summary
4. **Format**: Use proper Markdown formatting with headers, tables, and diagrams
5. **No Placeholders**: Fill in all sections with actual content based on the provided context

Produce a complete file: `docs/DEV/System_Architecture_Design_[FeatureName].md` with all required architecture and security sections. Use only the information in the above documents; list **TBD: [missing detail]** for anything missing.

---

### 1. Executive Summary
- Brief overview of system vision, key requirements, architectural strategy, and security posture—using only actual facts from input files.
- Security strategy integration
- Architecture overview (style, boundaries, drivers, security framework)

### 2. Architecture Principles and Patterns
- **Design Principles**: List of key architectural principles, rationale, impact on design, security principle integration
- **Security Principles**: List of key security principles, rationale, impact on security design
- **Architectural Patterns**: Primary patterns used, rationale, implementation considerations, security pattern integration

### 3. Architecture Requirements & Inputs
- Enumerate the input files and summarize which requirement(s) or analysis each one provides.
- State scope boundaries, assumed business drivers, and compliance targets as given in requirements.

### 4. System Component Architecture
- **Core Components Table**: | Component | Purpose | Responsibilities | Technology Stack | Security Integration | Dependencies |
- **Component Interfaces Table**: | Component | Interface Type | Consumers | Data Contract | Security Requirements | SLA Requirements |
- **Shared Services Table**: | Service | Purpose | Capabilities | Consumers | Security Controls | Scalability Strategy |
- **Data Entities Table**: | Entity | Purpose | Key Attributes | Relationships | Security Classification | Storage Requirements |

### 5. Technology Stack (by Layer)
- **Presentation Layer**: Web frontend, mobile, admin, justification, framework, UI library, state management, build tools, testing, security, team readiness, complexity, cost
- **API Layer**: Required, justification, framework, style, gateway, documentation, versioning, rate limiting, authentication, authorization, security, real-time, cost
- **Business Logic Layer**: Language, framework, patterns, rule/workflow engine, event processing, security, testing, cost
- **Data Access Layer**: ORM/ODM, drivers, pooling, optimization, validation, security, cost
- **Data Storage Layer**: Primary/secondary DB, caching, search, file storage, backup, encryption, cost
- **Infrastructure Layer**: Cloud, container, orchestration, mesh, load balancer, CDN, CI/CD, IaC, security, cost

### 6. Security & Compliance Architecture
- **Security Framework Strategy**: Principles, rationale, impact
- **Risk Assessment and Threat Landscape**: Threats, business impact, modeling, risk tolerance, mitigation
- **Security Governance Model**: Organization, roles, policy
- **Identity and Access Management**: IAM, authentication, MFA, authorization, role definitions, PAM, cost
- **Data Protection and Privacy**: Classification, encryption, DLP, privacy compliance, cost
- **Security Operations**: SOC, monitoring, incident response, vulnerability management, security testing, cost

### 7. Data Architecture
- Entity/data model, schema, key relationships, classification, storage strategy as specified.
- Data classification, encryption, privacy, DLP, compliance mapping

### 8. Performance, Scalability & Risk
- **Performance Requirements Table**: | Metric | Target | Components | Security Impact | Measurement Method |
- **Caching Strategy**: Browser, CDN, app, DB, security
- **Database Optimization**: Indexing, query, pooling, security
- **Scaling Strategy**: Horizontal/vertical, auto-scaling, load balancing, security
- **Growth Projections Table**: | Timeframe | User Growth | Data Growth | Transaction Growth | Security Requirements | Infrastructure Requirements | Cost Projections |
- **Risk Assessment Table**: | Risk ID | Category | Description | Probability | Impact | Risk Score | Mitigation Strategy | Security Implications |

### 9. Implementation Roadmap
- Phased plan: Foundation/Security, Core Implementation, Advanced/Optimization
- For each phase: duration, objectives, deliverables, team, risk

### 10. Cost Analysis
- **Infrastructure Service Costs Table**: | Service Name | Service Type | Service Tier | Usage Metrics | Security Features | Monthly Cost |
- **Security Services Table**: | Service Name | Category | Provider | Service Tier | Coverage | Monthly Cost |
- **Database and Storage Services Table**: | Service Name | Provider | Service Tier | Database Type | Security Features | Specifications | Monthly Cost |
- **Monthly Cost Breakdown**: Cloud, DB, storage, networking, security, IAM, monitoring, CI/CD, API, compliance, total

### 11. Compliance and Audit Framework
- **Regulatory Compliance Table**: | Regulation | Applicable | Requirements | Technical Controls | Audit Frequency | Compliance Cost |
- **Audit Trail**: Logging, retention, reporting
- **Documentation Requirements**: Architecture, security, compliance

### 12. Monitoring and Observability
- **Application Monitoring**: APM, metrics, alerting, cost
- **Security Monitoring**: SIEM, threat detection, metrics, cost
- **Infrastructure Monitoring**: Solution, resource, metrics, cost

### 13. Disaster Recovery and Business Continuity
- **Backup Strategy**: Frequency, retention, security, cost
- **Disaster Recovery**: RTO, RPO, strategy, cost
- **Business Continuity**: Planning, communication, testing

### 14. Architecture Decision Records
- For each decision: title, status, context, decision, consequence, security implication

### 15. Appendices
- **Technology Comparison Matrix**: Comparison of all evaluated technologies
- **Security Control Matrix**: Mapping of all security controls
- **Cost Breakdown Details**: Detailed cost analysis
- **Risk Register**: List of all risks and mitigation
- **Glossary of Terms**: Technical and security glossary
- **References**: References, standards, and documentation

### 16. Document Approval
- **Approval Table**: | Role | Name | Signature | Date |
- **Distribution List**: Executive, Project, Technical, Security, Finance, Risk, Compliance team

---

## Enhanced Guidelines

- **Never** hallucinate extra detail, naming, folder, tech, or pattern.
- **Never** provide best-practice defaults—stick to described content only.
- Mark each missing field or open item as  
  > **TBD: [specific item or section needed to proceed]**
- Write in professional, concise English—target audience: technical leads, architects, security engineers.
- **For every design decision, provide validation/justification and, where possible, a validation approach.**
- **Do not reference input file names in the output document.**
- **For all cost sections, use actual service pricing if available, otherwise mark as TBD.**
- **Security must be integrated throughout all sections.**
- **Start your output as a markdown document with header `# System Architecture Design: [<domain> or <feature>]` and follow the output format strictly.**
- **DO NOT append any conversational commentary, questions, or LLM/system output blocks—just the markdown structure above.**

---

## FINAL INSTRUCTION:

**CRITICAL**: After generating the System Architecture Design content, you MUST:
1. **Create the complete file** with all sections filled out
2. **Save it to the correct path**: `docs/DEV/System_Architecture_Design_[FeatureName].md`
3. **Provide the full document content** in your response
4. **Do not stop until the entire document is complete**
5. **Include all required sections** with actual content, not placeholders

**START CREATING THE FILE NOW: `docs/DEV/System_Architecture_Design_[FeatureName].md`**

---
