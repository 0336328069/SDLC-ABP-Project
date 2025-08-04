# META-PROMPT: FRONTEND GENERATOR

## 1. VAI TRÒ
Bạn là một AI Prompt Engineer chuyên tạo prompts cho việc generate Frontend Implementation trong modern web applications theo Clean Architecture và Frontend best practices.

## 2. BỐI CẢNH
**Input cần thiết**:
1. **PRD_[FeatureName].md** - Product requirements và user flows
2. **SRS&DM_[FeatureName].md** - Software requirements specification  
3. **US_[FeatureName].md** - Use case specifications
4. **ImplementPlan_[FeatureName].md** - Implementation function planning
5. **API_Swagger_[FeatureName].yaml** - Backend API specification
6. **UI_UX_Requirements_[FeatureName].md** - UI/UX design requirements (if available)
7. **Design_System_Guidelines.md** - Design system và component library guidelines
8. **Feature Name** - Tên feature cần generate frontend
9. **Project Path** - Đường dẫn đến thư mục gốc project frontend

**Dynamic Project Information** (extracted from inputs):
- **Frontend Framework**: {AUTO_DETECT_FROM_CODEBASE_AND_IMPLEMENTPLAN}
- **Language & Runtime**: {INFER_FROM_CODE_STANDARD_AND_IMPLEMENTPLAN}
- **State Management**: {EXTRACT_FROM_IMPLEMENTPLAN_AND_CODEBASE}
- **UI Library**: {ANALYZE_FROM_PROJECT_STRUCTURE}
- **Styling Framework**: {EXTRACT_FROM_CODE_STANDARD}
- **API Integration**: {DETERMINE_FROM_SWAGGER_AND_IMPLEMENTPLAN}

## 3. MỤC TIÊU
Tạo ra một prompt chi tiết để generate Frontend Implementation cho bất kỳ feature nào, tuân thủ:
- Modern frontend architecture patterns (Component-based, State management)
- Frontend framework best practices (React, Vue, Angular, etc.)
- Responsive design và accessibility standards
- Type safety và error handling
- API integration với backend services
- Complete component testing coverage
- Performance optimization patterns
- Complete frontend documentation

## 4. TEMPLATE GENERATION PROCESS

### Bước 1: Phân tích Input Documents
```
Đọc và phân tích:
- PRD_[FeatureName].md → Extract user stories, business requirements
- SRS&DM_[FeatureName].md → Extract technical requirements và data models
- US_[FeatureName].md → Extract use case flows và user interactions
- ImplementPlan_[FeatureName].md → Extract frontend architecture details
- API_Swagger_[FeatureName].yaml → Extract API endpoints cho integration
- UI_UX_Requirements → Extract design specifications và component requirements
- Design_System_Guidelines → Extract design tokens, component library usage
```

### Bước 2: Identify Frontend Components
Từ analysis, xác định:
- **Pages/Views**: Top-level route components theo user flows
- **Components**: Reusable UI components và business logic components
- **Services**: API integration services và business logic services
- **State Management**: Global state, local state, và data flow patterns
- **Routing**: Navigation structure và route protection
- **Forms & Validation**: Input handling và validation logic
- **Error Handling**: Error boundaries và user feedback patterns

### Bước 3: Map to Frontend Structure
Ánh xạ components vào cấu trúc frontend:
```
{ProjectName}/
├── src/
│   ├── pages/{FeatureName}/              # Route-level pages
│   ├── components/{FeatureName}/         # Feature-specific components
│   ├── components/shared/                # Shared/reusable components
│   ├── services/{FeatureName}/           # API integration services
│   ├── hooks/{FeatureName}/              # Custom hooks (React) / Composables (Vue)
│   ├── stores/{FeatureName}/             # State management (Redux, Zustand, Pinia)
│   ├── types/{FeatureName}/              # TypeScript type definitions
│   ├── utils/{FeatureName}/              # Utility functions
│   └── tests/{FeatureName}/              # Component tests
└── docs/frontend/{FeatureName}/          # Frontend documentation
```

## 5. PROMPT TEMPLATE

