# Resource  type : cloudflare_d1_database
# Resource  name : generic
# Variable  name : account_id

variable "account_id" {
  type        = string
  default     = null
  description = "Account identifier tag."
  sensitive   = true
}

variable "name" {
  type        = string
  default     = "cf-d1-db"
  description = "D1 database name."
  validation {
    condition = can(regex("^[a-z0-9-]{1,31}$", var.name)) && !contains(var.name, " ") && !contains(var.name, "_")
    error_message = "Error: `name` must be <32 chars, lowercase, and use only letters, digits, or dashes."
  }
  sensitive = false
}

variable "primary_location_hint" {
  type        = string
  default     = "apac"
  description = "Specify the region to create the D1 primary."
  validation {
    condition     = contains(["wnam", "enam", "weur", "eeur", "apac", "oc"], var.primary_location_hint)
    error_message = "Error: `primary_location_hint` must be one of `wnam`, `enam`, `weur`, `eeur`, `apac`, `oc`"
  }
  sensitive   = false
}
