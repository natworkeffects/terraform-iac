###################################
###### [RESOURCE VARIABLES] ######
###################################

// project code
output "project_code" {
  value       = var.project_code
  description = "project code"
}

// short form of region used in resource names
output "region_code" {
  value       = var.region_code
  description = "region code"
}

// resource region
output "region" {
  value       = var.region
  description = "resource region"
}

// resource tags
output "tags" {
  value       = var.tags
  description = "resource tags"
}


###############################
###### [RESOURCE GROUP] ######
###############################

// resource group name
output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "resource group name"
}


########################
###### [NETWORK] ######
########################

// vnet id
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "vnet id"
}

// data services subnet id
output "snet_datasvc_id" {
  value       = azurerm_subnet.snet_datasvc.id
  description = "data services subnet id"
}

// mgmt subnet id
output "snet_mgmt_id" {
  value       = azurerm_subnet.snet_mgmt.id
  description = "management subnet id"
}

// blob private dns zone
output "pvtdns_blob" {
  value       = azurerm_private_dns_zone.pvtdns_blob.name
  description = "blob private dns zone"
}

// dfs private dns zone
output "pvtdns_dfs" {
  value       = azurerm_private_dns_zone.pvtdns_dfs.name
  description = "dfs private dns zone"
}

// synapse pool private dns zone
output "pvtdns_synpool" {
  value       = azurerm_private_dns_zone.pvtdns_synpool.name
  description = "synapse pool private dns zone"
}

// synapse development endpoint private dns zone
output "pvtdns_syndev" {
  value       = azurerm_private_dns_zone.pvtdns_syndev.name
  description = "synapse development endpoint private dns zone"
}

