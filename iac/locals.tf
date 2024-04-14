locals {
  project              = "myapi"
  subnet_name          = "${local.project}-webapp-subnet"
  vnet_address_space   = "192.168.0.0/23"
  subnet_address_space = "192.168.0.0/24"
  service_user         = "myapi_service_user"
  web_app_name         = "myapiwebapp${random_string.numbers.result}"
  key_vault_name       = "myapi-keyvault-${random_string.numbers.result}"
}