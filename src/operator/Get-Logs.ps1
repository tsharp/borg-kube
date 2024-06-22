$pods = kubectl get pods -o name
$pods | ForEach-Object {
    $pod = $_
    kubectl logs $pod
}