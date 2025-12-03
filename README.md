# **Virtual Network TAP**

[Azure Virtual Network Terminal Access Point](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-tap-overview) (VTAP), in public preview in select regions, copies network traffic from source Virtual Machines to a collector or traffic analytics tool, running as a Network Virtual Appliance (NVA). VTAP creates a full copy of all traffic sent and received by the VM Network Interface Card (s) (NICs) designated as a VTAP source. This includes packet payload content - in contrast to VNET Flow Logs which only collects traffic meta data. Traffic collectors and analytics tools are 3rd party partner products, amongst which are the major Network Detection and Response solutions.

VTAP is an agentless, cloud-native traffic tap at the Azure network infrastructure level. It is entirely out-of-band; it has no impact on the source VM's network performance and the source VM is unaware of the tap. Tapped traffic is VXLAN-encapsulated and delivered to the collector NVA, in the same VNET as the source VMs or a peered VNET. The collector can also be  

