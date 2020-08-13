

```
# Configure the Azure provider
provider "azurerm" {
    version = "~>1.32.0"
    subscription_id = "090ccd18-57c9-4735-84fc-64f9fb9390af"
}

# Create a new resource group
resource "azurerm_resource_group" "myTfResourceGroup" {
    name     = "myTFResourceGroup"
    location = "uksouth"
    tags = {
	Environment = "Terraform getting started"
	Team = "DevOps"
	   }
}
# Create a vNet
resource "azurerm_virtual_network" "myTfVnet" {
	name =			"myTfVnet"
	address_space = 	["10.0.0.0/16"]
	location =		"uksouth"
	resource_group_name = 	azurerm_resource_group.myTfResourceGroup.name
}

# Create subnet
resource "azurerm_subnet" "myTfSubnet" {
	name =			"myTfSubnet"
	resource_group_name = 	azurerm_resource_group.myTfResourceGroup.name
	virtual_network_name =	azurerm_virtual_network.myTfVnet.name
	address_prefix = 	"10.0.1.0/24"
}

#Create public IP
resource "azurerm_public_ip" "myTfPublicIp" {
	name = 			"myTfPublicIp"
	location = 		"uksouth"
	resource_group_name =	azurerm_resource_group.myTfResourceGroup.name
	allocation_method = 	"Static"
}

# Create NSG and rule
resource "azurerm_network_security_group" "myTfNsg" {
	name = 			"myTfNsg"
	location = 		"uksouth"
	resource_group_name = 	azurerm_resource_group.myTfResourceGroup.name

	security_rule {
		name = 				"SSH"
		priority = 			1001
		direction =			"Inbound"
		access = 			"Allow"
		protocol =			"TCP"
		source_port_range =		"*"
		destination_port_range =	"22"
		source_address_prefix =		"*"
		destination_address_prefix =	"*"
	}
}

# Create network interface
resource "azurerm_network_interface" "myTfNic" {
	name =				"myTfNic"
	location =			"uksouth"
	resource_group_name =		azurerm_resource_group.myTfResourceGroup.name
	network_security_group_id =	azurerm_network_security_group.myTfNsg.id

	ip_configuration {
		name =				"myTfNicConfig"
		subnet_id =			azurerm_subnet.myTfSubnet.id
		private_ip_address_allocation =	"dynamic"
		public_ip_address_id =		azurerm_public_ip.myTfPublicIp.id
	}
}

# Create Linux VM
resource "azurerm_virtual_machine" "myTfVm" {
	name = 					"myTfVm"
	location =				"uksouth"
	resource_group_name =	azurerm_resource_group.myTfResourceGroup.name
	network_interface_ids =	[azurerm_network_interface.myTfNic.id]
	vm_size = 				"Standard_D2S_v3"


storage_os_disk {
    name              = "myTfOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myTfVm"
    admin_username = "plankton"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
```
