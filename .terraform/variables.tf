variable "resource_group_name" {
  description = "Name of the resource group."
  default     = "my-mlops-acr-rg"
}

variable "location" {
  description = "Azure region."
  default     = "uksouth"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry. Must be globally unique."
  default     = "mymlopsacr12345"
}

variable "aca_env_name" {
  description = "Name of the Container App Environment."
  default     = "my-mlops-aca-env"
}

variable "aca_name" {
  description = "Name of the Azure Container App."
  default     = "my-mlops-aca"
}

variable "aca_image" {
  description = "Image name to deploy (e.g. myimage:latest)."
  default     = "mymlopsacr12345.azurecr.io/myimage:latest"
}
