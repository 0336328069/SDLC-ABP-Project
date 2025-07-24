# Universal Function Planning Automation Prompt Template

## Context

You are a Senior Solution Architect.  
Your task is to create a comprehensive, actionable, step-by-step implementation plan for the feature `[FeatureName]` based **strictly** on the technical documentation and conventions provided below.  
This documentation defines the project's tech stack, architectural patterns, codebase structure, naming conventions, workflows, and any other rules relevant for development.

- Do not assume or invent any technology, subfolder, file name, code snippet, standard, convention, or migration procedure unless it is clearly described in the technical documents below.
- Always extract actual tech stack, framework, file/folder paths, naming styles, and workflow steps directly from the context (e.g. llms.txt, CodeConventionDocument, project-specific README).
- If the documentation lacks a detail, explicitly note it as an open question using **TBD: [missing detail]**, and do not fill it in by assumption.

## Dev Documentation (provided in full as context):
- SystemArchitectureDesign_[FeatureName]_v1.0.md
- HighLevelDesign_[FeatureName]_v1.0.md
- ERD_[FeatureName]_v1.0.md
- CodeConventionDocument_[FeatureName]_v1.0.md
- LowLevelDesign_[FeatureName]_v1.0.md
- API_Swagger_[FeatureName]_v1.0.yaml or .md
- llms.txt (project tech stack, workflow, naming, conventions, toolchain)
- [Optionally] README.md or equivalent (if included in input context)

---

## Output Requirement

Produce a file: `ImplementPlan_[FeatureName]_v1.0.md` that provides all of the following sections (adapt section details based only on context):

### 1. Executive Summary
- Summarize the purpose, technical strategy, key architectural decisions, and target outcomes for `[FeatureName]`—using only context facts.

### 2. Development Phases
- Break the implementation into clear, ordered, and independent phases.  
- Each phase must specify: required inputs, expected artifacts/files/classes, and handoff/done criteria.

### 3. Backend Implementation Plan
- For every backend module/folder defined in the documentation, detail:
    - Concrete file path(s) and naming, exactly according to conventions/context.
    - Class/interface responsibilities and relationships.
    - Method signatures, DTO/model definitions, and example code where context provides it.
    - All code, migration, and configuration actions must follow the described frameworks and conventions.
    - For DB: reference migrations, schema updates, scripts, and tools as specified in the docs.

### 4. Frontend Implementation Plan (if context includes a frontend)
- Map each backend endpoint to frontend file/component/page/service according to project conventions.
- State validation approach and schemas, service integration, state management, routing, etc., as described in context.
- Always use the real file/folder/naming described or exemplified in the docs.

### 5. Database Migration Plan
- Describe DB/table/field/index changes, naming, location and sample migration commands/scripts strictly as described (do NOT assume "EF", "Sequelize", "Flyway", etc unless in context).

### 6. Testing Strategy
- For both backend and frontend, specify all tests, tools, folder structure and code for setup/usage as described—do not guess any library not defined in the docs.

### 7. Security Implementation
- Enumerate exactly those security requirements and mechanisms (e.g. auth, encryption, permission, validation, rate limiting...) described in the input docs, mapped to files/classes/configs as per convention.

### 8. Performance Optimization
- Lay out tuning, caching, scaling, async, or monitoring specifics as relevant for the stack in context.

### 9. Deployment Checklist
- List required environment variables, configuration, build, deployment, smoke-test steps adapted to the described tech/workflow/tools.

### 10. Validation Criteria
- List the specific technical and business acceptance criteria for `[FeatureName]`, referencing the corresponding file/class/methods/tests in codebase as per documentation.

---
## Enhanced Guidelines for Multi-stack/Enterprise Context

- **Only** use data, technology, naming, structure, workflow as specified in the input documentation (e.g. llms.txt, CodeConventionDocument, README).  
- **Do not** hallucinate, default, or infer any convention, tool, or code unless it is IN the context.  
- **Mark all missing details as**  
  > **TBD: [missing detail]**
- **Never** hard-code any stack-specific folder/file/convention (e.g., ABP, .NET, Next.js, Java, Node.js, etc) unless clearly defined in input.
- Write in concise, actionable English.

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs (llms.txt, CodeConventionDocument, etc) as plain text under the prompt—never as file references, always raw content.
- Feed the combined text into Gemini CLI, Claude, or your preferred AI codegen tool.
- Use this plan for both automated code generation and onboarding/review.

---

**Note:**  
This multi-stack prompt ensures all guidance comes from your actual project input—never from hard-coded or assumed best practices. All sections are required and must be present; any information lacking from context must be called out as an open question for the project team to clarify.