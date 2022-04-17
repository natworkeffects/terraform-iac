##################################################
###### [AZURE PROVIDER AND BACKEND CONFIG] ######
##################################################

// initialize terraform with this config
terraform {
  // required providers
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.96.0"
    }
  }

  // backend storage account for network tfstate files
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "statfstatesea"
    container_name       = "tfstate"
    key                  = "tfaz/network"
  }
}

// add feature block
provider "azurerm" {
  features {}
}
