using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.DependencyInjection;

namespace AbpApp.Data;

public class AbpAppEfCoreDbSchemaMigrator
    : IAbpAppDbSchemaMigrator, ITransientDependency
{
    private readonly IServiceProvider _serviceProvider;

    public AbpAppEfCoreDbSchemaMigrator(
        IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public async Task MigrateAsync()
    {
        /* We intentionally resolving the AbpAppDbContext
         * from IServiceProvider (instead of directly injecting) to properly
         * handle the lifetime scope. */
        
        await _serviceProvider
            .GetRequiredService<AbpAppDbContext>()
            .Database
            .MigrateAsync();
    }
}