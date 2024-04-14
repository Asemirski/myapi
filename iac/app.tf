resource "azurerm_resource_group" "myapi_resource_group" {
  name     = var.resource_group_name
  location = var.region

  tags = {
    terraform = true
    project   = local.project
  }
}

# Network
resource "azurerm_virtual_network" "myapi_virtual_network" {
  name                = var.vnet_name
  location            = azurerm_resource_group.myapi_resource_group.location
  resource_group_name = azurerm_resource_group.myapi_resource_group.name
  address_space       = [local.vnet_address_space]

  tags = {
    terraform = true
    project   = local.project
  }
}

resource "azurerm_subnet" "myapi_subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.myapi_resource_group.name
  virtual_network_name = azurerm_virtual_network.myapi_virtual_network.name
  address_prefixes     = [local.subnet_address_space]
  service_endpoints    = ["Microsoft.KeyVault"]
  delegation {
    name = "webapp_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# Key Vault
resource "azurerm_key_vault" "myapi-key-vault" {
  name                       = local.key_vault_name
  location                   = azurerm_resource_group.myapi_resource_group.location
  resource_group_name        = azurerm_resource_group.myapi_resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  purge_protection_enabled = false
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = [var.my_ip]
    virtual_network_subnet_ids = [azurerm_subnet.myapi_subnet.id]
  }
}

resource "azurerm_key_vault_access_policy" "default_access_policy" {
  key_vault_id = azurerm_key_vault.myapi-key-vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Delete", "Get", "List", "Purge", "Set", ]
}

# Web app
resource "azurerm_service_plan" "myapi_service_plan" {
  name                = "asp-${local.project}-${random_string.numbers.result}"
  resource_group_name = azurerm_resource_group.myapi_resource_group.name
  location            = azurerm_resource_group.myapi_resource_group.location
  os_type             = "Linux"
  sku_name            = var.web_app_sku

  tags = {
    terraform = true
    project   = local.project
  }
}

resource "azurerm_linux_web_app" "myapi_web_app" {
  depends_on = [azurerm_key_vault.myapi-key-vault]

  name                = local.web_app_name
  resource_group_name = azurerm_resource_group.myapi_resource_group.name
  location            = azurerm_resource_group.myapi_resource_group.location
  service_plan_id     = azurerm_service_plan.myapi_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    app_command_line = "python3 main.py '${azurerm_key_vault.myapi-key-vault.vault_uri}'"
    application_stack {
      python_version = 3.11
    }
  }
}

resource "azurerm_key_vault_access_policy" "system_identity_policy" {
  key_vault_id = azurerm_key_vault.myapi-key-vault.id
  tenant_id    = azurerm_linux_web_app.myapi_web_app.identity[0].tenant_id
  object_id    = azurerm_linux_web_app.myapi_web_app.identity[0].principal_id

  secret_permissions = ["List", "Get",]
}

# Secret
resource "azurerm_key_vault_secret" "myapi_openai_secret" {
  depends_on   = [azurerm_key_vault_access_policy.default_access_policy]
  name         = "openai-api-key"
  value        = var.openai_api_key
  key_vault_id = azurerm_key_vault.myapi-key-vault.id
}