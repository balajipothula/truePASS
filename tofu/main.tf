# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token # The API Token for operations.
}

resource "cloudflare_dns_record" "ahooooy_dns_record" {
  zone_id = "33939467c9e0908bbf400f4182373e2d"
  name = "ahooooy.com"
  ttl = 3600
  type = "A"
  comment = "Domain verification record"
  content = "104.16.133.229"
  proxied = true
  settings = {
    ipv4_only = true
    ipv6_only = true
  }
  tags = ["owner:dns-team"]
}