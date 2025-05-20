output "proxy_provider_id" {
  description = "Authentik proxy provider ID"
  # value       = 1
  value = var.auth_type == "proxy" ? authentik_provider_proxy.app[0].id : null
}
