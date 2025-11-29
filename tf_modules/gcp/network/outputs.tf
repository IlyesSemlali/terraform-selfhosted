output "name_servers" {
  description = "DNS Name Servers for the domain registration"
  value       = sort(google_dns_managed_zone.main.name_servers)
}
