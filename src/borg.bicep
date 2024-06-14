targetScope = 'subscription'

param aadPrincipalId string

@secure()
param vmssPassword string

// https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/201-vmss-windows-webapp-dsc-autoscale/

resource kubeVmssRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'kube-borg-rg'
  location: 'WestUS3'
}

resource kubeMgmtRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'kube-mgmt-rg'
  location: 'WestUS3'
}

module kubeKv 'templates/keyVault.bicep' = {
  name: 'kube-borg-mgmt-kv'
  scope: kubeMgmtRg
  params: {
    keyVaultName: 'kube-borg-mgmt-kv'
    objectId: aadPrincipalId
    secretName: 'kube-borg-vmss-password'
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
  name: 'kubeVmss'
  scope: kubeVmssRg
  params: {
    vmssName: 'kube-borg-vmss'
    adminPassword: kv.getSecret('kube-borg-vmss-password')
  }
  dependsOn: [
    kv
  ]
}
