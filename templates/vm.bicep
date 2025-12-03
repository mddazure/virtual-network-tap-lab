param vmName string
param adminUser string
@secure()
param adminPw string
param location string
param subnetId string
param privateIpAddress string = ''
param vtapId string = ''

var imagePublisher = 'MicrosoftWindowsServer'
var imageOffer = 'WindowsServer'
var imageSku = '2022-Datacenter'
//var imageOffer = '0001-com-ubuntu-server-jammy'
//var imagePublisher = 'Canonical'
//var imageSku = '22_04-lts-gen2'
  
//var imageId = '/subscriptions/0245be41-c89b-4b46-a3cc-a705c90cd1e8/resourceGroups/image-gallery-rg/providers/Microsoft.Compute/galleries/mddimagegallery/images/windows2019-networktools/versions/2.0.0'

resource nic 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: '${vmName}-nic'
  location: location
  properties:{
    ipConfigurations: [
      {
        name: 'ipv4config0'
        properties:{
          primary: true
          privateIPAllocationMethod: 'Static'
          privateIPAddressVersion: 'IPv4'
          privateIPAddress: privateIpAddress
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}
resource tapconfig 'Microsoft.Network/networkInterfaces/tapConfigurations@2024-07-01' = if (vtapId != '') {
  name: '${vmName}-tapconfig'
  parent: nic
  properties: {
    virtualNetworkTap: {
      id: vtapId
    }
  }
}
resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile:{
      vmSize: 'Standard_DS2_v2'
    }
    storageProfile:  {
      imageReference: {
        //id: imageId
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'      
        }
      }
      osProfile:{
        computerName: vmName
        adminUsername: adminUser
        adminPassword: adminPw
      }
      networkProfile: {
        networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    } 
  }
}

resource ext 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: 'ext'
  parent: vm
  location: location
  properties:{
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    protectedSettings:{}
    settings: {
        //commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "Invoke-WebRequest -Uri https://npcap.com/dist/npcap-1.79.exe -OutFile C:\\Users\\AzureAdmin\\npcap-1.79.exe; Start-Process -FilePath C:\\Users\\AzureAdmin\\npcap-1.79.exe -ArgumentList \'/S\' -Wait; Invoke-WebRequest -Uri https://2.na.dl.wireshark.org/win64/Wireshark-latest-x64.exe -OutFile C:\\Users\\AzureAdmin\\Wireshark-latest-x64.exe; Start-Process -FilePath C:\\Users\\AzureAdmin\\Wireshark-latest-x64.exe -ArgumentList \'/S\' -Wait"'
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
    }
  }  
}


output nicId string = vm.properties.networkProfile.networkInterfaces[0].id
output vmId string = vm.id
output vmName string = vm.name
