using KubeOps.Abstractions.Builder;

namespace Borg.KubeOperator.Versions.v1Alpha1
{
    internal static class OperatorExtensions
    {
        public static IOperatorBuilder RegisterApi_v1Alpha1(this IOperatorBuilder builder)
        {
            builder
                .AddController<DatabaseAccount.DatabaseAccountController, DatabaseAccount.DatabaseAccount>()
                .AddFinalizer<DatabaseAccount.DatabaseAccountFinalizer, DatabaseAccount.DatabaseAccount>(Guid.NewGuid().ToString());

            return builder;
        }
    }
}
