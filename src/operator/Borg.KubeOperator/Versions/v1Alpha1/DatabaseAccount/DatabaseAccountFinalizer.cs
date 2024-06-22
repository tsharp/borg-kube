using KubeOps.Abstractions.Finalizer;

namespace Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount
{
    internal class DatabaseAccountFinalizer : IEntityFinalizer<DatabaseAccount>
    {
        public Task FinalizeAsync(DatabaseAccount entity, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
