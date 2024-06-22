using k8s.Models;

using KubeOps.Abstractions.Entities;

namespace Borg.KubeOperator.Versions.v1Alpha1.DatabaseAccount
{
    public enum DatabaseStatus
    {
        Unknown = 0,
        Creating,
        Created,
        Updating,
        Updated,
        Ready,
        Deleting,
        Deleted,
        Failed
    }

    [KubernetesEntity(Group = "db.kuiper-sys.com", ApiVersion = "v1alpha1", Kind = "DatabaseAccount")]
    public class DatabaseAccount :
        CustomKubernetesEntity<DatabaseAccount.EntitySpec, DatabaseAccount.EntityStatus>
    {
        public override string ToString()
            => $"Test Entity ({Metadata.Name}): {Spec.AccountRegion}";

        public class EntitySpec
        {
            public string AccountRegion { get; set; } = string.Empty;
        }

        public class EntityStatus
        {
            public DatabaseStatus Status { get; set; } = DatabaseStatus.Unknown;
        }
    }
}
