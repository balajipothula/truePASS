# Declare the providers and version.
terraform {

  required_version = ">= 1.6.0"

  required_providers {

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11.0"
    }

  }

  backend "s3" {

    region                      = "apac"
    bucket                      = "truepass"
    key                         = "terraform/truepass.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    access_key                  = var.r2_access_key
    secret_key                  = var.r2_secret_key
    endpoints = {
      s3 = var.r2_endpoint
    }

  }

}
