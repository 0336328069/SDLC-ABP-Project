# Universal API Swagger Documentation Automation Prompt

## Context

You are a Senior API Designer and Documentation Specialist.
Your task is to create a comprehensive OpenAPI/Swagger specification document for the feature `[FeatureName]` based **strictly** on the API requirements and technical specifications provided below.

- Do not assume or invent any API endpoints, request/response schemas, or authentication methods unless they are clearly described in the input documents.
- Always extract actual API requirements, data models, and integration specifications directly from the context.
- **Only include information explicitly documented in the Low Level Design (LLD).**
- If the documentation lacks a detail, explicitly use **TBD** for the missing value, and do not fill it in by assumption.

## Dev Documentation (provided in full as context):

- PRD_[FeatureName]_v1.0.md
- SRS&DM_[FeatureName]_v1.0.md
- US_[FeatureName]_v1.0.md
- Vision_[FeatureName]_v1.0.md
- TechStack.md
- team-capabilities-file.md
- Technical_Feasibility_[FeatureName].md
- HighLevelDesign_[FeatureName].md
- ERD_[FeatureName].md
- LowLevelDesign_[FeatureName].md

---

## Output Requirement

Produce a file: `API_Swagger_[FeatureName].yaml` with the following OpenAPI 3.0.3 specification:

- **ADHERE TO OPENAPI 3.0.3 STRUCTURE**: Use the exact structure and field names as in the template below, with valid YAML formatting.
- **INCLUDE ALL REQUIRED COMPONENTS**: Ensure schemas, paths, parameters, responses, and security schemes are fully defined.
- **EXTRACT FROM LOW LEVEL DESIGN ONLY**: Only include information explicitly documented in the LLD. Do not infer, hallucinate, or invent any endpoints, schemas, or security requirements.
- **USE 'TBD' FOR MISSING INFORMATION**: For any required field missing from the LLD, use 'TBD' (not empty string, not null, not omitted).
- **STRICT DTO MAPPING**: Schemas must exactly match LLD DTOs; do not add undocumented properties.
- **STRICT ENDPOINT MAPPING**: Only include endpoints and HTTP methods explicitly defined in LLD controller methods.
- **STRICT SECURITY MAPPING**: Only include security requirements and schemes explicitly defined in LLD.
- **STRICT $REF VALIDATION**: All $ref values must point to existing paths in components.schemas or components.responses.
- **NO GENERIC CRUD**: Do not create generic CRUD operations unless specifically mentioned in LLD.
- **NO EXPLANATION**: Output only the YAML specification, no additional explanation or commentary.

### YAML SYNTAX VALIDATION CHECKLIST
- Indentation uses exactly 2 spaces (no tabs).
- All string values are quoted (e.g., "200", "get").
- Boolean values are lowercase (true/false).
- HTTP status codes are quoted (e.g., "200", "404").
- HTTP methods are lowercase (get, post, put, delete).
- $ref values are quoted and point to valid paths (e.g., "#/components/schemas/TBDSchema").
- Required arrays use YAML list syntax (e.g., - prop1).
- Parameter 'in' values are valid (query, path, header, cookie).
- Schema types are valid (string, integer, number, boolean, array, object).
- Enum values are in array format (e.g., - option1).
- Arrays include items schema definition.
- Email fields use valid format (e.g., "support@example.com").
- No trailing commas.
- No empty strings (use "TBD" instead).

---

## Enhanced Guidelines for API Documentation Context

- **Only** document API endpoints, schemas, and security that are explicitly required and documented in the LLD.
- **Do not** create generic CRUD operations unless specifically mentioned in requirements.
- **Mark all missing API details as**
  > **TBD**
- **Never** assume authentication methods or security requirements unless stated in documentation.
- **Strictly validate all $ref, security, schema, and endpoint mappings against the LLD.**
- Write in OpenAPI 3.0.3 YAML format with proper structure and validation.
- **Do not include any explanation, commentary, or extra text. Output only the YAML.**

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs as plain text under the prompt.
- Feed the combined text into your preferred AI API documentation tool.
- Use this specification for API development, testing, and client integration.
