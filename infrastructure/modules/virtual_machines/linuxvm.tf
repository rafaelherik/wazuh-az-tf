resource "azurerm_linux_virtual_machine" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size
  admin_username      = var.admin_username

  network_interface_ids = var.network_interface_ids

  availability_set_id = var.availability_set_id

  os_disk {
    name              = var.os_disk.name
    caching           = var.os_disk.caching
    storage_account_type     = var.os_disk.storage_account_type
    
  }

  admin_ssh_key  {    
    username = var.admin_username
    # Reference the SSH key from Key Vault
    public_key = "${var.ssh_key}"
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  boot_diagnostics {
    storage_account_uri = try(var.storage_account_uri, null)
  }
}

variable "name" {
  description = "The Virtual Machine name."
}

variable "location" {
  description = "The location of the virtual machine."
}

variable "resource_group_name" {
  description = "The resource group name."
}

variable "admin_username" {
  description = "The admin username."
  default =  "adminuser"
}

variable "availability_set_id" {
  description = "The Avaiability Set ID."
  default = null
}

variable "size" {
  description = "The virtual machine size."
}

variable "source_image_reference" {
  description = "The source image reference."
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }  
}

variable "os_disk" {
  description = "The Operating System Disk configuration."
  default = {
    name              = "examplevm-osdisk"
    caching           = "ReadWrite"    
    storage_account_type = "Standard_LRS"
  }
}

variable "storage_account_uri" {
  description = "The storage account Uri."
  default = null
}


variable "network_interface_ids" {
  description = "The Network interface IDs."
}


variable "ssh_key" {
  description = "The Public SSH Key."
}