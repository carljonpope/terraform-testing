# Create a storage repository in Azure and use to store Terraform state
https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage

Create resource group
``` az group create --name "terraformState" --location uksouth ```

Create storage account
``` az storage account create --resource-group "terraformState" --name "cptfstate" --sku Standard_LRS --encryption-services blob ```

Create blob container
``` az storage container create --name "cptfstate" --account-name "cptfstate" --account-key "ACCOUNT_KEY" ```




