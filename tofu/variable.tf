variable "cloudflare_account_id" {
  type        = string
  default     = null
  description = "Account identifier tag."
  sensitive   = true
}

variable "location" {
  type        = string
  default     = "apac"
  description = "Cloudflare location to launch your resources."
  validation {
    condition     = var.location != null
    error_message = "Error: location value must not null and must consist of alphabets only."
  }
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  default     = null
  description = "CLOUDFLARE_API_TOKEN which is stored in GitHub repository secrets."
  sensitive   = true
}

variable "r2_access_key" {
  type        = string
  default     = null
  description = "R2_ACCESS_KEY which is stored in GitHub repository secrets."
  sensitive   = true
}

variable "r2_secret_key" {
  type        = string
  default     = null
  description = "R2_SECRET_KEY which is stored in GitHub repository secrets."
  sensitive   = true
}

variable "tfstate_bucket" {
  type        = string
  default     = "truepass"
  description = "TruePASS terraform state bucket name."
  sensitive   = false
}

variable "r2_endpoint" {
  type        = string
  default     = "null"
  description = "R2 Endpoint URL."
  sensitive   = false
}

variable "github_runner_ip" {
  type    = string
  default = "127.0.0.1/32"
  description = "The IPv4 Address of the current Github Actions Runner."
  sensitive   = false
}
