########################
###### [NETWORK] ######
########################

// network state
data "terraform_remote_state" "network" {
  backend   = "azurerm"
  workspace = terraform.workspace
  
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "statfstatesea"
    container_name       = "tfstate"
    key                  = "tfaz/network"
  }
}

