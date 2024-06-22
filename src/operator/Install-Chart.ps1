$dockerRegistry = "some-registry.azurecr.io"
$dockerPassword = "some-password"
$dockerUsername = "some-username"
$dockerEmail = "some-email@contoso.com"

kubectl create secret docker-registry cdbcs `
    --docker-server=$dockerRegistry `
    --docker-username=$dockerPassword `
    --docker-password=$dockerUsername `
    --docker-email=$dockerEmail

helm upgrade --install borg-operator .\charts\borg-operator