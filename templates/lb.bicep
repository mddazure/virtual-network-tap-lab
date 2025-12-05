param location string
param lbName string
param frontendIpConfigName string = 'LoadBalancerFrontEnd'
param backendPoolName string = 'LoadBalancerBackEndPool'
param vnetSubnetId string
param privateIpAddress string = ''

resource lb 'Microsoft.Network/loadBalancers@2022-01-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendIpConfigName
        properties: {
          privateIPAddress: privateIpAddress
          privateIPAllocationMethod: privateIpAddress != '' ? 'Static' : 'Dynamic'
          subnet: {
            id: vnetSubnetId
          }
        }
      }
    ]
    probes: [
      {
        name: 'tcp-probe'
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
resource lbBackendPool 'Microsoft.Network/loadBalancers/backendAddressPools@2022-01-01' = {
  name: backendPoolName
  parent: lb
  properties: {
  }
}
output lbId string = lb.id
output lbBackendPoolId string = lbBackendPool.id
output lbFrontendIpConfigId string = lb.properties.frontendIPConfigurations[0].id
