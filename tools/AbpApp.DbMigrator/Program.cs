using System;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;

namespace AbpApp.DbMigrator;

class Program
{
    static async Task<int> Main(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Information()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
#if DEBUG
            .MinimumLevel.Override("AbpApp", LogEventLevel.Debug)
#else
            .MinimumLevel.Override("AbpApp", LogEventLevel.Information)
#endif
            .Enrich.FromLogContext()
            .WriteTo.File("Logs/logs.txt")
            .WriteTo.Console()
            .CreateLogger();

        try
        {
            Log.Information("Starting AbpApp.DbMigrator...");

            await CreateHostBuilder(args).RunConsoleAsync();

            Log.Information("AbpApp.DbMigrator finished.");
            return 0;
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "AbpApp.DbMigrator terminated unexpectedly!");
            return 1;
        }
        finally
        {
            Log.CloseAndFlush();
        }
    }

    private static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureLogging((context, logging) => logging.ClearProviders())
            .ConfigureServices((hostContext, services) =>
            {
                services.AddHostedService<DbMigratorHostedService>();
            })
            .UseSerilog();
}