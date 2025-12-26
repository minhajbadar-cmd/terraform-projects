resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
resource "azurerm_virtual_network" "this" {
  name                = "vnet-prod-01"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = "subnet-prod-01"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-vm-ssh"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

module "linux_vm_01" {
  source = "./modules/linux-vm"

  vm_name             = "vm-prod-01"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  admin_username      = var.admin_username
  ssh_public_key      = file("~/.ssh/id_rsa_azure.pub")
  tags                = var.tags
  subnet_id           = azurerm_subnet.this.id
  vnet_id             = azurerm_virtual_network.this.id
  network_security_id = azurerm_network_security_group.this.id
}

module "linux_vm_02" {
  source = "./modules/linux-vm"

  vm_name             = "vm-prod-02"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  admin_username      = var.admin_username
  ssh_public_key      = file("~/.ssh/id_rsa_azure.pub")
  tags                = var.tags
  subnet_id           = azurerm_subnet.this.id
  vnet_id             = azurerm_virtual_network.this.id
  network_security_id = azurerm_network_security_group.this.id
}
