using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;

namespace AbpApp.Data;

public class NullAbpAppDbSchemaMigrator : IAbpAppDbSchemaMigrator, ISingletonDependency
{
    public Task MigrateAsync()
    {
        return Task.CompletedTask;
    }
}