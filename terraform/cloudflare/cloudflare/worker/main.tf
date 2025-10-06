# Resource  type : cloudflare_worker
# Resource  name : generic
# Attribute name : account_id
# Argument       : var.account_id

resource "cloudflare_worker" "generic" {
  account_id = var.account_id # 🔒 Required argument.
  name       = var.name       # 🔒 Required argument.
  logpush    = var.logpush    # ✅ Optional argument — recommended to keep.
}
