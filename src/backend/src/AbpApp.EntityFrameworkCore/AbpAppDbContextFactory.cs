using System;
using System.IO;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace AbpApp;

/* This class is needed for EF Core console commands
 * (like Add-Migration and Update-Database commands) */
public class AbpAppDbContextFactory : IDesignTimeDbContextFactory<AbpAppDbContext>
{
    public AbpAppDbContext CreateDbContext(string[] args)
    {
        AbpAppEfCoreEntityExtensionMappings.Configure();

        var configuration = BuildConfiguration();

        var builder = new DbContextOptionsBuilder<AbpAppDbContext>()
            .UseSqlServer(configuration.GetConnectionString("Default"));

        return new AbpAppDbContext(builder.Options);
    }

    private static IConfigurationRoot BuildConfiguration()
    {
        var builder = new ConfigurationBuilder()
            .SetBasePath(Path.Combine(Directory.GetCurrentDirectory(), "../AbpApp.HttpApi.Host/"))
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile("appsettings.Development.json", optional: true);

        return builder.Build();
    }
}