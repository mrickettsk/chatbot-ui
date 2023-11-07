locals {
  tags = {
    project     = var.project
    environment = var.environment
    datetime    = timestamp()
  }

  apps = {
    chatbot_ui = {
      name              = "chatbot-ui"
      docker_image_name = "mrickettsk/chatbot-ui:${var.image_tag}"

      app_vars = {
        OPENAI_API_KEY      = var.openai_api_key
        OPENAI_API_TYPE     = "azure"
        AZURE_DEPLOYMENT_ID = "default"
        OPENAI_API_HOST     = var.openai_api_url
        OPENAI_API_VERSION  = "2023-03-15-preview"
        WEBSITES_PORT       = "3000"
      }
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s-%s-%s", var.project, var.environment, var.location)
  location = var.location
}

module "app_service" {
  source              = "../../modules/app_services"
  environment         = var.environment
  project             = "chatbotui"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  os_type             = "Linux"
  apps                = local.apps
  registry_name       = "https://ghcr.io"
  allowed_inbound_ips = var.allowed_inbound_ips

  tags = local.tags
}