# Initialize the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

/*
# Creation of truepass_d1_database resource.
module "truepass_d1_database" {
  source                = "../terraform/cloudflare/cloudflare/d1_database"

  account_id            = var.cloudflare_account_id # 🔒 Required argument.
  name                  = "truepass-db"             # 🔒 Required argument.
  primary_location_hint = "apac"                    # ✅ Optional argument — recommended to keep.
}
*/
/*
# Creation of truepass_worker resource.
module "truepass_worker" {
  source                = "../terraform/cloudflare/cloudflare/worker"

  account_id = var.cloudflare_account_id # 🔒 Required argument.
  name       = "truepass-worker"         # 🔒 Required argument.
  logpush    = false                     # ✅ Optional argument — recommended to keep.
}
*/

module "analytics_worker" {
  source     = "../terraform/cloudflare/cloudflare/worker"
  account_id = var.cloudflare_account_id
  name       = "analytics-worker"
  logpush    = false
  tags       = ["metrics", "internal"]
  observability_enabled            = true
  observability_head_sampling_rate = 0.5
  logs_enabled                     = true
  logs_head_sampling_rate          = 0.5
  invocation_logs                  = true
  subdomain_enabled                = true
  subdomain_previews_enabled       = true
  tail_consumers = [
    { name = "log-consumer-worker" }
  ]
}
