# **Virtual Network TAP**

[Azure Virtual Network Terminal Access Point](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-tap-overview) (VTAP), in public preview in select regions, copies network traffic from source Virtual Machines to a collector or traffic analytics tool, running as a Network Virtual Appliance (NVA). VTAP creates a full copy of all traffic sent and received by Viritual Machine Network Interface Card(s) (NICs) designated as VTAP source(s). This includes packet payload content - in contrast to VNET Flow Logs which only collects traffic meta data. Traffic collectors and analytics tools are 3rd party partner products, amongst which are the major Network Detection and Response solutions.

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
Log on to `vm1` via Bastion and start the `loop.bat` batch file found on the Desktop. This will poll the web servers on the other VMs and `ipconfig.io`, generating network traffic.

Log on to `vmtarget` via Bastion and install [Wireshark](https://www.wireshark.org/download.html), keeping the installer's default settings. 

Start Wireshark, enter `udp port 4789` in the Capture filter and start the capture by clicking the shark's fin in the top left corner.

![image](/images/wireshark-startup.png)

The capture filter on UDP port 4789 causes Wireshark to only capture the VXLAN encapsulated traffic forwarded by VTAP. Wireshark is configured to automatically decode VXLAN and it displays the actual traffic to and from `vm1`, which is set up as the (only) VTAP source. 

:point_right: Close the Bastion session to `vm1`, as the  traffic between the VM and Bastion is also captured and it convolutes the Wireshark display.

The wireshark capture panel shows full TCP and HTTP exchanges, including the TCP handshake, between `vm1` and the other VMs, and https://ipconfig.io.

![image](/images/wireshark-capture.png)

The lines in the detail panel below can be expanded to show the details of the VXLAN encapsulation. The outer IP packets, encapsulating the VXLAN frames in UDP, originate from the source VM's IP address, with the target VM's address as the destination.
The VXLAN frames contain all the details of the original Ethernet frames, and the IP packets within those, exchanged between `vm1` and the destinations it speaks with.

![image](/images/wireshark-detail.png)


