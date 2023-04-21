group = {
    name = "wazuh-rg" 
    location = "West Europe"
}


vnet = {
    name = "wazuh-vnet"
}


wazuh-server = {
  name           = "my-wazuh-server-001"
  vm_size        = "D2s_V2"
  admin_username = "wazuhadmin"
}


wazuh-indexer = {
  name           = "my-wazuh-indexer-001"
  vm_size        = "D2s_V2"
  admin_username = "wazuhadmin"
}

