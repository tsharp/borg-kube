$preRequisites = @('Helm.Helm', 'Kubernetes.kubectl')
$clusterCtlVersion = "1.7.3"

$preRequisites | ForEach-Object {
    $package = $_
    Write-Host Installing $package ... -ForegroundColor Green

    winget install --id=$package  -e
}