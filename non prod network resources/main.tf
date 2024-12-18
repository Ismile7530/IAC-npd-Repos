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

resource "azurerm_resource_group" "npdrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "npdvnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.npdrg.location
  resource_group_name = azurerm_resource_group.npdrg.name
}

resource "azurerm_subnet" "websnet" {
  name                 = var.web_subnet_name
  resource_group_name  = azurerm_resource_group.npdrg.name
  virtual_network_name = azurerm_virtual_network.npdvnet.name
  address_prefixes     = ["10.0.10.0/24"]
}


