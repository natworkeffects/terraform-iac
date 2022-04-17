###############################
###### [RESOURCE GROUP] ######
###############################

// resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.suffix_main}"
  location = var.region
  tags     = local.tags
}


########################
###### [NETWORK] ######
########################

// vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.suffix_main}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = local.tags
}

// data services subnet
resource "azurerm_subnet" "snet_datasvc" {
  name                                           = "snet-${local.suffix_main}-datasvc"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = var.snet_datasvc_address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

// mgmt subnet
resource "azurerm_subnet" "snet_mgmt" {
  name                                           = "snet-${local.suffix_main}-mgmt"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = var.snet_mgmt_address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

// bastion subnet
resource "azurerm_subnet" "snet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.snet_bastion_address_prefixes
}

// data services nsg
resource "azurerm_network_security_group" "nsg_datasvc" {
  name                = "nsg-${local.suffix_main}-datasvc"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// mgmt nsg
resource "azurerm_network_security_group" "nsg_mgmt" {
  name                = "nsg-${local.suffix_main}-mgmt"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// data services subnet nsg association
resource "azurerm_subnet_network_security_group_association" "snet_nsg_datasvc" {
  subnet_id                 = azurerm_subnet.snet_datasvc.id
  network_security_group_id = azurerm_network_security_group.nsg_datasvc.id
}

// mgmt subnet nsg association
resource "azurerm_subnet_network_security_group_association" "snet_nsg_mgmt" {
  subnet_id                 = azurerm_subnet.snet_mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}

// blob private dns zone
resource "azurerm_private_dns_zone" "pvtdns_blob" {
  name                = var.pvtdns_blob
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// dfs private dns zone
resource "azurerm_private_dns_zone" "pvtdns_dfs" {
  name                = var.pvtdns_dfs
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// synapse development endpoint private dns zone
resource "azurerm_private_dns_zone" "pvtdns_syndev" {
  name                = var.pvtdns_syndev
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// synapse pool private dns zone
resource "azurerm_private_dns_zone" "pvtdns_synpool" {
  name                = var.pvtdns_synpool
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

// vnet synapse pool private dns zone link
resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_synpool" {
  name                  = "vnetlink-${local.suffix_main}-synpool"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pvtdns_synpool.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
}

// vnet synapse development endpoint private dns zone link
resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_syndev" {
  name                  = "vnetlink-${local.suffix_main}-syndev"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pvtdns_syndev.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
}

// vnet blob private dns zone link
resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_blob" {
  name                  = "vnetlink-${local.suffix_main}-blob"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pvtdns_blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
}

// vnet dfs private dns zone link
resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_dfs" {
  name                  = "vnetlink-${local.suffix_main}-dfs"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pvtdns_dfs.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
}


########################
###### [BASTION] ######
########################

// bastion
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-${local.suffix_main}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  sku                 = "Basic"
  tags                = local.tags

  ip_configuration {
    name                 = "ipconfig-${local.suffix_main}-bastion"
    subnet_id            = azurerm_subnet.snet_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }
}

// bastion public ip
resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-${local.suffix_main}-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  sku                 = "Standard"
  sku_tier            = "Regional"
  allocation_method   = "Static"
  tags                = local.tags
}