```markdown
# FRONTEND {FEATURE_NAME} - IMPLEMENTATION PROMPT

## 1. VAI TRÒ
Bạn là một Senior Frontend Architect chuyên về Modern Frontend Development và Multi-File Code Generation.

## 2. BỐI CẢNH

### Auto-Detected Project Configuration:
- **Frontend Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **Package Manager**: {DETECTED_PACKAGE_MANAGER}
- **Build Tool**: {DETECTED_BUILD_TOOL}
- **UI Library**: {DETECTED_UI_LIBRARY}
- **State Management**: {DETECTED_STATE_MANAGEMENT}
- **Styling**: {DETECTED_STYLING_FRAMEWORK}
- **Testing Framework**: {DETECTED_TESTING_FRAMEWORK}
- **Project Structure**: {DETECTED_PROJECT_STRUCTURE}
- **Build Command**: {DETECTED_BUILD_COMMAND}

### Input Documents đã phân tích:
- **PRD_{FeatureName}.md**: {BUSINESS_REQUIREMENTS_SUMMARY}
- **SRS&DM_{FeatureName}.md**: {TECHNICAL_REQUIREMENTS_SUMMARY}
- **US_{FeatureName}.md**: {USE_CASES_SUMMARY}
- **ImplementPlan_{FeatureName}.md**: {IMPLEMENTATION_SUMMARY}
- **API_Swagger_{FeatureName}.yaml**: {API_SPECIFICATION_SUMMARY}
- **UI_UX_Requirements_{FeatureName}.md**: {DESIGN_REQUIREMENTS_SUMMARY}
- **Design_System_Guidelines.md**: {DESIGN_SYSTEM_SUMMARY}

### API Endpoints Available:
{API_ENDPOINTS_LIST}

### Design System Components:
{DESIGN_SYSTEM_COMPONENTS}

## 3. MỤC TIÊU FRONTEND IMPLEMENTATION

### 3.1 PAGE COMPONENTS
{PAGE_COMPONENTS_SECTION}

### 3.2 UI COMPONENTS
{UI_COMPONENTS_SECTION}

### 3.3 STATE MANAGEMENT
{STATE_MANAGEMENT_SECTION}

### 3.4 API INTEGRATION SERVICES
{API_SERVICES_SECTION}

### 3.5 ROUTING & NAVIGATION
{ROUTING_SECTION}

### 3.6 FORMS & VALIDATION
{FORMS_VALIDATION_SECTION}

### 3.7 ERROR HANDLING & LOADING STATES
{ERROR_HANDLING_SECTION}

### 3.8 TESTING IMPLEMENTATION
{TESTING_SECTION}

### 3.9 DOCUMENTATION
{DOCUMENTATION_SECTION}

## 4. YÊU CẦU IMPLEMENTATION
{IMPLEMENTATION_REQUIREMENTS_SECTION}

## 5. OUTPUT FORMAT
{OUTPUT_FORMAT_SECTION}

## 6. UI/UX STANDARDS
{UI_UX_STANDARDS_SECTION}

## 7. PERFORMANCE & ACCESSIBILITY
{PERFORMANCE_ACCESSIBILITY_SECTION}

## 8. BUSINESS WORKFLOWS MAPPING
{WORKFLOWS_MAPPING_SECTION}

## 9. VERIFICATION
Sau khi đã tạo tất cả các file code, hãy thực hiện build project để đảm bảo không có lỗi biên dịch.
Chạy lệnh sau từ thư mục gốc của project (`{PROJECT_PATH}`):
```bash
{DETECTED_BUILD_COMMAND}
```
Sau đó chạy tests:
```bash
{DETECTED_TEST_COMMAND}
```
Nếu có lỗi, hãy sửa các file đã tạo để khắc phục.

```

## 6. USAGE INSTRUCTIONS

### Input Required:
1. **Feature Name**: Tên feature (vd: Authentication, UserManagement, Dashboard)
2. **PRD File Path**: Đường dẫn đến PRD file
3. **SRS&DM File Path**: Đường dẫn đến SRS file
4. **US File Path**: Đường dẫn đến Use Cases file
5. **ImplementPlan File Path**: Đường dẫn đến implementation plan
6. **API_Swagger File Path**: Đường dẫn đến API specification file
7. **UI_UX_Requirements File Path**: Đường dẫn đến UI/UX requirements (optional)
8. **Design_System_Guidelines File Path**: Đường dẫn đến design system guidelines
9. **Project Root Path**: Đường dẫn đến thư mục gốc frontend project

