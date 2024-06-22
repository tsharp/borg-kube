using Borg.KubeOperator.Versions.v1Alpha1;
using k8s;
using k8s.Models;
using KubeOps.Abstractions.Builder;
using KubeOps.Abstractions.Finalizer;
using KubeOps.Operator;

using Microsoft.Extensions.DependencyInjection;
using System.Reflection;

namespace Borg.KubeOperator
{
    public static class BorgOperatorExtensions
    {
        private const string FinalizerKind = "finalizer";

        public static string Format(this KubernetesEntityAttribute attribute, string subKind, string name)
        {
            return $"{attribute.Group}/{attribute.ApiVersion}.{attribute.Kind}.{subKind}.{name}".ToLowerInvariant();
        }

        public static IOperatorBuilder AddFinalizer<TImplementation, TEntity>(this IOperatorBuilder builder)
            where TImplementation : class, IEntityFinalizer<TEntity>
            where TEntity : IKubernetesObject<V1ObjectMeta>
        {

            var entityAttribute = typeof(TEntity).GetCustomAttribute<KubernetesEntityAttribute>();
            var finalizerName = typeof(TImplementation).Name!;

            return builder.AddFinalizer<TImplementation, TEntity>(entityAttribute!.Format(FinalizerKind, finalizerName));
        }

        public static IOperatorBuilder AddBorgOperator(this IServiceCollection services)
        {
            return services
                .AddKubernetesOperator()
                .RegisterApi_v1Alpha1();
        }
    }
}
