using Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount;
using KubeOps.Operator.Web.Webhooks.Admission.Mutation;

namespace Borg.KubeOperator.Web.WebHooks
{
    [MutationWebhook(typeof(DatabaseAccount))]
    public class DatabaseAccountMutationWebhook : MutationWebhook<DatabaseAccount>
    {
        public override MutationResult<DatabaseAccount> Create(DatabaseAccount entity, bool dryRun)
        {
            return NoChanges();
        }
    }
}