### Execution Steps:
1. **Read và analyze input documents** (PRD, SRS, US, ImplementPlan, API_Swagger, UI_UX, Design_System)
2. **Auto-detect frontend stack** từ project files và ImplementPlan
3. **Extract user flows** từ US và PRD files
4. **Identify UI components** từ user flows và design requirements
5. **Generate prompt** sử dụng template trên với dynamic variables
6. **Customize sections** dựa trên detected stack và feature requirements
7. **Validate prompt** với frontend quality checklist
8. **Save prompt** tại `prompts/FRONTEND_{FeatureName}_Prompt.md`

## 7. TECHNOLOGY AUTO-DETECTION GUIDELINES

### 7.1 Detection Algorithm (Dynamic Instructions)
Khi chạy prompt này, bạn phải thực hiện các bước sau để auto-detect frontend stack:

**Step 1: Scan Project Structure**
```
1. Read project files từ {PROJECT_PATH}
2. Identify configuration files (package.json, tsconfig.json, vite.config.js, etc.)
3. Analyze folder structure patterns
4. Extract framework indicators từ dependencies
```

**Step 2: Framework Detection Rules**
```
- Nếu tìm thấy "package.json" + "react" → React
- Nếu tìm thấy "package.json" + "vue" → Vue.js
- Nếu tìm thấy "package.json" + "@angular/core" → Angular
- Nếu tìm thấy "package.json" + "svelte" → Svelte
- Nếu tìm thấy "package.json" + "next" → Next.js
- Nếu tìm thấy "package.json" + "nuxt" → Nuxt.js
```

**Step 3: UI Library Detection**
```
- Material-UI: @mui/material
- Ant Design: antd
- Chakra UI: @chakra-ui/react
- Tailwind CSS: tailwindcss
- Bootstrap: bootstrap
- Vuetify: vuetify (Vue)
- Angular Material: @angular/material
```

**Step 4: State Management Detection**
```
- Redux: @reduxjs/toolkit, react-redux
- Zustand: zustand
- Recoil: recoil
- Context API: (React built-in)
- Pinia: pinia (Vue)
- Vuex: vuex (Vue)
- NgRx: @ngrx/store (Angular)
```

**Step 5: Generate Dynamic Variables**
```
Từ detection results, tạo các variables cho output prompt:
- {AUTO_DETECTED_FRAMEWORK}
- {AUTO_DETECTED_LANGUAGE} 
- {AUTO_DETECTED_UI_LIBRARY}
- {AUTO_DETECTED_STATE_MANAGEMENT}
- {AUTO_DETECTED_STYLING}
- {AUTO_DETECTED_BUILD_TOOL}
- {AUTO_DETECTED_PACKAGE_MANAGER}
- {AUTO_DETECTED_TEST_FRAMEWORK}
```

### 7.2 Output Prompt Structure
Trong generated prompt, phải include section:
```markdown
## DETECTED PROJECT CONFIGURATION
- **Framework**: {AUTO_DETECTED_FRAMEWORK}
- **Language**: {AUTO_DETECTED_LANGUAGE}
- **UI Library**: {AUTO_DETECTED_UI_LIBRARY}
- **State Management**: {AUTO_DETECTED_STATE_MANAGEMENT}
- **Styling**: {AUTO_DETECTED_STYLING}
- **Build Tool**: {AUTO_DETECTED_BUILD_TOOL}
- **Package Manager**: {AUTO_DETECTED_PACKAGE_MANAGER}
- **Test Framework**: {AUTO_DETECTED_TEST_FRAMEWORK}
```

## 8. SECTION CUSTOMIZATION GUIDELINES

### 8.1 PAGE_COMPONENTS_SECTION
```markdown
Dựa trên {US_FeatureName}, implement các page components:

#### {PageName}Page
- Route: `/{page-route}`
- User Flow: {UserFlowDescription}
- Components Used: {ComponentsList}
- State Required: {StateRequirements}
- API Calls: {APICallsList}
- File: `src/pages/{FeatureName}/{PageName}Page.{ext}`

#### {AdditionalPages}
{AdditionalPageDefinitions}
```

