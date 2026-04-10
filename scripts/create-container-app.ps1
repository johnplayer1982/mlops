param(
    [string]$SubscriptionId,
    [string]$ResourceGroupName = 'my-mlops-rg',
    [string]$Location = "uksouth",
    [string]$EnvironmentName = "my-mlops-review-env",
    [string]$ContainerAppName = "my-mlops-review-app",
    [string]$AcrName,
    [string]$AcrUsername,
    [string]$AcrPassword,
    [string]$ImageName = "my-ml-app:latest"
)

az login
az account set --subscription $SubscriptionId

# Create resource group
az group create `
    --name $ResourceGroupName `
    --location $Location

# Create Container Apps environment
az containerapp env create `
    --name $EnvironmentName `
    --resource-group $ResourceGroupName `
    --location $Location

# Get ACR login server
$acrLoginServer = az acr show `
    --name $AcrName `
    --query "loginServer" `
    -o tsv

# Create the Container App
az containerapp create `
    --name $ContainerAppName `
    --resource-group $ResourceGroupName `
    --environment $EnvironmentName `
    --image "$acrLoginServer/$ImageName" `
    --ingress external `
    --target-port 80 `
    --registry-server $acrLoginServer `
    --registry-username $AcrUsername `
    --registry-password $AcrPassword `
    --system-assigned-identity `
    --query "properties.configuration.ingress.fqdn"
