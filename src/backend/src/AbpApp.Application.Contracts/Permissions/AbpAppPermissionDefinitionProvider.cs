using AbpApp.Localization;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Localization;

namespace AbpApp.Permissions;

public class AbpAppPermissionDefinitionProvider : PermissionDefinitionProvider
{
    public override void Define(IPermissionDefinitionContext context)
    {
        var abpAppGroup = context.AddGroup(AbpAppPermissions.GroupName, L("Permission:AbpApp"));

        // Add your permission definitions here when needed
        // Example:
        // var dashboardPermission = abpAppGroup.AddPermission(AbpAppPermissions.Dashboard.Default, L("Permission:Dashboard"));
    }

    private static LocalizableString L(string name)
    {
        return LocalizableString.Create<AbpAppResource>(name);
    }
}