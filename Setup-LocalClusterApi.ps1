# Enable the experimental Cluster topology feature.
$Env:CLUSTER_TOPOLOGY=$true

# Initialize the management cluster
clusterctl init --infrastructure docker

# clusterctl generate cluster [name] --kubernetes-version [version] | kubectl apply -f -
clusterctl generate provider --infrastructure docker > artifacts/docker-provider.yaml
kubectl apply -f artifacts/docker-provider.yaml

clusterctl generate cluster borg --kubernetes-version 1.29.2