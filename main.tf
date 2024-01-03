
data "azurerm_client_config" "current" {}

locals {
  current_user_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_resource_group" "rg" {
  location = var.default_location
  name     = "${var.resource_group_name_prefix}-app-${var.default_environment}-${var.default_location}"
}

resource "azurerm_key_vault" "vault" {
  name                       = "${var.key_vault_name_prefix}-app-${var.default_environment}-${var.default_location}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.current_user_id
    secret_permissions =  ["Get", "List", "Set", "Delete"]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "my-secret"
  value        = var.my-secret
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.app_service_plan_name_prefix}-app-${var.default_environment}-${var.default_location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"

  depends_on = [
    azurerm_key_vault.vault
  ]
}

resource "azurerm_linux_web_app" "webapp" {
  name                  = "${var.web_app_name_prefix}-app-${var.default_environment}-${var.default_location}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config {
    minimum_tls_version = "1.2"
  }
  app_settings = {
    "MY_SECRET" = azurerm_key_vault_secret.secret.value
  }
}