$location = $env:ARM_REGION
$resourceGroupName = "rg-wazuh-infra-backend"

# Set the storage account name and container names
$storageAccountName = "stwazuhinfrabackend"
$containerNames = @("tfstate")


# Check if the resource group already exists
$resourceGroupExists = (az group show --name $resourceGroupName --subscription $env:ARM_SUBSCRIPTION_ID --output tsv --query name) -ne $null

# Create the resource group if it doesn't exist
if (!$resourceGroupExists) {
    az group create --name $resourceGroupName --location $location --subscription $env:ARM_SUBSCRIPTION_ID
}

# Check if the storage account already exists
$storageAccountExists = (az storage account show --name $storageAccountName --resource-group $resourceGroupName --subscription $env:ARM_SUBSCRIPTION_ID --output tsv --query name) -ne $null

# Create the storage account if it doesn't exist
if (!$storageAccountExists) {
    az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS --subscription $env:ARM_SUBSCRIPTION_ID
}

# Create the containers
foreach ($containerName in $containerNames) {
    $containerExists = (az storage container exists --name $containerName --account-name $storageAccountName --account-key (az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --subscription $env:ARM_SUBSCRIPTION_ID --query "[0].value" -o tsv) --output tsv --query exists) -eq "true"
    
    if (!$containerExists) {
        az storage container create --name $containerName --account-name $storageAccountName --account-key (az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --subscription $env:ARM_SUBSCRIPTION_ID --query "[0].value" -o tsv) --public-access off --subscription $env:ARM_SUBSCRIPTION_ID
    }
}