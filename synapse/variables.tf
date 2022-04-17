########################
###### [SYNAPSE] ######
########################

// storage account replication type
variable "sta_replication_type" {
  type        = string
  description = "storage account replication type"
}

// synapse AAD admin service principal
variable "syn_aad_admin_principal" {
  type        = string
  default     = "" // input user/group principal
  description = "synapse AAD admin service principal"
}

// synapse AAD admin object id
variable "syn_aad_admin_object_id" {
  type        = string
  default     = "" // input principal object id in AAD
  description = "synapse AAD admin object id"
}

// blob subresource
variable "subrs_blob" {
  type        = list(any)
  default     = ["blob"]
  description = "blob subresource"
}

// dfs subresource
variable "subrs_dfs" {
  type        = list(any)
  default     = ["dfs"]
  description = "dfs subresource"
}

// synapse dedicated pool subresource
variable "subrs_synddt" {
  type        = list(any)
  default     = ["Sql"]
  description = "synapse dedicated pool subresource"
}

// synapse serverless pool subresource
variable "subrs_synsvl" {
  type        = list(any)
  default     = ["SqlOnDemand"]
  description = "synapse serverless pool subresource"
}

// synapse development endpoint subresource
variable "subrs_syndev" {
  type        = list(any)
  default     = ["Dev"]
  description = "synapse development endpoint subresource"
}

