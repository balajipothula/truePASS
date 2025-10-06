# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_account" "current" {
  account_id = var.cloudflare_account_id
}

/*
resource "cloudflare_zone" "example" {
  zone = var.cloudflare_zone # The domain name of the zone.
  account_id = data.cloudflare_account.ahooooy_account.id
}
*/