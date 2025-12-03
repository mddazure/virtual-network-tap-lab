param rgName string = 'vtap-lab'

param location string = 'germanywestcentral'

param vnetName string = 'vtap-lab-vnet'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnetName string = 'subnet1'
param subnet1AddressPrefix string = '10.0.1.0/24'
param subnet2Name string = 'subnet2'
param subnet2AddressPrefix string = '10.0.2.0/24'
param subnet3Name string = 'AzureBastionSubnet'
param subnet3AddressPrefix string = '10.0.3.0/24'

param vmtargetIp string = '10.0.1.4'
param vm1Ip string = '10.0.2.4'
param vm2Ip string = '10.0.2.5'
param vm3Ip string = '10.0.2.6'

param adminUser string = 'AzureAdmin'
param adminPw string = 'vnettap-2025%'

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}
module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  scope: rg
  params: {
    location: location
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnet1Name: subnetName
    subnet1AddressPrefix: subnet1AddressPrefix
    subnet2Name: subnet2Name
    subnet2AddressPrefix: subnet2AddressPrefix
    subnet3Name: subnet3Name
    subnet3AddressPrefix: subnet3AddressPrefix
    }
}
module vmtarget 'vm.bicep' = {
  name: 'vmtarget-deployment'
    scope: rg
  params: {
    vmName: 'vmtarget'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: vnet.outputs.subnet1Id
    privateIpAddress: vmtargetIp
  }
}
module vm1 'vm.bicep' = {
  name: 'vm1-deployment'
  scope: rg
  params: {
    vmName: 'vm1'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: vnet.outputs.subnet2Id
    vtapId: vtap.outputs.tapId
  }
}
module vm2 'vm.bicep' = {
  name: 'vm2-deployment'
    scope: rg
  params: {
    vmName: 'vm2'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: vnet.outputs.subnet2Id
    privateIpAddress: vm2Ip
  }
}

module vm3 'vm.bicep' = {
  name: 'vm3-deployment'
    scope: rg
  params: {
    vmName: 'vm3'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: vnet.outputs.subnet2Id
    privateIpAddress: vm3Ip
  }
}
module vtap 'vtap.bicep' = {
  name: 'vtap-deployment'
    scope: rg
  params: {
    location: location
    destinationNicId: vmtarget.outputs.nicId
  }
}
