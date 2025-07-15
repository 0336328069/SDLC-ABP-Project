using AbpApp.Localization;
using Volo.Abp.Features;
using Volo.Abp.Localization;
using Volo.Abp.Localization.ExceptionHandling;
using Volo.Abp.Modularity;
using Volo.Abp.Settings;
using Volo.Abp.Validation;
using Volo.Abp.Validation.Localization;
using Volo.Abp.VirtualFileSystem;

namespace AbpApp;

[DependsOn(
    typeof(AbpValidationModule),
    typeof(AbpSettingsModule),
    typeof(AbpVirtualFileSystemModule),
    typeof(AbpLocalizationAbstractionsModule),
    typeof(AbpFeaturesModule)
)]
public class AbpAppDomainSharedModule : AbpModule
{
    public override void PreConfigureServices(ServiceConfigurationContext context)
    {
        AbpAppGlobalFeatureConfigurator.Configure();
        AbpAppModuleExtensionConfigurator.Configure();
    }

    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        Configure<AbpVirtualFileSystemOptions>(options =>
        {
            options.FileSets.AddEmbedded<AbpAppDomainSharedModule>();
        });

        Configure<AbpLocalizationOptions>(options =>
        {
            options.Resources
                .Add<AbpAppResource>("en")
                .AddBaseTypes(typeof(AbpValidationResource))
                .AddVirtualJson("/Localization/AbpApp");

            options.DefaultResourceType = typeof(AbpAppResource);
        });

        Configure<AbpExceptionLocalizationOptions>(options =>
        {
            options.MapCodeNamespace("AbpApp", typeof(AbpAppResource));
        });
    }
}