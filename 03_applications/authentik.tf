data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_certificate_key_pair" "generated" {
  name = "authentik Self-signed Certificate"
}

# TODO: import authentik integration to avoid duplicate:
# https://developer.hashicorp.com/terraform/language/import
resource "authentik_service_connection_kubernetes" "local" {
  name  = "Kubernetes"
  local = true
}

resource "authentik_outpost" "forward_auth_outpost" {
  name               = "forwardAuth"
  protocol_providers = [for app in module.applications : app.proxy_provider_id if app.proxy_provider_id != null]

  config = jsonencode({
    authentik_host          = format("https://auth.${var.domain}")
    authentik_host_insecure = true # TODO: prod: Set this to false
  })

  service_connection = authentik_service_connection_kubernetes.local.id
}

