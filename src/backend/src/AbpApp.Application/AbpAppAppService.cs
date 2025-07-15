using AbpApp.Localization;
using Volo.Abp.Application.Services;

namespace AbpApp;

/* Inherit your application services from this class. */
public abstract class AbpAppAppService : ApplicationService
{
    protected AbpAppAppService()
    {
        LocalizationResource = typeof(AbpAppResource);
    }
}