# Resource  type : cloudflare_d1_database
# Resource  name : generic
# Attribute name : account_id
# Argument       : var.account_id

resource "cloudflare_d1_database" "generic" {
  account_id            = var.account_id            # 🔒 Required argument.
  name                  = var.name                  # 🔒 Required argument.
  primary_location_hint = var.primary_location_hint # ✅ Optional argument — recommended to keep.
}
