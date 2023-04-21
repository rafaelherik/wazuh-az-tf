terraform {  
  
}

provider "azurerm" {
  subscription_id = var.azurerm_subscription_id
  tenant_id       = var.azurerm_tenant_id
  client_id       = var.azurerm_client_id  
  features {}
}




# RESOURCE GROUP
resource "azurerm_resource_group" "wazuh-rg" {
  name     = var.group.name
  location = var.group.location
}



# NETWORKING
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  resource_group_name = azurerm_resource_group.wazuh-rg.name
  location            = azurerm_resource_group.wazuh-rg.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.wazuh-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


# KEYVAULT

resource "azurerm_key_vault" "keyvault" {
  name                =  var.keyvault.name
  location            = "${azurerm_resource_group.wazuh-rg.location}"
  resource_group_name = "${azurerm_resource_group.wazuh-rg.name}"

  sku_name = "standard"
  
  tenant_id            = "${data.azurerm_client_config.current.tenant_id}"
  enabled_for_disk_encryption = true

  ## Setting the permissions to the service principal
  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.object_id}"
    key_permissions = [
      "get",
      "create",
      "delete",
      "list"
    ]
  }
}


# VIRTUAL MACHINES



resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


# WAZUH SERVER

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

resource "azurerm_network_interface" "wz-server-ni" {
  name                = "${var.wazuh-server.name}-nic"
  location            = azurerm_resource_group.wazuh-rg.location
  resource_group_name = azurerm_resource_group.wazuh-rg.name

  ip_configuration {
    name                          = "${var.wazuh-server.name}-ipconfig"
    subnet_id                     = "${azurerm_subnet.example.id}"
    private_ip_address_allocation = "Dynamic"
  }
}


## WAZUH INDEXER
module "wazuh-indexer" {
  source              = "./virtual_machines"
  name                = var.wazuh-indexer.name
  location            = azurerm_resource_group.wazuh-rg.location
  resource_group_name = azurerm_resource_group.wazuh-rg.name
  admin_username      = var.wazuh-indexer.admin_username
  size                = var.wazuh-indexer.vm_size
  os_disk = {
    name              = "${var.wazuh-indexer.name}-osdisk"
    caching           = "ReadWrite"    
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = ["${azurerm_network_interface.wz-server-ni.id}"]
  ssh_key = tls_private_key.pk.public_key_openssh
}

resource "azurerm_network_interface" "wz-indexer-ni" {
  name                = "${var.wazuh-indexer.name}-nic"
  location            = azurerm_resource_group.wazuh-rg.location
  resource_group_name = azurerm_resource_group.wazuh-rg.name

  ip_configuration {
    name                          = "${var.wazuh-indexer.name}-ipconfig"
    subnet_id                     = "${azurerm_subnet.example.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "local_file" "ssh_key" {
  filename = "asdfadsfasdf.pem"
  content = tls_private_key.pk.private_key_pem
}

