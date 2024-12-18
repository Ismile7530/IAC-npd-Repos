provider "azurerm" {
  features {}
}

# Specify location to store tfstate files
terraform {
  backend "azurerm" {
    resource_group_name  = "cloudfulIaCrg"
    storage_account_name = "stgiac01"
    container_name       = "tfstatefiles"
    key                  = "$(storageaccountkey)"
  }
}

data "azurerm_resource_group" "npdrg" {
  name     = var.resource_group_name
}

data "azurerm_virtual_network" "npdvnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.npdrg.name
}

data "azurerm_subnet" "websnet" {
  name                 = var.web_subnet_name
  resource_group_name  = data.azurerm_resource_group.npdrg.name
  virtual_network_name = data.azurerm_virtual_network.npdvnet.name
}

resource "azurerm_network_interface" "webnic" {
  name                = var.web_network_interface_name
  location            = data.azurerm_resource_group.npdrg.location
  resource_group_name = data.azurerm_resource_group.npdrg.name
  tags = {   
    "Environment"       = "npd"
    "Usage"             = "webserver"  
  }

  ip_configuration {
    name                          = "npdwebconfiguration"
    subnet_id                     = data.azurerm_subnet.websnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "webvm" {
  name                  = var.web_vm_name
  location              = data.azurerm_resource_group.npdrg.location
  resource_group_name   = data.azurerm_resource_group.npdrg.name
  network_interface_ids = [azurerm_network_interface.webnic.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "ol87-lvm-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "webosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "npdwebvm"
    admin_username = "ismileadmin"
    admin_password = "Ismile@12345"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "test"
  }
}