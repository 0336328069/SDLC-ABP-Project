using Volo.Abp.Application;
using Volo.Abp.AutoMapper;
using Volo.Abp.Identity;
using Volo.Abp.Modularity;
using Volo.Abp.TenantManagement;
using Volo.Abp.PermissionManagement;
using Volo.Abp.SettingManagement;

namespace AbpApp;

[DependsOn(
    typeof(AbpAppDomainModule),
    typeof(AbpAppApplicationContractsModule),
    typeof(AbpDddApplicationModule),
    typeof(AbpAutoMapperModule),
    typeof(AbpIdentityApplicationModule),
    typeof(AbpTenantManagementApplicationModule),
    typeof(AbpPermissionManagementApplicationModule),
    typeof(AbpSettingManagementApplicationModule)
)]
public class AbpAppApplicationModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        Configure<AbpAutoMapperOptions>(options =>
        {
            options.AddMaps<AbpAppApplicationModule>();
        });
    }
}