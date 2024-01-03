variable "default_location" {
  type        = string
  default     = "eastus"
  description = "Default location"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource groups"
}

variable "key_vault_name_prefix" {
  type        = string
  default     = "kv"
  description = "Prefix of the azure key vault"
}

variable "web_app_name_prefix" {
  type        = string
  default     = "app"
  description = "Prefix of azure web app"
}

variable "app_service_plan_name_prefix" {
  type        = string
  default     = "apps"
  description = "Prefix of azure app service plan"
}

variable "default_environment" {
  type        = string
  default     = "prod"
  description = "Default environment"
}


variable "my-secret" {
  type        = string
  default     = "my-secret-value"
  description = "Default environment"
}