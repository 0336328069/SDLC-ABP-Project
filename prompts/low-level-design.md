# Low-Level Design Prompt

Create Low-Level Design document for `[FeatureName]` based on provided documents.

**Input Documents:**
- SRS&DM_[FeatureName]_v1.0.md
- HighLevelDesign_[FeatureName].md  
- ERD_[FeatureName].md
- CodeConventionDocument_[FeatureName].md
- TechStack.md

**Output:** `docs/DEV/LowLevelDesign_[FeatureName].md`

## Document Structure:

### 1. Executive Summary
- Module purpose and scope
- Architecture pattern
- Technology stack
- Key components

### 2. Domain Layer
- Domain model and bounded context
- Entities from ERD with properties and relationships
- Value objects and domain services
- Code examples

### 3. Application Layer  
- Application services for main use cases
- DTOs and AutoMapper configuration
- Validation rules
- Code examples

### 4. Infrastructure Layer
- Repository implementations
- EF Core configurations
- External service integrations
- Code examples

### 5. Presentation Layer
- API controllers with endpoints
- Frontend components (React/Next.js)
- State management
- Code examples

### 6. Security & Cross-Cutting
- Authentication and authorization
- Logging and exception handling
- Performance considerations
- Code examples

### 7. Testing & Deployment
- Unit and integration testing strategy
- Performance optimization
- Deployment configuration
- Implementation checklist

## Instructions:
- Extract info from provided documents only
- Use technology stack from TechStack.md
- Mark missing details as "TBD: [detail]"
- Provide code examples for key components
- Execute immediately without questions

**START NOW** - Create complete document and save to `docs/DEV/LowLevelDesign_[FeatureName].md`
