param location string
param destinationNicId string


resource tap 'Microsoft.Network/virtualNetworkTaps@2025-01-01' = {
  name: 'vnettap'
  location: location
  properties: {
    destinationNetworkInterfaceIPConfiguration: {
      name: 'ipv4config0'
      id: '${destinationNicId}/ipConfigurations/ipv4config0'
    }
    destinationPort: 4789
  }
}


output tapId string = tap.id
