# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Creation of truepass_d1_database.
module "truepass_d1_database" {
  source                = "../terraform/cloudflare/cloudflare/d1_database"

  account_id            = var.cloudflare_account_id # 🔒 Required argument.
  name                  = "truepass-db"             # 🔒 Required argument.
  primary_location_hint = "apac"                    # ✅ Optional argument — recommended to keep.
}
