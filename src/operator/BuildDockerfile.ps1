$dockerRegistry = "some-registry.azurecr.io"

$datePart = $(get-date -f yyyy-MM-dd)
$epoch2020 = $(Get-Date -Date "1-1-2020" -UFormat %s)
$tag = "$datePart-$epoch2020"

docker build . -t $dockerRegistry/borg-operator:latest -t $dockerRegistry/borg-operator:$tag
docker push $dockerRegistry/borg-operator:latest
docker push $dockerRegistry/borg-operator:$tag