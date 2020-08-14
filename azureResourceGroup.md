# Create resource group in Azure using Azure Cloud Shell & Terraform

1.
```
mkdir rGtest 
cd rGtest
```
2. ``` vi main.tf ```

```
# Configure the Microsoft Azure Provider.
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}



# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}test3"
  location = var.location
  tags     = var.tags
}
```

3. ``` vi terraform.tfvars ```
```
location = "uksouth"
prefix = "my"
```

4. ``` terraform init ```
5. ``` terraform plan ```
```

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "mytest3"
      + tags     = {
          + "Dept" = "eng"
          + "Env"  = "tst"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

6. ``` terraform apply ```
7. ``` terraform destroy ```
