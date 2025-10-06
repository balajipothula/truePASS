# Resource  type : cloudflare_worker
# Resource  name : generic
# Attribute name : created_on

output "created_on" {
  value       = cloudflare_worker.generic.created_on
  description = "When the Worker was created."
  sensitive   = false
}

output "id" {
  value       = cloudflare_worker.generic.id
  description = "Immutable ID of the Worker."
  sensitive   = false
}

output "updated_on" {
  value       = cloudflare_worker.generic.updated_on
  description = "When the Worker was most recently updated."
  sensitive   = true
}
