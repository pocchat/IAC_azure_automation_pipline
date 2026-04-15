variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "AutomationRG"
}

variable "vnet_name" {
  default = "automation-vnet"
}

variable "subnet_name" {
  default = "automation-subnet"
}

variable "vm_name" {
  default = "automation-vm"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH Public Key. Leave empty to auto-generate a key pair."
  default     = null
}