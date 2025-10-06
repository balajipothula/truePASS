output "cloudflare_account_name" {
  value       = data.cloudflare_account.current.name
  description = "Account name."
  sensitive   = false
}

output "cloudflare_account_type" {
  value       = data.cloudflare_account.current.type
  description = "Account type."
  sensitive   = false
}

output "cloudflare_account_dns_settings_zone_defaults_nameservers_type" {
  value       = data.cloudflare_account_dns_settings.current.zone_defaults.nameservers.type
  description = "Nameserver type."
  sensitive   = false
}
