# Load Settings File ...
$settings = Get-Content "local.settings.json" | ConvertFrom-Json
$subscriptionId = $settings.subscriptionId

az account set --subscription "$subscriptionId"