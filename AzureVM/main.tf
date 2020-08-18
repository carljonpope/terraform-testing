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
    
}