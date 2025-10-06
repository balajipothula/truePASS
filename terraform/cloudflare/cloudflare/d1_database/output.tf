# Resource  type : cloudflare_d1_database
# Resource  name : generic
# Attribute name : created_at

output "created_at" {
  value       = cloudflare_d1_database.generic.created_at
  description = "Specifies the timestamp the resource was created as an ISO8601 string."
  sensitive   = false
}

output "file_size" {
  value       = cloudflare_d1_database.generic.file_size
  description = "The D1 database's size, in bytes."
  sensitive   = false
}

output "id" {
  value       = cloudflare_d1_database.generic.id
  description = "D1 database identifier (UUID)."
  sensitive   = true
}

output "num_tables" {
  value       = cloudflare_d1_database.generic.num_tables
  description = "Number of tables in the D1 database."
  sensitive   = false
}

output "uuid" {
  value       = cloudflare_d1_database.generic.uuid
  description = "D1 database identifier (UUID)."
  sensitive   = false
}

output "version" {
  value       = cloudflare_d1_database.generic.version
  description = "Version of the D1 database schema or engine."
  sensitive   = false
}
