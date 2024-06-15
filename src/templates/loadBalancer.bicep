param location string
param lbName string
param beResourceName string

var natStartPort = 50000
var natEndPort = 50119
var natBackendPort = 22
var natPoolName = '${beResourceName}-natpool'
var bePoolName = '${beResourceName}-bepool'
var feName = '${lbName}-fe'

var frontEndIPConfigID = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, feName)
var lbPoolID = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, bePoolName)
var lbProbeID = resourceId('Microsoft.Network/loadBalancers/probes', lbName, 'tcpProbe')

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: '${lbName}-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: lbName
    }
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: feName
        properties: {
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: bePoolName
      }
    ]
    inboundNatPools: [
      {
        name: natPoolName
        properties: {
          frontendIPConfiguration: {
            id: frontEndIPConfigID
          }
          protocol: 'Tcp'
          frontendPortRangeStart: natStartPort
          frontendPortRangeEnd: natEndPort
          backendPort: natBackendPort
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          frontendIPConfiguration: {
            id: frontEndIPConfigID
          }
          backendAddressPool: {
            id: lbPoolID
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: lbProbeID
          }
        }
      }
    ]
    probes: [
      {
        name: 'tcpProbe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
  }
}

output loadBalancerId string = loadBalancer.id
output fqdn string = publicIpAddress.properties.dnsSettings.fqdn
output lbBePoolId string = lbPoolID
