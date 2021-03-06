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

resource "azurerm_public_ip" "bobo-pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.bobo-rg.name
  location            = azurerm_resource_group.bobo-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_network_interface" "bobo-nic" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.bobo-rg.name
  location            = azurerm_resource_group.bobo-rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bobo-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.bobo-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "bobo-vm" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.bobo-rg.name
  location                        = azurerm_resource_group.bobo-rg.location
  size                            = "Standard_B2s"
  admin_username                  = "bobouser"
  network_interface_ids = [
    azurerm_network_interface.bobo-nic.id,
  ]

  admin_ssh_key {
    username = "bobouser"
    public_key = var.sshpub
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

resource "azurerm_subnet_network_security_group_association" "bobo-nsg-assoc" {
  subnet_id                 = azurerm_subnet.bobo-subnet.id
  network_security_group_id = module.network-security-group.network_security_group_id
}

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.bobo-rg.name
  location              = azurerm_resource_group.bobo-rg.location
  security_group_name   = "${var.prefix}-nsg"
  #source_address_prefix = ["76.171.45.139"]
  destination_address_prefixes = [azurerm_public_ip.bobo-pip.ip_address, "10.0.2.4"]

  predefined_rules = [
    {
      name     = "SSH"
      priority = "201"
    }
  ]

  custom_rules = [
    {
      name                   = "Deny-all-out"
      priority               = 4096
      direction              = "Outbound"
      access                 = "Deny"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "*"
      destination_address_prefix = "*"
      description            = "Explicit Deny All Traffic"
    },
    {
      name                   = "Deny-all-in"
      priority               = 4096
      direction              = "Inbound"
      access                 = "Deny"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "*"
      source_address_prefix  = "*"
      destination_address_prefix = "*"
      description            = "Explicit Deny All Traffic"
    },
    {
      name                   = "Allow-http-out"
      priority               = 999
      direction              = "Outbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "80"
      source_address_prefix  = "10.0.2.4"
      destination_address_prefix = "Internet"
      description            = "Allow http out"
    },
    {
      name                   = "Allow-https-out"
      priority               = 1000
      direction              = "Outbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "443"
      source_address_prefix  = "10.0.2.4"
      destination_address_prefix = "Internet"
      description            = "Allow https out"
    },
    {
      name                   = "Allow-jenkins-in"
      priority               = 1000
      direction              = "inbound"
      access                 = "Allow"
      protocol               = "*"
      source_port_range      = "*"
      destination_port_range = "8080"
      source_address_prefix  = "76.171.45.139"
      destination_address_prefixes = [azurerm_public_ip.bobo-pip.ip_address, "10.0.2.4"]
      description            = "Allow to Jenkins"
    }
  ]

  tags = {
    environment = "sandbox"
    costcenter  = "none"
  }

  depends_on = [azurerm_resource_group.bobo-rg]
}