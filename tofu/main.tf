# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Creation of truepass_d1_database resource.
module "truepass_d1_database" {
  source                = "../terraform/cloudflare/cloudflare/d1_database"

  account_id            = var.cloudflare_account_id # 🔒 Required argument.
  name                  = "truepass-db"             # 🔒 Required argument.
  primary_location_hint = "apac"                    # ✅ Optional argument — recommended to keep.
}

# Creation of truepass_worker resource.
module "truepass_worker" {
  source                = "../terraform/cloudflare/cloudflare/worker"

  account_id = var.cloudflare_account_id # 🔒 Required argument.
  name       = "truepass-db"             # 🔒 Required argument.
  logpush    = false                     # ✅ Optional argument — recommended to keep.
}
