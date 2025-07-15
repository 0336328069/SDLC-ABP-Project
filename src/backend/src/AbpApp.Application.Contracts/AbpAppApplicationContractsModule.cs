using Volo.Abp.Application;
using Volo.Abp.Authorization;
using Volo.Abp.Identity;
using Volo.Abp.Modularity;
using Volo.Abp.TenantManagement;
using Volo.Abp.PermissionManagement;
using Volo.Abp.SettingManagement;

namespace AbpApp;

[DependsOn(
    typeof(AbpAppDomainSharedModule),
    typeof(AbpDddApplicationContractsModule),
    typeof(AbpAuthorizationModule),
    typeof(AbpIdentityApplicationContractsModule),
    typeof(AbpTenantManagementApplicationContractsModule),
    typeof(AbpPermissionManagementApplicationContractsModule),
    typeof(AbpSettingManagementApplicationContractsModule)
)]
public class AbpAppApplicationContractsModule : AbpModule
{
    public override void PreConfigureServices(ServiceConfigurationContext context)
    {
        AbpAppDtoExtensions.Configure();
    }
}