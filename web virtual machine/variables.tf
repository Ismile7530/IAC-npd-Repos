variable "resource_group_name" {
  type        = string
  default     = "rg-npd-01"
  description = "Name of the Resource group in which to deploy service objects"
}


variable "vnet_name" {
  type    = string
  default = "vnet-npd-01"
}

variable "web_subnet_name" {
  type    = string
  default = "snet-npd-web-01"
}

variable "web_network_interface_name" {
  type    = string
  default = "nicvmnpdweb01"
}

variable "web_vm_name" {
  type    = string
  default = "vmnpdweb01"
}