output "proxy_provider_id" {
  description = "Authentik proxy provider ID"
  value       = var.auth_type == "proxy" ? authentik_provider_proxy.app[0].id : null
}

output "oauth_client_secret" {
  description = "OAuth Client Secret"
  value       = var.auth_type == "oauth2" ? authentik_provider_oauth2.app[0].client_secret : null
}
