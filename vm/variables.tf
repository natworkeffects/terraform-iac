#################################
###### [VIRTUAL MACHINES] ######
#################################

// vm size mgmt
variable "vm_size_mgmt" {
  type        = string
  default     = "Standard_D2as_v4"
  description = "vm size for mgmt"
}

// vm size data workload
variable "vm_size_data_workload" {
  type        = string
  default     = "Standard_D4as_v4"
  description = "vm size for data workloads"
}

