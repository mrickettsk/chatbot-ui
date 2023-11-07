output "client_id" {
  value = azuread_application.apprg.client_id
}

output "client_secret" {
  value     = azuread_application_password.apprg.value
  sensitive = true
}

output "tenant_id" {
  value     = data.azuread_client_config.current.tenant_id
  sensitive = true
}