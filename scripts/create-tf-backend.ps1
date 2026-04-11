param(
    [string]$ResourceGroupName = "my-tfstate-rg",
    [string]$Location = "uksouth",
    [string]$StorageAccountName = "mytfstate$((Get-Random -Maximum 9999))",
    [string]$ContainerName = "tfstate"
)

az login
az group create --name $ResourceGroupName --location $Location

az storage account create `
    --name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --location $Location `
    --sku Standard_LRS `
    --encryption-services blob

$accountKey = az storage account keys list `
    --resource-group $ResourceGroupName `
    --account-name $StorageAccountName `
    --query [0].value -o tsv

az storage container create `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --account-key $accountKey

Write-Host "Storage Account: $StorageAccountName"
Write-Host "Container: $ContainerName"
Write-Host "Resource Group: $ResourceGroupName"
