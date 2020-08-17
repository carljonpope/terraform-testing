# Create a storage repository in Azure and use to store Terraform state
https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage

Create resource group
``` 
az group create --name "terraformState" --location uksouth 
```

Create storage account
``` 
az storage account create --resource-group "terraformState" --name "cptfstate" --sku Standard_LRS --encryption-services blob 
```

Create blob container
``` 
az storage container create --name "cptfstate" --account-name "cptfstate" --account-key "ACCOUNT_KEY" 
```


Create an environment variable named ARM_ACCESS_KEY with the value of the Azure Storage access key.
```
export ARM_ACCESS_KEY= ACCOUNT_KEY
```

Create a resource group using remote state
```
# Configure the Microsoft Azure Provider.
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}

# configure the backend
terraform {
	backend "azurerm" {
		resource_group_name = 	"terraformState"
		storage_account_name =	"cptfstate"
		container_name =	"cptfstate"
		key =			"terraform.tfstate"
			}
	}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "test4"
  location = "uksouth"
  tags ={
	Test  = "test"
	Test2 = "test2"
	}
}
```

```
terraform init
```

```
terraform apply
```

Resource group created & terraform.tfstate created in storage account
