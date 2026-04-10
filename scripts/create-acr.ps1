# Generate a random 6-character suffix
$SUFFIX = -join ((48..57) + (97..122) | Get-Random -Count 6 | % {[char]$_})
$RESOURCE_GROUP = "my-mlops-rg"
$ACR_NAME = "jpmlopsregistry$SUFFIX"
$LOCATION = "uksouth"

az login
az group create --name $RESOURCE_GROUP --location $LOCATION
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Standard
az ad sp create-for-rbac --name github-acr-push --scopes $(az acr show --name $ACR_NAME --query id --output tsv) --role acrpush --query "{username:appId,password:password,loginServer:loginServer}" --output json