### 8.2 UI_COMPONENTS_SECTION
```markdown
UI Components implementation theo Design System:

#### {ComponentName}
- Purpose: {ComponentPurpose}
- Props Interface: {PropsDefinition}
- Design System Usage: {DesignSystemReference}
- Accessibility: {A11yRequirements}
- File: `src/components/{FeatureName}/{ComponentName}.{ext}`

#### Shared Components
- {SharedComponent1}: {Description}
- File: `src/components/shared/{SharedComponent1}.{ext}`
```

### 8.3 STATE_MANAGEMENT_SECTION
```markdown
State management implementation using {DETECTED_STATE_MANAGEMENT}:

#### Global State
- {FeatureName}Store: {StateDescription}
- Actions: {ActionsList}
- Selectors: {SelectorsList}
- File: `src/stores/{FeatureName}/{FeatureName}Store.{ext}`

#### Local State Patterns
- Component state: {LocalStateUsage}
- Form state: {FormStateManagement}
- Loading states: {LoadingStatePatterns}
```

### 8.4 API_SERVICES_SECTION
```markdown
API integration services:

#### {FeatureName}ApiService
- Base URL: {API_BASE_URL}
- Endpoints: {APIEndpointsList}
- Error Handling: {ErrorHandlingStrategy}
- Caching: {CachingStrategy}
- File: `src/services/{FeatureName}ApiService.{ext}`

#### Types/Interfaces
- Request Types: {RequestTypesList}
- Response Types: {ResponseTypesList}
- File: `src/types/{FeatureName}.{ext}`
```

### 8.5 ROUTING_SECTION
```markdown
Routing implementation:

#### Route Configuration
- Parent Route: `/{feature-route}`
- Child Routes: {ChildRoutesList}
- Route Guards: {RouteGuardsList}
- File: `src/routes/{FeatureName}Routes.{ext}`

#### Navigation Components
- Navigation Menu: {NavigationComponents}
- Breadcrumbs: {BreadcrumbLogic}
```

### 8.6 FORMS_VALIDATION_SECTION
```markdown
Forms và validation implementation:

#### Form Components
- {FormName}: {FormPurpose}
- Fields: {FormFieldsList}
- Validation Rules: {ValidationRulesList}
- File: `src/components/{FeatureName}/forms/{FormName}.{ext}`

#### Validation Strategy
- Client-side validation: {ClientValidation}
- Server-side validation: {ServerValidation}
- Error display: {ErrorDisplayPattern}
```

### 8.7 ERROR_HANDLING_SECTION
```markdown
Error handling và loading states:

#### Error Boundaries
- Component error boundary
- Route error boundary
- File: `src/components/shared/ErrorBoundary.{ext}`

#### Loading States
- Page loading: {PageLoadingPattern}
- Component loading: {ComponentLoadingPattern}
- API loading: {APILoadingPattern}

#### User Feedback
- Toast notifications: {ToastImplementation}
- Error messages: {ErrorMessagePattern}
- Success feedback: {SuccessFeedbackPattern}
```

### 8.8 TESTING_SECTION
```markdown
Testing implementation:

#### Unit Tests
- Component tests: {ComponentTestsList}
- Service tests: {ServiceTestsList}
- Hook tests: {HookTestsList}

#### Integration Tests
- User flow tests: {UserFlowTestsList}
- API integration tests: {APITestsList}

#### Test Files
- `src/tests/{FeatureName}/{ComponentName}.test.{ext}`
- `src/tests/{FeatureName}/{ServiceName}.test.{ext}`
```

### 8.9 DOCUMENTATION_SECTION

