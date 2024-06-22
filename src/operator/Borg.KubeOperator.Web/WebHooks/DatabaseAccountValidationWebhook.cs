using Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount;
using KubeOps.Operator.Web.Webhooks.Admission.Validation;

namespace Borg.KubeOperator.Web.WebHooks
{
    [ValidationWebhook(typeof(DatabaseAccount))]
    public class DatabaseAccountValidationWebhook : ValidationWebhook<DatabaseAccount>
    {
        public override ValidationResult Create(DatabaseAccount entity, bool dryRun)
        {
            if (entity.Spec.AccountRegion != "WestUS2")
            {
                return Fail($"accountRegion cannot be set to '{entity.Spec.AccountRegion}'");
            }

            return Success();
        }

        public override ValidationResult Update(DatabaseAccount oldEntity, DatabaseAccount newEntity, bool dryRun)
        {
            if (oldEntity.Status.Status != DatabaseStatus.Ready)
            {
                return Fail($"Cannot update account, current status is {newEntity.Status.Status}, account status must be {oldEntity.Status.Status} before updating.");
            }

            if (newEntity.Spec.AccountRegion != "WestUS2")
            {
                return Fail($"Database accountRegion cannot be set to '{newEntity.Spec.AccountRegion}'");
            }

            return Success();
        }
    }
}
