param location string
param destinationNicId string = ''
param destinationFrontendIpConfigId string = ''
param vtapname string

resource tap 'Microsoft.Network/virtualNetworkTaps@2025-01-01' = {
  name: vtapname
  location: location
  properties: {
    destinationLoadBalancerFrontEndIPConfiguration: destinationFrontendIpConfigId != '' ? {
      id: destinationFrontendIpConfigId
    } : null
    destinationNetworkInterfaceIPConfiguration: destinationNicId != '' ? {
      name: 'ipv4config0'
      id: '${destinationNicId}/ipConfigurations/ipv4config0'
    } : null
    destinationPort: 4789
  }
}


output tapId string = tap.id
