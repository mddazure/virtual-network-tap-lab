# **Virtual Network TAP**

[Azure Virtual Network Terminal Access Point](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-tap-overview) (VTAP), in public preview in select regions, copies network traffic from source Virtual Machines to a collector or traffic analytics tool, running as a Network Virtual Appliance (NVA). VTAP creates a full copy of all traffic sent and received by the VM Network Interface Card (s) (NICs) designated as a VTAP source. This includes packet payload content - in contrast to VNET Flow Logs which only collects traffic meta data. Traffic collectors and analytics tools are 3rd party partner products, amongst which are the major Network Detection and Response solutions.

VTAP is an agentless, cloud-native traffic tap at the Azure network infrastructure level. It is entirely out-of-band; it has no impact on the source VM's network performance and the source VM is unaware of the tap. Tapped traffic is VXLAN-encapsulated and delivered to the collector NVA, in the same VNET as the source VMs or a peered VNET. 

# Lab
This lab demonstrates the basic functionality of VTAP: copying traffic into and out of a source VM, to a destination VM. The lab consists of 3 three Windows VMs in one VNET, running a basic web server that responds with the VM's name. Another VNET contains the target - a Windows VM on which Wireshark is installed, to inspect traffic forwarded by VTAP. This lab does not use any [VTAP partner solutions](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-tap-overview#virtual-network-tap-partner-solutions) from the Marketplace.

The VTAP resource in the lab is configured with the target VM's NIC as the destination, and one of the web server VMs as the source. Using a single source makes inspection of the traffic flows in Wireshark easier - the other VMs can be added as sources manually.

![image](/images/vtap-lab.png)

# Deploy
Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash.

Ensure Azure CLI and extensions are up to date:
  
      az upgrade --yes
  
If necessary select your target subscription:
  
      az account set --subscription <Name or ID of subscription>
  
Clone the  GitHub repository:

    git clone https://github.com/mddazure/virtual-network-tap-lab


Change directory:

    cd ./virtual-network-tap-lab/templates

Deploy the Bicep template:

      az deployment sub create --name vtap --location germanywestcentral --template-file main.bicep

Verify that all components in the diagram above have been deployed to the resourcegroup `vtap-lab` and are healthy. 

Credentials:

username: `AzureAdmin`

password: `vnettap-2025%`

# Observe
Log on to 