```markdown
Frontend documentation:

#### Frontend\_{FeatureName}.md

Tạo comprehensive frontend documentation file tại `docs/DEV/Documents_Frontend_{FeatureName}.md` với nội dung:

##### Frontend Overview

- Application structure và architecture patterns
- Technology stack được sử dụng: {TechnologyStack}
- Key features và functionality implemented
- User flows và navigation structure

##### Generated Application Structure

###### File Organization
```
src/frontend/
├── app/ (hoặc pages/)      # Route-level pages
├── components/             # UI Components
├── hooks/ (hoặc composables/) # Custom hooks/composables
├── services/              # API integration
├── stores/ (hoặc state/)  # State management
├── utils/                 # Utilities
└── types/                 # Type definitions
```

###### Pages Implementation
{FOR_EACH_PAGE}

**{PageName}Page**
- **Route**: `{RoutePattern}`
- **Purpose**: {PageDescription}
- **Components Used**: {ComponentsList}
- **State Management**: {StateUsage}
- **API Integration**: {APICallsList}
- **Key Features**: {PageFeatures}

##### Generated Page Implementations

{FOR_EACH_MAIN_PAGE}

###### {PageName} Page

- **File**: `{PageFilePath}`
- **Purpose**: {PagePurpose}
- **User Experience**: {UXDescription}
- **Key Components**:
  - {Component1}: {ComponentDescription}
  - {Component2}: {ComponentDescription}
- **State Management**: {StateManagementDetails}
- **API Integration**: {APIIntegrationDetails}
- **Error Handling**: {ErrorHandlingApproach}
- **Loading States**: {LoadingStateImplementation}

##### Generated Component Implementations

{FOR_EACH_COMPONENT}

###### {ComponentName} Component

- **File**: `{ComponentFilePath}`
- **Purpose**: {ComponentPurpose}
- **Props Interface**:
  ```typescript
  {PropsInterface}
  ```
- **Features**: {ComponentFeatures}
- **Design System Usage**: {DesignSystemComponents}
- **Accessibility**: {AccessibilityFeatures}
- **Responsive Design**: {ResponsiveFeatures}

##### Generated Custom Hooks

{FOR_EACH_HOOK}

###### {HookName}

- **File**: `{HookFilePath}`
- **Purpose**: {HookPurpose}
- **Parameters**: {HookParameters}
- **Return Value**: {HookReturnValue}
- **Features**:
  - {Feature1}: {FeatureDescription}
  - {Feature2}: {FeatureDescription}
- **Error Handling**: {ErrorHandlingStrategy}
- **Caching Strategy**: {CachingImplementation}

##### Generated API Services

###### Service Architecture
- **Base Client**: {APIClientSetup}
- **Authentication**: {AuthenticationIntegration}
- **Error Handling**: {GlobalErrorHandling}
- **Request/Response Interceptors**: {InterceptorLogic}

{FOR_EACH_SERVICE}

###### {ServiceName}

- **File**: `{ServiceFilePath}`
- **Base URL**: {ServiceBaseURL}
- **Methods**: {ServiceMethods}
- **Error Handling**: {ServiceErrorHandling}
- **Type Safety**: {TypeDefinitions}

##### Generated Type Definitions

###### Type Organization
- **API Types**: Request/Response interfaces
- **Domain Types**: Business entity interfaces
- **UI Types**: Component props và state interfaces
- **Utility Types**: Helper và generic types

{FOR_EACH_TYPE_FILE}

###### {TypeFileName}
- **Purpose**: {TypePurpose}
- **Key Interfaces**: {KeyInterfaces}
- **Enums**: {EnumDefinitions}

##### State Management Implementation

###### Architecture Pattern
- **Library Used**: {StateManagementLibrary}
- **Pattern**: {StatePattern}
- **Store Organization**: {StoreStructure}

{FOR_EACH_STORE}

###### {StoreName}
- **Purpose**: {StorePurpose}
- **State Shape**: {StateStructure}
- **Actions**: {StoreActions}
- **Selectors**: {StoreSelectors}
- **Persistence**: {PersistenceStrategy}

##### UI/UX Implementation Details

###### Design System Integration
- **UI Library**: {UILibraryUsed}
- **Design Tokens**: {DesignTokens}
- **Component Consistency**: {ConsistencyApproach}

###### Responsive Design
- **Breakpoints**: {ResponsiveBreakpoints}
- **Mobile-First Approach**: {MobileFirstImplementation}
- **Touch Interactions**: {TouchOptimizations}

###### Accessibility Features
- **WCAG Compliance**: {WCAGLevel}
- **Screen Reader Support**: {ScreenReaderFeatures}
- **Keyboard Navigation**: {KeyboardNavigationSupport}
- **Focus Management**: {FocusManagementStrategy}

##### Performance Optimizations

###### Code Splitting
- **Route-based Splitting**: {RouteSplittingStrategy}
- **Component Lazy Loading**: {LazyLoadingImplementation}
- **Bundle Optimization**: {BundleOptimizations}

###### Caching Strategies
- **API Response Caching**: {APICachingStrategy}
- **Asset Caching**: {AssetCachingStrategy}
- **State Persistence**: {StatePersistenceStrategy}

###### Loading Optimizations
- **Skeleton Screens**: {SkeletonImplementation}
- **Progressive Loading**: {ProgressiveLoadingStrategy}
- **Image Optimization**: {ImageOptimizations}

##### Error Handling Strategy

###### Global Error Handling
- **Error Boundaries**: {ErrorBoundaryImplementation}
- **API Error Handling**: {APIErrorStrategy}
- **User Feedback**: {UserFeedbackMechanism}

###### User Experience
- **Loading States**: {LoadingStatePatterns}
- **Empty States**: {EmptyStateDesigns}
- **Error Recovery**: {ErrorRecoveryOptions}

##### Testing Implementation

###### Testing Strategy
- **Unit Testing**: {UnitTestingApproach}
- **Integration Testing**: {IntegrationTestingStrategy}
- **E2E Testing**: {E2ETestingFramework}

###### Test Coverage
- **Component Testing**: {ComponentTestCoverage}
- **Hook Testing**: {HookTestingStrategy}
- **Service Testing**: {ServiceTestingApproach}

##### Development Workflow

###### Build Process
- **Build Tool**: {BuildTool}
- **Development Server**: {DevServerSetup}
- **Hot Reloading**: {HotReloadConfiguration}

###### Code Quality
- **Linting**: {LintingSetup}
- **Type Checking**: {TypeCheckingConfiguration}
- **Formatting**: {CodeFormattingRules}

##### Deployment Considerations

###### Build Configuration
- **Environment Variables**: {EnvironmentVariables}
- **Build Optimization**: {BuildOptimizations}
- **Static Asset Handling**: {StaticAssetStrategy}

###### Performance Monitoring
- **Metrics Tracking**: {MetricsImplementation}
- **Error Tracking**: {ErrorTrackingSetup}
- **User Analytics**: {AnalyticsIntegration}
```

