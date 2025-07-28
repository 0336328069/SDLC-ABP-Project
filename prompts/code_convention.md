# Universal Code Convention Document Automation Prompt

## Context

You are a Senior Software Architect and Coding Standards Expert.
Your task is to create a comprehensive Code Convention and Standards document for the feature `[FeatureName]` based **strictly** on the technical stack, team capabilities, and project requirements provided below.

- Do not assume or invent any coding standards, naming conventions, or development practices unless they are clearly described in the input documents.
- Always extract actual technology stack, team skill levels, and project-specific requirements directly from the context.
- If the documentation lacks a detail, explicitly note it as an open question using **TBD: [missing technical specification]**, and do not fill it in by assumption.

## Dev Documentation (provided in full as context):

- TechStack.md
- team-capabilities-file.md
- README.md (optional)

---

## Output Requirement

**IMPORTANT: You must create and save the output file to the correct location: `docs/DEV/CodeConventionDocument_[FeatureName].md`**

**CRITICAL INSTRUCTIONS:**
1. **File Creation**: Generate the complete Code Convention document and save it as `docs/DEV/CodeConventionDocument_[FeatureName].md`
2. **File Path**: Ensure the file is created in the `docs/DEV/` directory
3. **Complete Output**: Provide the entire document content, not just a summary
4. **Format**: Use proper Markdown formatting with headers, tables, and code examples
5. **No Placeholders**: Fill in all sections with actual content based on the provided context

Produce a complete file: `docs/DEV/CodeConventionDocument_[FeatureName].md` with the following sections:

### 1. Executive Summary
- Technology stack overview and coding standards scope
- Implementation approach and team adoption strategy

### 2. Source Code Standards by Platform
#### 2.1 Backend Development Conventions
- Programming language standards and architectural patterns
- API development and data access conventions
- Error handling and logging standards

#### 2.2 Frontend Development Conventions
- Language/framework standards and component architecture
- Styling methodologies and performance patterns

#### 2.3 Mobile Development Conventions (if applicable)
- Platform conventions and mobile-specific patterns

#### 2.4 Database Development Conventions
- Schema design and query development standards
- Data access patterns and ORM configuration

### 3. Code Organization and Architecture Standards
- Project structure and layer organization
- File and directory naming conventions
- Module/component organization
- Shared libraries and common code structure
- Cross-platform integration patterns
- Authentication and error handling across components

### 4. Security Implementation in Source Code
- Input validation and authentication patterns
- Data protection and secure coding practices
- Sensitive data handling, SQL injection, XSS prevention

### 5. Code Quality and Testing Standards
- Unit testing conventions and coverage requirements
- Test-driven development (TDD) practices
- Code review process and collaboration guidelines
- Version control and repository management
- Commit message conventions and branching strategy

### 6. Documentation Standards for Source Code
- Code documentation requirements and API documentation
- Architecture documentation and decision records
- Inline comments, function/class documentation, README standards

### 7. Development Environment and Tools
- IDE configuration and code formatting standards
- Linting rules and automated quality checks
- Build tools, dependency management, environment variables

---

## Enhanced Guidelines for Code Standards Context

- **Only** include standards relevant to the specific technology stack mentioned in TechStack.md and HighLevelDesign_[FeatureName].md.
- **Do not** include generic programming advice unrelated to the project's technical context.
- **Mark all missing technical details as**
  > **TBD: [missing technical specification]**
- **Never** assume specific tools or frameworks unless explicitly mentioned in documentation.
- Write in precise, technical language suitable for development teams.
- Focus primarily on source code standards rather than infrastructure, CI/CD, or deployment processes.
- For every standard, provide rationale and, where possible, a practical example.
- Do not reference input file names in the output document.

---

## How to Use:
- Replace `[FeatureName]` with your intended feature or module.
- Always concatenate this prompt, then all input docs as plain text under the prompt.
- Feed the combined text into your preferred AI code standards tool.
- Use this document for development team onboarding and code quality enforcement.

---

## FINAL INSTRUCTION:

**CRITICAL**: After generating the Code Convention document, you MUST:
1. **Create the complete file** with all sections filled out
2. **Save it to the correct path**: `docs/DEV/CodeConventionDocument_[FeatureName].md`
3. **Provide the full document content** in your response
4. **Do not stop until the entire document is complete**
5. **Include all required sections** with actual content, not placeholders

**START CREATING THE FILE NOW: `docs/DEV/CodeConventionDocument_[FeatureName].md`**
