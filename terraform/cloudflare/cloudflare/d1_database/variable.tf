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
  default     = "cf_d1_db"
  description = "D1 database name."
  validation {
    condition    = can(regex("^[a-z][a-z0-9-]{2,63}$", var.name))
    error_message = "Error: `name` must be 3-64 chars, start with a lowercase letter, and use only lowercase letters, digits, or hyphens."
  }
  sensitive   = false
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
