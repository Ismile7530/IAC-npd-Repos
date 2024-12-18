variable "resource_group_name" {
    type = string
    default     = "rg-npd-01"
    description = "Name of the Resource group in which to deploy service objects"
}

variable "location" {
    type = string
    default     = "East US"
    description = "Location of the resource group."
}

variable "vnet_name" {
    type = string
    default     = "vnet-npd-01"
}

variable "web_subnet_name" {
    type = string
    default = "snet-npd-web-01"
}