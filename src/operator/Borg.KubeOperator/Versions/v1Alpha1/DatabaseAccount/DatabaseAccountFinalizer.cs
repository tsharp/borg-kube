using KubeOps.Abstractions.Finalizer;

namespace Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount
{
    internal class DatabaseAccountFinalizer : IEntityFinalizer<DatabaseAccount>
    {
        public async Task FinalizeAsync(DatabaseAccount entity, CancellationToken cancellationToken)
        {
            await Task.CompletedTask;
        }
    }
}
