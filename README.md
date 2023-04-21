# Deploying Wazuh on Azure using Teraform

- Wazuh - (https://wazuh.com/)


## What is Wazuh?

Wazuh is a free and open source security platform that unifies XDR and SIEM capabilities. It protects workloads across on-premises, virtualized, containerized, and cloud-based environments.


## Deploy the Infrastructure

### Terraform Modules


#### Infrastructure definition

To Deploy Wazuh Solution, the infrastructure will looks like:




 - 1 Key Vault
 - 3 Virtual Machine
 - 1 Virtual Network
 - 1 Subnet
 - 1 Application Gateway
 - 1 Public IP Address

#### LinuxVM Module

To reuse the Virtual machine configuration, I created a LinuxVM module to deploy the virtual machine, this is an example of how to use this module: 

```terraform

module "wazuh-server" {  
  source              = "./virtual_machines"
  name                = var.wazuh-server.name
  location            = azurerm_resource_group.wazuh-rg.location
  resource_group_name = azurerm_resource_group.wazuh-rg.name
  admin_username      = var.wazuh-server.admin_username
  size                = var.wazuh-server.vm_size
  os_disk = {
    name              = "${var.wazuh-server.name}-osdisk"
    caching           = "ReadWrite"    
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = ["${azurerm_network_interface.wz-server-ni.id}"]
  ssh_key = tls_private_key.pk.public_key_openssh
}

```


## How to Deploy the infrastructure

- Fork this repo

- Create a service principal 

- Configure the repo to authenticate on Azure
    - Using Federeated Identity 
    - Using Client Secret 

- Create the backend for the terraform state

- Configure the wazuh-infra.tfbackend file:

```


```


## Configuring Wazuh

### Wazuh Indexer


### Wazuh Server


### Wazuh Dashboard