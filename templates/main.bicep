param rgName string = 'vtap-lab-lb'

param location string = 'germanywestcentral'

param svnetName string = 'vtap-source-vnet'
param svnetAddressPrefix string = '10.0.0.0/16'
param ssubnetName string = 'subnet1'
param ssubnet1AddressPrefix string = '10.0.1.0/24'
param ssubnet2Name string = 'subnet2'
param ssubnet2AddressPrefix string = '10.0.2.0/24'
param ssubnet3Name string = 'AzureBastionSubnet'
param ssubnet3AddressPrefix string = '10.0.3.0/24'

param tvnetName string = 'vtap-destination-vnet'
param tvnetAddressPrefix string = '10.1.0.0/16'
param tsubnetName string = 'subnet1'
param tsubnet1AddressPrefix string = '10.1.1.0/24'
param tsubnet2Name string = 'subnet2'
param tsubnet2AddressPrefix string = '10.1.2.0/24'
param tsubnet3Name string = 'AzureBastionSubnet'
param tsubnet3AddressPrefix string = '10.1.3.0/24'

param vmtarget1Ip string = '10.1.1.4'
param vmtarget2Ip string = '10.1.1.5'
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
module tnatgw 'natgw.bicep' = {
  name: 'tnatgw-deployment'
  scope: rg
  params: {
    location: location
    vnetName: tvnetName
  }
}
module snatgw 'natgw.bicep' = {
  name: 'snatgw-deployment'
  scope: rg
  params: {
    location: location
    vnetName: tvnetName
  }
}
module svnet 'vnet.bicep' = {
  name: 'svnet-deployment'
  scope: rg
  params: {
    location: location
    vnetName: svnetName
    vnetAddressPrefix: svnetAddressPrefix
    subnet1Name: ssubnetName
    subnet1AddressPrefix: ssubnet1AddressPrefix
    subnet2Name: ssubnet2Name
    subnet2AddressPrefix: ssubnet2AddressPrefix
    subnet3Name: ssubnet3Name
    subnet3AddressPrefix: ssubnet3AddressPrefix
    natgwId: snatgw.outputs.natgwId
  }
}
module tvnet 'vnet.bicep' = {
  name: 'tvnet-deployment'
  scope: rg
  params: {
    location: location
    vnetName: tvnetName
    vnetAddressPrefix: tvnetAddressPrefix
    subnet1Name: tsubnetName
    subnet1AddressPrefix: tsubnet1AddressPrefix
    subnet2Name: tsubnet2Name
    subnet2AddressPrefix: tsubnet2AddressPrefix
    subnet3Name: tsubnet3Name
    subnet3AddressPrefix: tsubnet3AddressPrefix
    natgwId: tnatgw.outputs.natgwId
    }
}
module peering 'peering.bicep' = {
  name: 'vnet-peering-deployment'
    scope: rg
  params: {
    vnet1id: svnet.outputs.vnetId
    vnet1name: svnetName
    vnet2id: tvnet.outputs.vnetId
    vnet2name: tvnetName
  }
}
module bastion 'bastion.bicep' = {
  name: 'bastion'
    scope: rg
  params: {
    bastionSubnetid: svnet.outputs.subnet3Id
    location: location
  }
}
/*
module lb 'lb.bicep' = {
  name: 'loadbalancer-deployment'
    scope: rg
  params: {
    location: location
    lbName: 'vtap-lb'
    vnetSubnetId: tvnet.outputs.subnet2Id
  }
}
*/
module vmtarget1 'vm.bicep' = {
  name: 'vmtarget1-deployment'
    scope: rg
  params: {
    vmName: 'vmtarget1'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: tvnet.outputs.subnet1Id
    privateIpAddress: vmtarget1Ip
    extension: false
    }
}
/*
module vmtarget2 'vm.bicep' = {
  name: 'vmtarget2-deployment'
    scope: rg
  params: {
    vmName: 'vmtarget2'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: tvnet.outputs.subnet1Id
    privateIpAddress: vmtarget2Ip
    lbbepId: lb.outputs.lbBackendPoolId
    extension: false
  }
}
*/
module vm1 'vm.bicep' = {
  name: 'vm1-deployment'
  scope: rg
  params: {
    vmName: 'vm1'
    adminUser: adminUser
    adminPw: adminPw
    location: location
    subnetId: svnet.outputs.subnet2Id
    privateIpAddress: vm1Ip
    vtapId: vtapvm.outputs.tapId
    extension: true
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
    subnetId: svnet.outputs.subnet2Id
    privateIpAddress: vm2Ip
    extension: true
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
    subnetId: svnet.outputs.subnet2Id
    privateIpAddress: vm3Ip
    extension: true
  }
}
module vtapvm 'vtap.bicep' = {
  name: 'vtapvm-deployment'
    scope: rg
  params: {
    vtapname: 'vtapvm'
    location: location
    destinationNicId: vmtarget1.outputs.nicId
  }
}
/*
module vtaplb 'vtap.bicep' = {
  name: 'vtaplb-deployment'
    scope: rg
  params: {
    vtapname: 'vtaplb'
    location: location
    destinationFrontendIpConfigId: lb.outputs.lbFrontendIpConfigId
  }
}*/
