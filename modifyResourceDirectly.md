# Test to see what happens when a terraform deployed resource is modified directly
#Using Azure Cloud Shell

```
mkdir test5
cd test5
vi main.tf
```

Main.tf
``` 
# Configure the Microsoft Azure Provider.
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "test5"
  location = "uksouth"
  tags ={
	Test  = "test"
	Test2 = "test2"
	}
}
```

```
terraform plan
```

```
terraform apply
```

```
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "test5"
      + tags     = {
          + "Test"  = "test"
          + "Test2" = "test2"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

Manually change Test2 tag = test3

```
terraform plan
```


```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/090ccd18-57c9-4735-84fc-64f9fb9390af/resourceGroups/test4"
        location = "uksouth"
        name     = "test4"
      ~ tags     = {
            "Test"  = "test"
          ~ "Test2" = "test3" -> "test2"
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```


```
terraform destroy
```





