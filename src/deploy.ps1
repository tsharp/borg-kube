# Load Settings File ...
$settings = Get-Content "local.settings.json" | ConvertFrom-Json
$subscriptionId = $settings.subscriptionId

az account set --subscription $subscriptionId

az deployment sub create `
  --name kubeBorgDeployment `
  --location centralus `
  --template-file borg.bicep `
  --parameters local.settings.json