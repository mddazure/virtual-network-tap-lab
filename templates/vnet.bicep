
param location string
param vnetName string
param vnetAddressPrefix string
param subnet1Name string
param subnet1AddressPrefix string
param subnet2Name string
param subnet2AddressPrefix string
param subnet3Name string
param subnet3AddressPrefix string


resource vnet 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1AddressPrefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2AddressPrefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3AddressPrefix
        }
      }
    ]
  }
}






output vnetId string = vnet.id
output subnet1Id string = vnet.properties.subnets[0].id
output subnet2Id string = vnet.properties.subnets[1].id
output subnet3Id string = vnet.properties.subnets[2].id
