output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aca_fqdn" {
  value = azurerm_container_app.aca.latest_revision_fqdn
}
