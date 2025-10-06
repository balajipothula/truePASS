# Resource  type : cloudflare_worker
# Resource  name : generic
# Attribute name : account_id
# Argument       : var.account_id

resource "cloudflare_worker" "generic" {
  account_id = var.account_id
  name       = var.name
  logpush    = var.logpush

  observability = {
    enabled            = var.observability_enabled
    head_sampling_rate = var.observability_head_sampling_rate
    logs = {
      enabled            = var.logs_enabled
      head_sampling_rate = var.logs_head_sampling_rate
      invocation_logs    = var.invocation_logs
    }
  }

  subdomain = {
    enabled          = var.subdomain_enabled
    previews_enabled = var.subdomain_previews_enabled
  }

  tags           = var.tags
  tail_consumers = var.tail_consumers
}
