# Resource  type : cloudflare_worker
# Resource  name : generic
# Variable  name : account_id

variable "account_id" {
  type        = string
  default     = null
  description = "Identifier."
  sensitive   = true
}

variable "name" {
  type        = string
  default     = "cf-worker"
  description = "Name of the Worker."
  validation {
    condition     = can(regex("^[a-z0-9-]{1,64}$", var.name))
    error_message = "Error: `name` must be less than 64 chars, lowercase letters, digits, or dashes."
  }
  sensitive   = false
}

variable "logpush" {
  type        = bool
  default     = false
  description = "Whether logpush is enabled for the Worker."
  validation {
    condition     = contains([true, false], var.logpush)
    error_message = "Error: `logpush` must be either `true` or `false`"
  }
  sensitive   = false
}
