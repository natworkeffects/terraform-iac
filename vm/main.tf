#################################
###### [VIRTUAL MACHINES] ######
#################################

// vm password
resource "random_password" "vm_password" {
  length           = 16
  lower            = true
  upper            = true
  number           = true
  special          = true
  override_special = "!@#$%&*_=+?"
}

// mgmt vm
resource "azurerm_windows_virtual_machine" "vm_mgmt" {
  name                  = "vm${local.suffix_concat}mgmt"
  resource_group_name   = data.terraform_remote_state.network.outputs.rg_name
  location              = data.terraform_remote_state.network.outputs.region
  size                  = var.vm_size_mgmt
  admin_username        = local.vm_admin_username
  admin_password        = random_password.vm_password.result
  computer_name         = "vmmgmt"
  network_interface_ids = [azurerm_network_interface.nic_mgmt.id]
  zone                  = 1
  tags                  = local.tags

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

// mgmt vm nic
resource "azurerm_network_interface" "nic_mgmt" {
  name                          = "nic-${local.suffix_main}-mgmt"
  resource_group_name           = data.terraform_remote_state.network.outputs.rg_name
  location                      = data.terraform_remote_state.network.outputs.region
  enable_accelerated_networking = true
  tags                          = local.tags

  ip_configuration {
    name                          = "ipconfig-${local.suffix_main}-mgmt"
    subnet_id                     = data.terraform_remote_state.network.outputs.snet_mgmt_id
    private_ip_address_allocation = "Dynamic"
  }
}

// shir 1 vm
resource "azurerm_windows_virtual_machine" "vm_shir001" {
  name                  = "vm${local.suffix_concat}shir001"
  resource_group_name   = data.terraform_remote_state.network.outputs.rg_name
  location              = data.terraform_remote_state.network.outputs.region
  size                  = var.vm_size_data_workload
  admin_username        = local.vm_admin_username
  admin_password        = random_password.vm_password.result
  computer_name         = "vmshir001"
  network_interface_ids = [azurerm_network_interface.nic_shir001.id]
  zone                  = 1
  tags                  = local.tags

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

// shir vm 1 nic
resource "azurerm_network_interface" "nic_shir001" {
  name                          = "nic-${local.suffix_main}-shir001"
  resource_group_name           = data.terraform_remote_state.network.outputs.rg_name
  location                      = data.terraform_remote_state.network.outputs.region
  enable_accelerated_networking = true
  tags                          = local.tags

  ip_configuration {
    name                          = "ipconfig-${local.suffix_main}-shir001"
    subnet_id                     = data.terraform_remote_state.network.outputs.snet_datasvc_id
    private_ip_address_allocation = "Dynamic"
  }
}

// shir vm 2
resource "azurerm_windows_virtual_machine" "vm_shir002" {
  count                 = terraform.workspace == "prd" ? 1 : 0
  name                  = "vm${local.suffix_concat}shir002"
  resource_group_name   = data.terraform_remote_state.network.outputs.rg_name
  location              = data.terraform_remote_state.network.outputs.region
  size                  = var.vm_size_data_workload
  admin_username        = local.vm_admin_username
  admin_password        = random_password.vm_password.result
  computer_name         = "vmshir002"
  network_interface_ids = [azurerm_network_interface.nic_shir002[0].id]
  zone                  = 2
  tags                  = local.tags

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

// shir vm 2 nic
resource "azurerm_network_interface" "nic_shir002" {
  count                         = terraform.workspace == "prd" ? 1 : 0
  name                          = "nic-${local.suffix_main}-shir002"
  resource_group_name           = data.terraform_remote_state.network.outputs.rg_name
  location                      = data.terraform_remote_state.network.outputs.region
  enable_accelerated_networking = true
  tags                          = local.tags

  ip_configuration {
    name                          = "ipconfig-${local.suffix_main}-shir002"
    subnet_id                     = data.terraform_remote_state.network.outputs.snet_datasvc_id
    private_ip_address_allocation = "Dynamic"
  }
}

