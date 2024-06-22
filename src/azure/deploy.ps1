# Load Settings File ...
$settings = Get-Content "local.settings.json" | ConvertFrom-Json
$subscriptionId = $settings.subscriptionId

Write-Host "Setting subscription to $subscriptionId" -ForegroundColor Cyan
az account set --subscription "$subscriptionId"

Write-Host "Deploying resources to Azure..." -ForegroundColor Cyan
az deployment sub create `
  --name kubeBorgDeployment `
  --location centralus `
  --template-file borg.bicep `
  --parameters local.parameters.json