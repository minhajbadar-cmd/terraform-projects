variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "tags" {
  type = map(string)
}
