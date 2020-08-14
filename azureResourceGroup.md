# Create resource group in Azure using Azure Cloud Shell & Terraform

1.
```
mkdir rGtest 
cd rGtest
```
2. ``` vi main.tf ```
3.
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

4. ``` terraform init ```
5. ``` terraform plan ```
6. ``` terraform apply ```
7. ``` terraform destroy ```
