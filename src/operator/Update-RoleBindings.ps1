kubectl delete ClusterRoleBinding borg-operator-role-binding
kubectl delete ClusterRole borg-operator-role

kubectl apply -f .\charts\roles\operator-role.yaml
kubectl apply -f .\charts\roles\operator-role-binding.yaml

kubectl rollout restart deployment borg-operator