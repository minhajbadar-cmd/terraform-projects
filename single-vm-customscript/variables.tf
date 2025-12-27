variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
