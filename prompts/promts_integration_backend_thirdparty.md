# SYSTEM INTEGRATION ANALYSIS REQUEST (WITH THIRD-PARTY SERVICES)

  ## 1. CONTEXT ANALYSIS
  - Analyze existing codebase structure for [FEATURE_NAME]
  - Identify current implementation status of each layer:
    * Domain Layer (Entities, Value Objects, Domain Services)
    * Application Layer (App Services, DTOs, Contracts)
    * Infrastructure Layer (Repositories, External Services, Third-party Integrations)
    * API Layer (Controllers, Middleware, DTOs)

  ## 2. THIRD-PARTY SERVICES MAPPING
  For each identified third-party service, analyze:

  ### SERVICE IDENTIFICATION
  - [ ] **Authentication Providers**: Google OAuth, Facebook, Microsoft, Auth0
  - [ ] **Communication Services**: SendGrid, Mailgun, Twilio, Firebase
  - [ ] **Payment Gateways**: Stripe, PayPal, Square, VNPay
  - [ ] **Cloud Storage**: AWS S3, Azure Blob, Google Cloud Storage
  - [ ] **Analytics/Monitoring**: Google Analytics, Application Insights, Sentry
  - [ ] **Search Services**: Elasticsearch, Algolia, Azure Search
  - [ ] **Caching Services**: Redis, Memcached, CloudFlare
  - [ ] **File Processing**: ImageKit, Cloudinary, FFmpeg services

  ### INTEGRATION PATTERN ANALYSIS
  For each third-party service, identify:
  - **Integration Type**: REST API, SDK, Webhook, OAuth, SOAP
  - **Authentication Method**: API Key, OAuth 2.0, JWT, Basic Auth
  - **Data Flow Direction**: Inbound, Outbound, Bidirectional
  - **Synchronization Type**: Real-time, Batch, Event-driven
  - **Fallback Strategy**: Retry logic, Circuit breaker, Graceful degradation

  ## 3. INTEGRATION GAPS IDENTIFICATION

  ### CRITICAL (System won't work without these)
  - [ ] **Service Client Implementations**
    - HTTP clients for REST APIs
    - SDK integrations and configurations
    - Authentication token management
    - Request/response mapping

  - [ ] **Configuration Management**
    - API keys and secrets storage
    - Environment-specific configurations
    - Service endpoint configurations
    - Rate limiting configurations

  - [ ] **Domain Service Abstractions**
    - Interface definitions for third-party services
    - Domain models for external data
    - Mapping between external and internal models

  ### HIGH PRIORITY (Production readiness)
  - [ ] **Error Handling & Resilience**
    - Retry policies with exponential backoff
    - Circuit breaker patterns
    - Timeout configurations
    - Fallback mechanisms

  - [ ] **Security & Compliance**
    - API key rotation strategies
    - Data encryption in transit/at rest
    - GDPR/compliance data handling
    - Audit logging for external calls

  - [ ] **Monitoring & Observability**
    - Third-party service health checks
    - API call metrics and logging
    - Error rate monitoring
    - Performance tracking

  ### MEDIUM PRIORITY (Operational excellence)
  - [ ] **Caching Strategies**
    - Response caching for expensive calls
    - Token caching and refresh logic
    - Rate limit caching

  - [ ] **Testing Infrastructure**
    - Mock/stub services for testing
    - Integration test environments
    - Contract testing with third parties

  ## 4. SERVICE-SPECIFIC INTEGRATION REQUIREMENTS

  ### AUTHENTICATION SERVICES (Google OAuth, Auth0, etc.)
  ```csharp
  // Required Components:
  - OAuth flow implementation
  - Token validation and refresh
  - User profile mapping
  - Social login UI integration
  - Account linking strategies

  EMAIL SERVICES (SendGrid, Mailgun, etc.)

  // Required Components:
  - Template management
  - Bulk email handling
  - Delivery status tracking
  - Bounce/complaint handling
  - Email personalization

  PAYMENT SERVICES (Stripe, PayPal, etc.)

  // Required Components:
  - Payment intent creation
  - Webhook handling for async events
  - Refund/chargeback processing
  - PCI compliance measures
  - Payment method storage

  5. INTEGRATION ARCHITECTURE PATTERNS

  ADAPTER PATTERN IMPLEMENTATION

  // Domain Layer
  public interface IEmailService
  {
      Task<EmailResult> SendAsync(EmailMessage message);
  }

  // Infrastructure Layer
  public class SendGridEmailService : IEmailService
  public class MailgunEmailService : IEmailService

  // Configuration Layer
  services.AddScoped<IEmailService, SendGridEmailService>();

  STRATEGY PATTERN FOR MULTIPLE PROVIDERS

  public interface IPaymentProcessor
  {
      Task<PaymentResult> ProcessAsync(PaymentRequest request);
  }

  public class PaymentProcessorFactory
  {
      public IPaymentProcessor GetProcessor(PaymentMethod method);
  }

  6. FAILURE SCENARIOS & MITIGATION

  THIRD-PARTY SERVICE DOWNTIME

  - Circuit breaker implementation
  - Fallback service alternatives
  - Graceful degradation strategies
  - User communication plans

  RATE LIMITING & QUOTAS

  - Request queuing mechanisms
  - Priority-based processing
  - Usage monitoring and alerts
  - Cost optimization strategies

  DATA CONSISTENCY ISSUES

  - Eventual consistency handling
  - Compensation transaction patterns
  - Data synchronization strategies
  - Conflict resolution mechanisms

  7. CONFIGURATION & SECRETS MANAGEMENT

  ENVIRONMENT CONFIGURATIONS

  {
    "ThirdPartyServices": {
      "Google": {
        "ClientId": "{{GOOGLE_CLIENT_ID}}",
        "ClientSecret": "{{GOOGLE_CLIENT_SECRET}}",
        "RedirectUri": "{{GOOGLE_REDIRECT_URI}}"
      },
      "SendGrid": {
        "ApiKey": "{{SENDGRID_API_KEY}}",
        "FromEmail": "{{SENDGRID_FROM_EMAIL}}"
      }
    }
  }

  SECRET MANAGEMENT STRATEGY

  - Azure Key Vault / AWS Secrets Manager integration
  - Development vs Production secret handling
  - Secret rotation procedures
  - Access control and auditing

  8. TESTING STRATEGY FOR THIRD-PARTY INTEGRATIONS

  TESTING LEVELS

  - Unit Tests: Mock third-party services
  - Integration Tests: Use sandbox/test environments
  - Contract Tests: Verify API compatibility
  - End-to-End Tests: Full workflow validation

  TEST DATA MANAGEMENT

  - Sandbox account setup
  - Test data cleanup procedures
  - Webhook testing strategies
  - Load testing considerations

  9. MONITORING & ALERTING REQUIREMENTS

  KEY METRICS TO TRACK

  - Third-party service response times
  - Error rates by service and endpoint
  - API quota usage and limits
  - Cost tracking and budgets
  - Security incidents and anomalies

  ALERTING STRATEGIES

  - Service degradation alerts
  - Quota limit warnings
  - Authentication failure alerts
  - Cost threshold notifications

  OUTPUT FORMAT REQUEST

  Please provide:

  1. Service Integration Matrix: Current vs Required integrations
  2. Implementation Roadmap: Integration order with dependencies
  3. Risk Assessment: Third-party service risks and mitigations
  4. Cost Analysis: API usage costs and optimization opportunities
  5. Security Checklist: Third-party specific security requirements
  6. Testing Strategy: How to test each integration reliably
  7. Operational Runbook: How to monitor and maintain integrations

  ## 🚀 **USAGE EXAMPLES**

  **Authentication với Google + Email với SendGrid:**
  Analyze BE-DB-Third-party integration for Authentication module with Google OAuth login and       
  SendGrid email notifications

  **E-commerce với Stripe + CloudFlare:**
  Analyze BE-DB-Third-party integration for E-commerce module with Stripe payments and
  CloudFlare CDN for product images

  **CMS với AWS S3 + ImageKit:**
  Analyze BE-DB-Third-party integration for CMS module with AWS S3 file storage and ImageKit        
  