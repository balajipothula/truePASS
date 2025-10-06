# Resource  type : cloudflare_worker
# Resource  name : generic
# Variable  name : account_id
/*
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
*/

variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "name" {
  type        = string
  description = "Name of the Worker"
}

variable "logpush" {
  type        = bool
  default     = false
  description = "Enable logpush for the Worker"
}

variable "observability_enabled" {
  type        = bool
  default     = false
  description = "Enable observability"
}

variable "observability_head_sampling_rate" {
  type        = number
  default     = 1.0
  description = "Sampling rate for observability (0 to 1)"
}

variable "logs_enabled" {
  type        = bool
  default     = false
  description = "Enable logs"
}

variable "logs_head_sampling_rate" {
  type        = number
  default     = 1.0
  description = "Sampling rate for logs (0 to 1)"
}

variable "invocation_logs" {
  type        = bool
  default     = false
  description = "Enable invocation logs"
}

variable "subdomain_enabled" {
  type        = bool
  default     = false
  description = "Enable *.workers.dev subdomain"
}

variable "subdomain_previews_enabled" {
  type        = bool
  default     = false
  description = "Enable preview URLs"
}

variable "tags" {
  type        = set(string)
  default     = []
  description = "Tags for the Worker"
}

variable "tail_consumers" {
  type = list(object({
    name = string
  }))
  default     = []
  description = "List of Workers that consume logs from this Worker"
}
