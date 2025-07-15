namespace AbpApp;

public static class AbpAppDomainErrorCodes
{
    // User errors
    public const string UserNameAlreadyExists = "AbpApp:UserNameAlreadyExists";
    public const string EmailAlreadyExists = "AbpApp:EmailAlreadyExists";
    public const string UserNotFound = "AbpApp:UserNotFound";
    
    // Role errors
    public const string RoleNameAlreadyExists = "AbpApp:RoleNameAlreadyExists";
    public const string RoleNotFound = "AbpApp:RoleNotFound";
    
    // Tenant errors
    public const string TenantNameAlreadyExists = "AbpApp:TenantNameAlreadyExists";
    public const string TenantNotFound = "AbpApp:TenantNotFound";
    
    // General errors
    public const string InvalidOperation = "AbpApp:InvalidOperation";
    public const string AccessDenied = "AbpApp:AccessDenied";
    public const string ValidationError = "AbpApp:ValidationError";
}