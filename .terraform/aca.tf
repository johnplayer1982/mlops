resource "azurerm_container_app_environment" "aca_env" {
  name                = var.aca_env_name
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name
}

resource "azurerm_container_app" "aca" {
  name                         = var.aca_name
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.acr_rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.aca_name
      image = "nginx:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-secret"
  }

  secret {
    name  = "acr-secret"
    value = azurerm_container_registry.acr.admin_password
  }

  identity {
    type = "SystemAssigned"
  }
}
