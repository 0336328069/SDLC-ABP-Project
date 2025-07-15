using Localization.Resources.AbpUi;
using AbpApp.Localization;
using Volo.Abp.AspNetCore.Mvc;
using Volo.Abp.Localization;
using Volo.Abp.Modularity;
using Volo.Abp.Identity;
using Volo.Abp.TenantManagement;
using Volo.Abp.PermissionManagement.HttpApi;
using Volo.Abp.SettingManagement;
using Microsoft.Extensions.DependencyInjection;

namespace AbpApp;

[DependsOn(
    typeof(AbpAppApplicationContractsModule),
    typeof(AbpAspNetCoreMvcModule),
    typeof(AbpIdentityHttpApiModule),
    typeof(AbpTenantManagementHttpApiModule),
    typeof(AbpPermissionManagementHttpApiModule),
    typeof(AbpSettingManagementHttpApiModule)
)]
public class AbpAppHttpApiModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        ConfigureLocalization();
    }

    private void ConfigureLocalization()
    {
        Configure<AbpLocalizationOptions>(options =>
        {
            options.Resources
                .Get<AbpAppResource>()
                .AddBaseTypes(
                    typeof(AbpUiResource)
                );
        });
    }
}