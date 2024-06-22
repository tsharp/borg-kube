targetScope = 'subscription'

param aadPrincipalId string

@secure()
param vmssPassword string

// https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/201-vmss-windows-webapp-dsc-autoscale/

var baseName = 'kube-borg'
var computeName = '${baseName}-compute'
var mgmtName = '${baseName}-mgmt'

resource kubeVmssRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${computeName}-rg'
  location: 'WestUS3'
}

resource kubeMgmtRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${mgmtName}-rg'
  location: 'WestUS3'
}

module kubeKv 'templates/keyVault.bicep' = {
  name: '${mgmtName}-secrets'
  scope: kubeMgmtRg
  params: {
    keyVaultName: '${mgmtName}-secrets'
    objectId: aadPrincipalId
    secretName: '${computeName}-password'
    secretValue: vmssPassword
     enabledForDeployment: true
     enabledForDiskEncryption: true
     enabledForTemplateDeployment: true
  }
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kubeKv.outputs.name
  scope: kubeMgmtRg
}

module kubeVmss 'templates/vmss.bicep' = {
  name: computeName
  scope: kubeVmssRg
  params: {
    vmScaleSetName: computeName
    adminPassword: kv.getSecret('${computeName}-password')
  }
  dependsOn: [
    kv
  ]
}
