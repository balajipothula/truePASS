# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_d1_database" "truepass_d1_database" {
  account_id            = var.cloudflare_account_id
  name                  = "truepass_db"
  primary_location_hint = "apac"
}