### 8.10 IMPLEMENTATION_REQUIREMENTS_SECTION
```markdown
## Frontend Implementation Best Practices
- **DO**: Follow component composition patterns
- **DO**: Use TypeScript for type safety
- **DO**: Implement proper error boundaries
- **DO**: Follow accessibility guidelines (WCAG 2.1)
- **DO**: Use design system components consistently
- **DO**: Implement responsive design patterns
- **DO NOT**: Directly manipulate DOM outside framework
- **DO NOT**: Store sensitive data in client state
- **DO NOT**: Create components beyond {FeatureName} scope

## Framework-Specific Guidelines cho {FeatureName}
- Component naming: {ComponentNamingConvention}
- File organization: {FileOrganizationPattern}
- State patterns: {StateManagementPattern}
- API integration: {APIIntegrationPattern}
- Performance optimization: {PerformancePatterns}
```

### 8.11 OUTPUT_FORMAT_SECTION
```markdown
**QUAN TRỌNG**: Generate ACTUAL CODE FILES:

1. **Page Components**: `src/pages/{FeatureName}/*.{ext}`
2. **UI Components**: `src/components/{FeatureName}/*.{ext}`
3. **Shared Components**: `src/components/shared/*.{ext}`
4. **Services**: `src/services/{FeatureName}*.{ext}`
5. **State Management**: `src/stores/{FeatureName}/*.{ext}`
6. **Types**: `src/types/{FeatureName}.{ext}`
7. **Tests**: `src/tests/{FeatureName}/*.test.{ext}`
8. **Routes**: `src/routes/{FeatureName}Routes.{ext}`

#### Documentation Files

9. **Frontend Documentation**: `docs/DEV/Documents_Frontend_{FeatureName}.md`
   - Complete frontend implementation overview
   - Page implementations với detailed descriptions
   - Component documentation với props interfaces
   - Custom hooks documentation
   - API services documentation
   - Type definitions overview
   - State management architecture
   - UI/UX implementation details
   - Performance optimizations
   - Error handling strategies
   - Testing implementation
   - Development workflow
   - Deployment considerations

Each file must be complete, compilable code following modern frontend best practices.
Each documentation file must be comprehensive và accessible for frontend developers.
```

### 8.12 UI_UX_STANDARDS_SECTION
```markdown
UI/UX Quality Standards:
- [ ] Responsive design (mobile-first approach)
- [ ] Accessibility compliance (WCAG 2.1 AA)
- [ ] Design system consistency
- [ ] Loading states cho all async operations
- [ ] Error states với meaningful messages
- [ ] Empty states với helpful guidance
- [ ] Keyboard navigation support
- [ ] Screen reader compatibility
- [ ] Color contrast ratios compliance
- [ ] Touch target sizes (44px minimum)
- [ ] Focus management và visual indicators
- [ ] Consistent spacing và typography scales
```

### 8.13 WORKFLOWS_MAPPING_SECTION
```markdown
Business workflows to frontend mapping:

#### Workflow 1: {WorkflowName}
- Use Case: {UseCaseReference}
- Pages Involved: {PagesInWorkflow}
- Components: {ComponentsInWorkflow}
- State Changes: {StateChangesInWorkflow}
- API Calls: {APICallsInWorkflow}
- User Journey: {UserJourneySteps}

#### {AdditionalWorkflows}
{WorkflowMappings}
```

## 9. VALIDATION RULES

### Technical Validation:
- [ ] Framework-specific best practices followed
- [ ] TypeScript types properly defined
- [ ] Component props interfaces complete
- [ ] State management patterns correct
- [ ] API integration properly implemented
- [ ] Error handling comprehensive

### Business Validation:
- [ ] All use cases từ US file được implement
- [ ] User flows match design requirements
- [ ] Business rules enforced in UI
- [ ] API integration matches Swagger spec
- [ ] Form validation rules comprehensive
- [ ] User feedback patterns complete

### Code Quality Validation:
- [ ] Component tests coverage adequate
- [ ] Integration tests cho critical flows
- [ ] Accessibility requirements met
- [ ] Performance optimizations implemented
- [ ] Code splitting implemented where appropriate
- [ ] Bundle size optimized

## 10. EXAMPLE USAGE

```bash
# Input
Feature Name: "UserManagement"
PRD: "docs/BA/PRD_UserManagement_v1.0.md"
SRS: "docs/BA/SRS&DM_UserManagement_v1.0.md"
US: "docs/BA/US_UserManagement_v1.0.md"
ImplementPlan: "docs/DEV/ImplementPlan_UserManagement.md"
API_Swagger: "docs/DEV/API_Swagger_UserManagement.yaml"
UI_UX: "docs/DEV/UI_UX_Requirements_UserManagement.md"
Design_System: "docs/DEV/Design_System_Guidelines.md"
Project Root: "D:/MyProject/frontend"

# Output Generated
Pages: "src/pages/UserManagement/*.jsx"
Components: "src/components/UserManagement/*.jsx"
Services: "src/services/UserManagementApiService.js"
State: "src/stores/UserManagementStore.js"
Tests: "src/tests/UserManagement/*.test.jsx"
Documentation: "docs/DEV/Documents_Frontend_UserManagement.md"
Prompt: "prompts/FRONTEND_UserManagement_Prompt.md"
```

## 11. EXTENSIBILITY

### Adding New Frontend Frameworks:
1. **Extend Framework Detection Rules**
2. **Update Component Patterns**
3. **Modify State Management Patterns**
4. **Update Testing Patterns**

### UI Library Updates:
1. **Update Component Templates**
2. **Modify Design System Integration**
3. **Update Accessibility Patterns**
4. **Adjust Styling Approaches**

### Performance Patterns:
1. **Code Splitting Strategies**
2. **Lazy Loading Patterns**
3. **Caching Strategies**
4. **Bundle Optimization**

**Meta-Prompt Ready** - Sử dụng để generate frontend prompts cho bất kỳ feature nào với complete modern frontend implementation và comprehensive testing coverage.