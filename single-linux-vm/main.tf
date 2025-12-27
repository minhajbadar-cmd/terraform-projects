resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Network Interface
resource "azurerm_network_interface" "this" {
  name                = "nic-${var.vm_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "my-terraform-nic-ip-config"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.vm_name
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
  network_interface_ids           = [azurerm_network_interface.this.id]
  size                            = "Standard_DS1_v2"
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "my-terraform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = var.tags
}
