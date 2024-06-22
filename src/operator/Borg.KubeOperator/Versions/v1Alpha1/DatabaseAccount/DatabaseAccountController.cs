using KubeOps.Abstractions.Controller;
using KubeOps.Abstractions.Finalizer;
using KubeOps.Abstractions.Rbac;
using KubeOps.KubernetesClient;

namespace Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount
{
    [EntityRbac(typeof(DatabaseAccount), Verbs = RbacVerb.All)]
    internal class DatabaseAccountController : IEntityController<DatabaseAccount>
    {
        private readonly IKubernetesClient kubeClient;
        private readonly EntityFinalizerAttacher<DatabaseAccountFinalizer, DatabaseAccount> accountFinalizer;

        public DatabaseAccountController(
            IKubernetesClient kubeClient,
            EntityFinalizerAttacher<DatabaseAccountFinalizer, DatabaseAccount> accountFinalizer)
        {
            this.kubeClient = kubeClient;
            this.accountFinalizer = accountFinalizer;
        }

        public Task DeletedAsync(DatabaseAccount entity, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }

        public async Task ReconcileAsync(DatabaseAccount entity, CancellationToken cancellationToken)
        {
            entity.Status.Status = DatabaseStatus.Updating;
            entity = await kubeClient.UpdateStatusAsync(entity, cancellationToken);

            entity = await accountFinalizer(entity, cancellationToken);

            entity.Status.Status = DatabaseStatus.Updated;
            _ = await kubeClient.UpdateStatusAsync(entity, cancellationToken);
        }
    }
}
