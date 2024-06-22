$dockerRegistry = "thefuriousscissors"

$datePart = $(get-date -f yyyy-MM-dd)
$epoch2020 = $(Get-Date -Date "1-1-2020" -UFormat %s)
$tag = "$datePart-$epoch2020"

docker build . -t $dockerRegistry/borg-kube-operator:latest -t $dockerRegistry/borg-kube-operator:$tag
docker push $dockerRegistry/borg-kube-operator:latest
docker push $dockerRegistry/borg-kube-operator:$tag

kubectl rollout restart deployment borg-operator