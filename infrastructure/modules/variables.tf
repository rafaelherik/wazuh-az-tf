variable "azurerm_subscription_id" {
  description = "value"
  default     = null
}
variable "azurerm_tenant_id" {
  description = "value"
  default     = null
}

variable "azurerm_client_id" {
  description = "value"
  default     = null
}


variable "group" {
    description = "The Resource Group configuration."
}

variable "wazuh-server" {
  description = "The Wazuh server configuration."
}

variable "wazuh-indexer" {
  description = "The Wazuh indexer configuration."
}


variable "vnet" {
  description = "The Virtual Network configuration."
}
