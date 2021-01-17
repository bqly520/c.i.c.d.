provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  # version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "bobo-rg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "bobo-vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.bobo-rg.location
  resource_group_name = azurerm_resource_group.bobo-rg.name
}

resource "azurerm_subnet" "bobo-subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.bobo-rg.name
  virtual_network_name = azurerm_virtual_network.bobo-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "bobo-nic" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.bobo-rg.name
  location            = azurerm_resource_group.bobo-rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bobo-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "bobo-vm" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.bobo-rg.name
  location                        = azurerm_resource_group.bobo-rg.location
  size                            = "Standard_B1s"
  admin_username                  = "bobouser"
  network_interface_ids = [
    azurerm_network_interface.bobo-nic.id,
  ]

  admin_ssh_key {
    username = "bobouser"
    public_key = file(var.sshpub)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}