using System.Threading.Tasks;

namespace AbpApp.Data;

public interface IAbpAppDbSchemaMigrator
{
    Task MigrateAsync();
}