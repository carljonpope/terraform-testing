# Deploy Windows Server 2019 VM into Azure

# Configure Azure provider
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}

# Create resource group for VM
resource "azurerm_resource_group" "rg" {
    name = var.rgName
    location = var.location
    tags = var.tags
}

# Create vNet
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags

}

# Create subnet
resource "azurerm_subnet" "subnet1" {
  name                  = "subnet1"
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet1.name
  address_prefixes      = ["10.0.1.0/24"]
}

# Create network interface
resource "azurerm_network_interface" "nic1" {
  name                  = "${var.vmName}nic1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  tags                  = var.tags
  
  ip_configuration {
    name                          = "${var.vmName}nic1Config"
    subnet_id                     = azurerm_subnet.subnet1.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

# Create Windows VM
resource "azurerm_virtual_machine" "vm1" {
  name                   = var.vmName
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg.name
  network_interface_ids  = azurerm_network_interface.nic1.id
  vm_size                = "Standard_DS1_v2"
  tags                   = var.tags

  storage_os_disk {
    name              = "${var.vmName}osDisk"
    caching           = 
  }
}