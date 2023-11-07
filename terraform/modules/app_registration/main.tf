data "azuread_client_config" "current" {}

resource "random_uuid" "apprg" {
}

resource "azuread_application" "apprg" {
  display_name     = format("apprg-%s-%s-%s-%s", var.project, var.name, var.environment, var.location)
  identifier_uris  = [format("api://apprg-%s-%s-%s-%s", var.project, var.name, var.environment, var.location)]
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ${var.name} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${var.name}"
      enabled                    = true
      id                         = random_uuid.apprg.result
      type                       = "User"
      user_consent_description   = "Allow the application to access the ${var.name} on your behalf."
      user_consent_display_name  = "Access the app ${var.name}"
      value                      = "user_impersonation"
    }

  }

  web {
    redirect_uris = ["https://app-${var.project}-${var.name}-${var.environment}-${var.location}-001.azurewebsites.net/.auth/login/aad/callback"]
    implicit_grant {
      id_token_issuance_enabled = true
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "apprg" {
  application_id = azuread_application.apprg.id
}