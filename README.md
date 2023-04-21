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

```
az ad sp create-for-rbac --scopes "/subscriptions/YOUR_SUBSCRIPTION_ID" --role "Contributor" --name "my-service-principal-name" 

```

- Configure the repo to authenticate on Azure
    - Using Federeated Identity - 
    - Using Client Secret - 

- Create the backend for the terraform state

```powershell
#Change here your subscription id
$subscriptionId = "000000000000-00000-000-000000"
$location = "west europe"
$resourceGroupName = "rg-wazuh-infra-backend"
$storageAccountName = "stwazuhinfrabackend"
$containerName = "tfstate"

az group create --name $resourceGroupName --location $location --subscription $subscriptionId

az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS --subscription $subscriptionId

az storage container create --name $containerName --account-name $storageAccountName --account-key (az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --subscription $subscriptionId --query "[0].value" -o tsv) --public-access off --subscription $subscriptionId


```


- Configure the wazuh-infra.tfbackend file:

```
storage_account_name = "mystorageaccount"
container_name       = "my-container"
resource_group_name  = "my-resource-group"
key                  = "my-tfstate.tfstate"
use_oidc             = true


```


## Configuring Wazuh

### Wazuh Indexer


### Wazuh Server


### Wazuh Dashboard