###################################
###### [RESOURCE VARIABLES] ######
###################################

// project code
variable "project_code" {
  type        = string
  default     = "tfaz"
  description = "project code"
}

// short form of region used in resource names
variable "region_code" {
  type        = string
  default     = "sea"
  description = "short form of region used in resource names"
}

// resource region
variable "region" {
  type        = string
  default     = "Southeast Asia"
  description = "resource region"
}

// resource tags
variable "tags" {
  type        = map(any)
  description = "resource tags"

  default = {
    projectCode = "tfaz"
    application = "dataplatform"
  }
}


########################
###### [NETWORK] ######
########################

// vnet address space
variable "vnet_address_space" {
  type        = list(any)
  description = "vnet address space"
}

// data services subnet address space
variable "snet_datasvc_address_prefixes" {
  type        = list(any)
  description = "data services subnet address space"
}

// mgmt subnet address space
variable "snet_mgmt_address_prefixes" {
  type        = list(any)
  description = "management subnet address space"
}

// bastion subnet address space
variable "snet_bastion_address_prefixes" {
  type        = list(any)
  description = "bastion subnet address space"
}

// blob private dns zone
variable "pvtdns_blob" {
  type        = string
  default     = "privatelink.blob.core.windows.net"
  description = "blob private dns zone"
}

// dfs private dns zone
variable "pvtdns_dfs" {
  type        = string
  default     = "privatelink.dfs.core.windows.net"
  description = "dfs private dns zone"
}

// synapse development endpoint private dns zone
variable "pvtdns_syndev" {
  type        = string
  default     = "privatelink.dev.azuresynapse.net"
  description = "synapse development endpoint private dns zone"
}

// synapse pool private dns zone
variable "pvtdns_synpool" {
  type        = string
  default     = "privatelink.sql.azuresynapse.net"
  description = "synapse pool private dns zone"
}

