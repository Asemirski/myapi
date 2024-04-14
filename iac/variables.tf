variable "region" {
  type        = string
  default     = "eastus"
  description = "Region to deploy resources"
}

variable "resource_group_name" {
  type        = string
  default     = "myapi-rg-2"
  description = "Name of the resource group to create myapi service resources"
}

variable "vnet_name" {
  type        = string
  default     = "myapi-vnet"
  description = "Name of the myapi vnet"
}

variable "web_app_sku" {
  type        = string
  default     = "B3"
  description = "Web App service plan sku"
}

variable "my_ip" {
  type        = string
  description = "ip of home/office/whatever workstation"
}

variable "openai_api_key" {
  type        = string
  description = "openai_api_key"
}