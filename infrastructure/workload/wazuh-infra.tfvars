group = {
    name = "wazuh-rg" 
    location = "West Europe"
}

keyvault = {
  name = "my-wz-security-kv"
}
vnet = {
    name = "wazuh-vnet"
}


wazuh-server = {
  name           = "my-wazuh-server-001"
  vm_size        = "Standard_DS2_v2"
  admin_username = "wazuhadmin"
}


wazuh-indexer = {
  name           = "my-wazuh-indexer-001"
  vm_size        = "Standard_DS2_v2"
  admin_username = "wazuhadmin"
}

