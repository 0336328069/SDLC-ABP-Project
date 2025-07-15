
using Volo.Abp.Autofac;
using Volo.Abp.Modularity;

namespace AbpApp.DbMigrator;

[DependsOn(
    typeof(AbpAutofacModule),
    typeof(AbpAppEntityFrameworkCoreModule),
    typeof(AbpAppApplicationContractsModule)
)]
public class AbpAppDbMigratorModule : AbpModule
{
}