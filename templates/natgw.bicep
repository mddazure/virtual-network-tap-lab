param location string
param vnetName string

resource natgwpip 'Microsoft.Network/publicIPAddresses@2025-03-01' = {
  name: '${vnetName}-natgw-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
resource natgw 'Microsoft.Network/natGateways@2025-03-01' = {
  name: '${vnetName}-natgw'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
  publicIpAddresses: [
    {
      id: natgwpip.id
    }
  ]
  }
}
output natgwId string = natgw.id
output natgwpipId string = natgwpip.id
