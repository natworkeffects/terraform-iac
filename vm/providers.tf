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
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
  
  // backend storage account for vm tfstate files
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "statfstatesea"
    container_name       = "tfstate"
    key                  = "tfaz/vm"
  }
}

// add feature block
provider "azurerm" {
  features {}
}

