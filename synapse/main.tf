resource "azurerm_storage_account" "dls" {
  name                      = "dls${local.suffix_concat}"
  resource_group_name       = data.terraform_remote_state.network.outputs.rg_name
  location                  = data.terraform_remote_state.network.outputs.region
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = var.sta_replication_type
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  shared_access_key_enabled = true
  is_hns_enabled            = true
  tags                      = local.tags

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = [] // add your public IP if required
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dfs_syn" {
  name               = "synapse"
  storage_account_id = azurerm_storage_account.dls.id
}

resource "random_password" "syn_password" {
  length           = 16
  lower            = true
  upper            = true
  number           = true
  special          = true
  override_special = "!@#$%&*_=+?"
}

resource "azurerm_synapse_workspace" "syn" {
  name                                 = "syn-${local.suffix_main}"
  resource_group_name                  = data.terraform_remote_state.network.outputs.rg_name
  location                             = data.terraform_remote_state.network.outputs.region
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dfs_syn.id
  sql_administrator_login              = local.syn_admin_username
  sql_administrator_login_password     = random_password.syn_password.result
  sql_identity_control_enabled         = true
  tags                                 = local.tags

  aad_admin {
    login     = var.syn_aad_admin_principal
    object_id = var.syn_aad_admin_object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_synapse_sql_pool" "ddtpool" {
  name                 = "ddtpool"
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  data_encrypted       = true
}

resource "azurerm_role_assignment" "iam_syn_dls" {
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.syn.identity.0.principal_id
}


#################################
##### [PRIVATE ENDPOINTS] ######
#################################

// data lake storage blob private endpoint
resource "azurerm_private_endpoint" "pvte_blob_dls" {
  name                = "pvte-${local.suffix_main}-blob-dls"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  location            = data.terraform_remote_state.network.outputs.region
  subnet_id           = data.terraform_remote_state.network.outputs.snet_datasvc_id
  tags                = local.tags

  private_service_connection {
    name                           = "pvtsvc-${local.suffix_main}-blob-dls"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.dls.id
    subresource_names              = var.subrs_blob
  }
}

// data lake storage blob private dns zone A record
resource "azurerm_private_dns_a_record" "pvtdns_a_rec_blob_dls" {
  name                = azurerm_storage_account.dls.name
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  zone_name           = data.terraform_remote_state.network.outputs.pvtdns_blob
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pvte_blob_dls.private_service_connection.0.private_ip_address]
  tags                = local.tags
}

// data lake storage dfs private endpoint
resource "azurerm_private_endpoint" "pvte_dfs_dls" {
  name                = "pvte-${local.suffix_main}-dfs-dls"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  location            = data.terraform_remote_state.network.outputs.region
  subnet_id           = data.terraform_remote_state.network.outputs.snet_datasvc_id
  tags                = local.tags

  private_service_connection {
    name                           = "pvtsvc-${local.suffix_main}-dfs-dls"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.dls.id
    subresource_names              = var.subrs_dfs
  }
}

// data lake storage dfs private dns zone A record
resource "azurerm_private_dns_a_record" "pvtdns_a_rec_dfs_dls" {
  name                = azurerm_storage_account.dls.name
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  zone_name           = data.terraform_remote_state.network.outputs.pvtdns_dfs
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pvte_dfs_dls.private_service_connection.0.private_ip_address]
  tags                = local.tags
}

// synapse dedicated pool private endpoint
resource "azurerm_private_endpoint" "pvte_synddt" {
  name                = "pvte-${local.suffix_main}-synddt"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  location            = data.terraform_remote_state.network.outputs.region
  subnet_id           = data.terraform_remote_state.network.outputs.snet_datasvc_id
  tags                = local.tags

  private_service_connection {
    name                           = "pvtsvc-${local.suffix_main}-synddt"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.syn.id
    subresource_names              = var.subrs_synddt
  }
}

// synapse dedicated pool private dns zone A record
resource "azurerm_private_dns_a_record" "pvtdns_a_rec_synddt" {
  name                = azurerm_synapse_workspace.syn.name
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  zone_name           = data.terraform_remote_state.network.outputs.pvtdns_synpool
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pvte_synddt.private_service_connection.0.private_ip_address]
  tags                = local.tags
}

// synapse serverless pool private endpoint
resource "azurerm_private_endpoint" "pvte_synsvl" {
  name                = "pvte-${local.suffix_main}-synsvl"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  location            = data.terraform_remote_state.network.outputs.region
  subnet_id           = data.terraform_remote_state.network.outputs.snet_datasvc_id
  tags                = local.tags

  private_service_connection {
    name                           = "pvtsvc-${local.suffix_main}-synsvl"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.syn.id
    subresource_names              = var.subrs_synsvl
  }
}

// synapse serverless pool private dns zone A record
resource "azurerm_private_dns_a_record" "pvtdns_a_rec_synsvl" {
  name                = "${azurerm_synapse_workspace.syn.name}-ondemand"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  zone_name           = data.terraform_remote_state.network.outputs.pvtdns_synpool
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pvte_synsvl.private_service_connection.0.private_ip_address]
  tags                = local.tags
}

// synapse development endpoint private endpoint
resource "azurerm_private_endpoint" "pvte_syndev" {
  name                = "pvte-${local.suffix_main}-syndev"
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  location            = data.terraform_remote_state.network.outputs.region
  subnet_id           = data.terraform_remote_state.network.outputs.snet_datasvc_id
  tags                = local.tags

  private_service_connection {
    name                           = "pvtsvc-${local.suffix_main}-syndev"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.syn.id
    subresource_names              = var.subrs_syndev
  }
}

// synapse development endpoint private dns zone A record
resource "azurerm_private_dns_a_record" "pvtdns_a_rec_syndev" {
  name                = azurerm_synapse_workspace.syn.name
  resource_group_name = data.terraform_remote_state.network.outputs.rg_name
  zone_name           = data.terraform_remote_state.network.outputs.pvtdns_syndev
  ttl                 = 3600
  records             = [azurerm_private_endpoint.pvte_syndev.private_service_connection.0.private_ip_address]
  tags                = local.tags
}

