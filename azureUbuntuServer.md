# Create an Azure Ubuntu server from Terraform config file

Using Azure Cloud Shell:

1. ``` mkdir test1 ```
2. ``` vi main.tf ```

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
3. ``` terraform init ```

```
Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

4. ``` terraform plan -out newplan ```


```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_network_interface.myTfNic will be created
  + resource "azurerm_network_interface" "myTfNic" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_fqdn                 = (known after apply)
      + location                      = "uksouth"
      + mac_address                   = (known after apply)
      + name                          = "myTfNic"
      + network_security_group_id     = (known after apply)
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "myTFResourceGroup"
      + tags                          = (known after apply)
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + application_gateway_backend_address_pools_ids = (known after apply)
          + application_security_group_ids                = (known after apply)
          + load_balancer_backend_address_pools_ids       = (known after apply)
          + load_balancer_inbound_nat_rules_ids           = (known after apply)
          + name                                          = "myTfNicConfig"
          + primary                                       = (known after apply)
          + private_ip_address_allocation                 = "dynamic"
          + private_ip_address_version                    = "IPv4"
          + public_ip_address_id                          = (known after apply)
          + subnet_id                                     = (known after apply)
        }
    }

  # azurerm_network_security_group.myTfNsg will be created
  + resource "azurerm_network_security_group" "myTfNsg" {
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "myTfNsg"
      + resource_group_name = "myTFResourceGroup"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "SSH"
              + priority                                   = 1001
              + protocol                                   = "TCP"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
      + tags                = (known after apply)
    }

  # azurerm_public_ip.myTfPublicIp will be created
  + resource "azurerm_public_ip" "myTfPublicIp" {
      + allocation_method            = "Static"
      + fqdn                         = (known after apply)
      + id                           = (known after apply)
      + idle_timeout_in_minutes      = 4
      + ip_address                   = (known after apply)
      + ip_version                   = "IPv4"
      + location                     = "uksouth"
      + name                         = "myTfPublicIp"
      + public_ip_address_allocation = (known after apply)
      + resource_group_name          = "myTFResourceGroup"
      + sku                          = "Basic"
      + tags                         = (known after apply)
    }

  # azurerm_resource_group.myTfResourceGroup will be created
  + resource "azurerm_resource_group" "myTfResourceGroup" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "myTFResourceGroup"
      + tags     = {
          + "Environment" = "Terraform getting started"
          + "Team"        = "DevOps"
        }
    }

  # azurerm_subnet.myTfSubnet will be created
  + resource "azurerm_subnet" "myTfSubnet" {
      + address_prefix       = "10.0.1.0/24"
      + id                   = (known after apply)
      + ip_configurations    = (known after apply)
      + name                 = "myTfSubnet"
      + resource_group_name  = "myTFResourceGroup"
      + virtual_network_name = "myTfVnet"
    }

  # azurerm_virtual_machine.myTfVm will be created
  + resource "azurerm_virtual_machine" "myTfVm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "uksouth"
      + name                             = "myTfVm"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "myTFResourceGroup"
      + tags                             = (known after apply)
      + vm_size                          = "Standard_D2S_v3"

      + identity {
          + identity_ids = (known after apply)
          + principal_id = (known after apply)
          + type         = (known after apply)
        }

      + os_profile {
          + admin_password = (sensitive value)
          + admin_username = "plankton"
          + computer_name  = "myTfVm"
          + custom_data    = (known after apply)
        }

      + os_profile_linux_config {
          + disable_password_authentication = false
        }

      + storage_data_disk {
          + caching                   = (known after apply)
          + create_option             = (known after apply)
          + disk_size_gb              = (known after apply)
          + lun                       = (known after apply)
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = (known after apply)
          + name                      = (known after apply)
          + vhd_uri                   = (known after apply)
          + write_accelerator_enabled = (known after apply)
        }

      + storage_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "Canonical"
          + sku       = "16.04.0-LTS"
          + version   = "latest"
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = (known after apply)
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "myTfOsDisk"
          + os_type                   = (known after apply)
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_network.myTfVnet will be created
  + resource "azurerm_virtual_network" "myTfVnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "myTfVnet"
      + resource_group_name = "myTFResourceGroup"
      + tags                = (known after apply)

      + subnet {
          + address_prefix = (known after apply)
          + id             = (known after apply)
          + name           = (known after apply)
          + security_group = (known after apply)
        }
    }

Plan: 7 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: newplan

To perform exactly these actions, run the following command to apply:
    terraform apply "newplan"

```

5. ``` terraform apply newplan ```

```
azurerm_resource_group.myTfResourceGroup: Creating...
azurerm_resource_group.myTfResourceGroup: Creation complete after 1s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup]
azurerm_network_security_group.myTfNsg: Creating...
azurerm_virtual_network.myTfVnet: Creating...
azurerm_public_ip.myTfPublicIp: Creating...
azurerm_network_security_group.myTfNsg: Creation complete after 2s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Network/networkSecurityGroups/myTfNsg]
azurerm_public_ip.myTfPublicIp: Creation complete after 4s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Network/publicIPAddresses/myTfPublicIp]
azurerm_virtual_network.myTfVnet: Still creating... [10s elapsed]
azurerm_virtual_network.myTfVnet: Creation complete after 12s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Network/virtualNetworks/myTfVnet]
azurerm_subnet.myTfSubnet: Creating...
azurerm_subnet.myTfSubnet: Creation complete after 0s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Network/virtualNetworks/myTfVnet/subnets/myTfSubnet]
azurerm_network_interface.myTfNic: Creating...
azurerm_network_interface.myTfNic: Creation complete after 2s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Network/networkInterfaces/myTfNic]
azurerm_virtual_machine.myTfVm: Creating...
azurerm_virtual_machine.myTfVm: Still creating... [10s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [20s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [30s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [40s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [50s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [1m0s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [1m10s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [1m20s elapsed]
azurerm_virtual_machine.myTfVm: Still creating... [1m30s elapsed]
azurerm_virtual_machine.myTfVm: Creation complete after 1m36s [id=/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/myTFResourceGroup/providers/Microsoft.Compute/virtualMachines/myTfVm]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

6. ``` terraform destroy ```

