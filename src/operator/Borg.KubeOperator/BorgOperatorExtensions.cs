using Borg.KubeOperator.Versions.v1Alpha1;

using KubeOps.Abstractions.Builder;
using KubeOps.Operator;

using Microsoft.Extensions.DependencyInjection;

namespace Borg.KubeOperator
{
    public static class BorgOperatorExtensions
    {
        public static IOperatorBuilder AddBorgOperator(this IServiceCollection services)
        {
            return services
                .AddKubernetesOperator()
                .RegisterApi_v1Alpha1();
        }
    }
}
