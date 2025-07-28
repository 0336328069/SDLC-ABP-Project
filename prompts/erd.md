# Universal Entity Relationship Diagram Automation Prompt

## Context

You are a Senior Database Architect and Data Modeler.
Your task is to create a comprehensive Entity Relationship Diagram (ERD) and data model documentation for the feature `[FeatureName]` based **strictly** on the business requirements and data specifications provided below.

- Do not assume or invent any entities, relationships, attributes, or database constraints unless they are clearly described in the input documents.
- Always extract actual data requirements, business entities, and data relationships directly from the context.
- If the documentation lacks a detail, explicitly note it as an open question using **TBD: [missing data requirement]**, and do not fill it in by assumption.

## Dev Documentation (provided in full as context):

- PRD_[FeatureName]_v1.0.md
- SRS&DM_[FeatureName]_v1.0.md
- TechStack.md

---

## Output Requirement

**IMPORTANT: You must create and save the output file to the correct location: `docs/DEV/ERD_[FeatureName].md`**

**CRITICAL INSTRUCTIONS:**
1. **File Creation**: Generate the complete ERD document and save it as `docs/DEV/ERD_[FeatureName].md`
2. **File Path**: Ensure the file is created in the `docs/DEV/` directory
3. **Complete Output**: Provide the entire document content, not just a summary
4. **Format**: Use proper Markdown formatting with headers, tables, and Mermaid diagrams
5. **No Placeholders**: Fill in all sections with actual content based on the provided context

Produce a complete file: `docs/DEV/ERD_[FeatureName].md` with the following sections:

### 1. Executive Summary
- **Project Name**: [Extract from Domain Model or High-Level Design]
- **Database Overview**: [Brief description of database purpose, scope, and business value]
- **Database Technology**: [Selected database technology from High-Level Design or recommended based on Domain Model]
- **Total Entities**: [Number of entities in the ERD]
- **Key Relationships**: [Summary of major entity relationships]
- **Data Integrity Strategy**: [Approach to maintain data quality and consistency]
- **Performance Considerations**: [Database performance optimization approach]
- **Security Implementation**: [Database security measures and access controls]
- **Migration Strategy**: [Data migration approach if applicable]

**Document Information**:
- **Version**: 1.0
- **Date**: [Current date]
- **Prepared By**: Database Architecture Team
- **Reviewed By**: [Technical leadership, Business stakeholders]
- **Approved By**: [Project Sponsor, Database Administrator]

### 2. Domain Model Analysis
- **2.1 Domain Entities Analysis**: Extract and analyze core business entities from Domain Model
  - Core Domain Entities: [Purpose, significance, core attributes]
  - Entity Categories: Master Data, Transaction Data, Reference Data, Audit Data
- **2.2 Domain Relationships Analysis**: Extract and analyze relationships between entities
  - Primary Relationships: [Entities, cardinality, business rules]
  - Relationship Categories: Aggregation, Composition, Association, Inheritance
- **2.3 Domain Rules and Constraints**: Business rules and constraints for entities and relationships
  - Entity Rules: Mandatory attributes, unique constraints, value constraints, business validation
  - Relationship Rules: Cardinality, referential integrity, cascade rules

### 3. Technical Architecture Analysis
- **3.1 System Architecture Assessment**: System architecture, database technology selection, integration requirements
- **3.2 Performance and Scalability Analysis**: Data volume, transaction volume, growth rate, concurrent users, performance targets
- **3.3 Security and Compliance Analysis**: Authentication, authorization, encryption, audit logging, compliance

### 4. Entity Relationship Diagram
- **4.1 ERD Overview**: Database design pattern, normalization level, total entities, total relationships, design principles
- **4.2 ERD Diagram**:
  - Mermaid ERD Diagram: All entities, attributes, relationships
  - ERD Diagram Notes: Relationship notation, key notation, attribute types
  - Alternative Text-Based ERD (if needed)
- **4.3 Entity Definitions**:
  - For each entity: Purpose, business rules, attributes (table), indexes, relationships, validation rules, data volume estimation

### 5. Performance Optimization
- **5.1 Indexing Strategy**: Index design philosophy, maintenance
  - Primary Indexes Table: Entity, index, type, columns, purpose, usage
  - Secondary Indexes Table: Entity, index, type, columns, purpose, query pattern
- **5.2 Query Optimization**: Query performance strategy, common query patterns (table)

### 6. Security and Access Control
- **6.1 Database Security Model**: Security architecture, authentication, authorization
- **6.2 User Roles and Permissions**: RBAC strategy, database roles (table)
- **6.3 Data Classification and Protection**: Data classification, sensitivity levels (table)

### 7. Implementation Strategy
- **7.1 Database Implementation Approach**: Methodology, environment, version control
- **7.2 Implementation Timeline**: Phased plan, deliverables, success criteria
- **7.3 Data Migration Strategy**: Migration approach, tools, validation, migration plan (table)

### 8. Requirements Traceability
- **8.1 Domain Model Mapping**: Table mapping domain entity to database entity, attributes, relationships, notes
- **8.2 Technical Requirements Mapping**: Table mapping requirement to database feature, implementation, success criteria
- **8.3 Business Rules Mapping**: Table mapping domain rule to database constraint, implementation, validation

---

## Enhanced Guidelines for Data Modeling Context

- **Only** use entities, attributes, and relationships that are explicitly described in business requirements.
- **Do not** create generic or assumed data structures beyond what business needs specify.
- **Mark all missing data details as**
  > **TBD: [missing data requirement]**
- **Never** assume database technology specifics unless clearly stated in TechStack.md.
- Write in clear, data-focused language suitable for developers and business analysts.
- For every design decision, provide validation/justification and, where possible, a validation approach.
- Do not reference input file names in the output document.

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs as plain text under the prompt.
- Feed the combined text into your preferred AI data modeling tool.
- Use this ERD for both database implementation and business validation.

## FINAL INSTRUCTION:
**CRITICAL**: After generating the ERD content, you MUST:
1. **Create the complete file** with all sections filled out
2. **Save it to the correct path**: `docs/DEV/ERD_[FeatureName].md`
3. **Provide the full document content** in your response
4. **Do not stop until the entire document is complete**
5. **Include all required sections** with actual content, not placeholders
