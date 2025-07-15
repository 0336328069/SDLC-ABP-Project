using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;

namespace AbpApp.DbMigrator;

public class DbMigratorHostedService : IHostedService
{
    private readonly ILogger<DbMigratorHostedService> _logger;
    private readonly IConfiguration _configuration;
    private readonly IHostApplicationLifetime _hostApplicationLifetime;

    public DbMigratorHostedService(
        ILogger<DbMigratorHostedService> logger,
        IConfiguration configuration,
        IHostApplicationLifetime hostApplicationLifetime)
    {
        _logger = logger;
        _configuration = configuration;
        _hostApplicationLifetime = hostApplicationLifetime;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        try
        {
            _logger.LogInformation("DbMigrator started...");
            
            var connectionString = _configuration.GetConnectionString("Default");
            _logger.LogInformation($"Connection String: {connectionString}");
            
            _logger.LogInformation("DbMigrator finished successfully.");
        }
        catch (System.Exception ex)
        {
            _logger.LogError(ex, "An error occurred during migration.");
            throw;
        }
        finally
        {
            _hostApplicationLifetime.StopApplication();
        }
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}