using Volo.Abp.Threading;

namespace AbpApp;

public static class AbpAppGlobalFeatureConfigurator
{
    private static readonly OneTimeRunner OneTimeRunner = new OneTimeRunner();

    public static void Configure()
    {
        OneTimeRunner.Run(() =>
        {
            // Configure global features here
            // Example:
            // GlobalFeatureManager.Instance.Modules.Ecommerce(ecommerce =>
            // {
            //     ecommerce.EnableAll();
            // });
        });
    }
}