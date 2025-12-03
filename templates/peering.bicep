param vnet1id string
param vnet1name string
param vnet2id string
param vnet2name string

resource peering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-08-01' = {
  name: '${vnet1name}/${vnet1name}-to-${vnet2name}-peering'
   properties: {
    remoteVirtualNetwork: {
      id: vnet2id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
resource peering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-08-01' = {
  name: '${vnet2name}/${vnet2name}-to-${vnet1name}-peering'
   properties: {
    remoteVirtualNetwork: {
      id: vnet1id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
