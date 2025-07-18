# Function Planning Automation Prompt Template

## Context

You are a Senior Solution Architect specializing in ABP Framework (.NET 9.0, ABP 8.3.0) with Next.js 14+.
You are implementing the feature `[FeatureName]` under an enterprise application with DDD, Clean Architecture, Modular Monolith, as defined by the technical stack and workflow in `llms.txt` and `README.md`.  
All business requirements have already been translated into technical documentation by the DEV team. Your goal is to deliver a step-by-step technical implementation plan mapped to the exact project structure.

## Input Files (read from `/docs/`):

Use **only** the following as input context:
- TechnicalFeasibilityAnalysis_[FeatureName]_v1.0.md
- SystemArchitectureDesign_[FeatureName]_v1.0.md
- HighLevelDesign_[FeatureName]_v1.0.md
- ERD_[FeatureName]_v1.0.md
- CodeConventionDocument_[FeatureName]_v1.0.md
- LowLevelDesign_[FeatureName]_v1.0.md
- API_Swagger_[FeatureName]_v1.0.yaml
- llms.txt (overall tech stack, workflow, folder conventions)
- [Optionally] README.md (if you need explicit folder mapping)

> **Never** use any raw BA/Product files at this step – all domain/business logic has been fully incorporated into the above documentation.

## Output Requirements

Create a file named `ImplementPlan_[FeatureName]_v1.0.md` with the following structure.  
**All instructions must be in clear, actionable, technical English and directly map to the real codebase.**

---

### 1. Executive Summary

- Summarize the purpose, technical approach, overall architecture, and target outcomes for `[FeatureName]`.

### 2. Development Phases

- Break implementation into ordered, independent phases. Each phase must have inputs, expected artifacts, and handoff criteria.

### 3. Backend Implementation Plan

- For each ABP project/folder (`AbpApp.Domain`, `AbpApp.EntityFrameworkCore`, `AbpApp.Application.Contracts`, `AbpApp.Application`, `AbpApp.HttpApi`, `AbpApp.HttpApi.Host`), specify:
    - Concrete file path(s) to create/modify (e.g. `src/backend/src/AbpApp.Domain/[FeatureName]/[NewEntity].cs`)
    - Class/interface responsibilities and relationships
    - Key method signatures, example DTOs/interface definitions (with code where relevant)
    - Reference all applicable conventions and workflow steps from input docs
    - For migrations: DbSet locations, script samples, and required CLI commands

### 4. Frontend Implementation Plan

- Map backend endpoints to precise frontend files (`/app/`, `/components/`, `/services/`, `/stores/`, etc).
- Specify relevant Zod schemas, service module setup, React Hooks (TanStack Query), and NextAuth.js flows.
- Provide filenames, key function signatures, and code samples where needed.

### 5. Database Migration Plan

- Describe all necessary DB migrations (tables/fields/constraints/indexes)
- List commands and migration file names, mapping them to project scripts/tools

### 6. Testing Strategy

- Backend: Outline unit, integration, and (if relevant) end-to-end tests with test file locations and sample cases.
- Frontend: Outline component, page, and E2E tests with locations and examples.
- All test cases must point to the critical flows and negative cases from the requirements.

### 7. Security Implementation

- Explicitly enumerate and describe security mechanisms (passwords, tokens, permissions, rate limiting, etc) as implemented for this feature.
- Map each non-functional security requirement to technical design/spec in the codebase.

### 8. Performance Optimization

- Identify and plan necessary caching, async processing, concurrency strategies, and logging/metrics related to `[FeatureName]`.

### 9. Deployment Checklist

- Document all required environment variables, configuration, build, database update, and smoke test steps for this feature.

### 10. Validation Criteria

- List all technical validation criteria for `[FeatureName]`, referencing file/class/method/test for audits and code review traceability.

---

**Guidelines:**
- Use only information available in the input files; never hallucinate about business flow, tech stack, or folder structure.
- All output instructions must be clear, actionable, stepwise, and suitable for direct code generation by Gemini CLI/Claude or for onboarding a developer.
- All references (paths, classes, functions) must match the current codebase (as per screenshots above).
- Write output in precise technical English. Do not include or repeat architectural background—assume all info is already in docs.

---

**How to Use:**  
- Replace `[FeatureName]` with the specific domain or module you are implementing (e.g., `Authentication`, `OrderManagement`).
- This prompt is reusable for any feature.  
- Feed it, plus the relevant feature’s Dev Docs, into Gemini CLI or your SDLC automation workflow.

---
