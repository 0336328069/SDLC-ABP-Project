using Volo.Abp.Threading;

namespace AbpApp;

public static class AbpAppModuleExtensionConfigurator
{
    private static readonly OneTimeRunner OneTimeRunner = new OneTimeRunner();

    public static void Configure()
    {
        OneTimeRunner.Run(() =>
        {
            // Configure module extensions here
            // Example:
            // ModuleExtensionConfigurationHelper.ApplyEntityConfigurationToEntity(
            //     IdentityModuleExtensionConsts.ModuleName,
            //     IdentityModuleExtensionConsts.EntityNames.User,
            //     entityType =>
            //     {
            //         entityType.AddOrUpdateProperty<string>(
            //             "SocialSecurityNumber",
            //             property =>
            //             {
            //                 property.UI.OnTable.IsVisible = true;
            //                 property.UI.OnCreateForm.IsVisible = true;
            //                 property.UI.OnEditForm.IsVisible = true;
            //             }
            //         );
            //     }
            // );
        });
    }
}