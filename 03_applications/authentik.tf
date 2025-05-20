locals {
  authentications = {
    for app, config in merge(local.system_components, local.applications) : app => config if length(config.authentication) != 0
  }
}

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_certificate_key_pair" "generated" {
  name = "authentik Self-signed Certificate"
}

module "authentications" {
  source   = "../tf_modules/agnostic/authentication/"
  for_each = local.authentications

  domain = var.domain

  name        = each.value.metadata.name
  description = each.value.metadata.description
  group       = each.value.metadata.group
  auth_type   = each.value.authentication.type

  oauth_redirect_uris = each.value.authentication.type == "oauth2" ? split(";", each.value.authentication.oauth_redirect_uris) : null
  oauth_scopes        = each.value.authentication.type == "oauth2" ? each.value.authentication.oauth_scopes : null
  oauth_signing_key   = data.authentik_certificate_key_pair.generated.id

  authentik_invalidation_flow  = data.authentik_flow.default_invalidation_flow.id
  authentik_authorization_flow = data.authentik_flow.default_authorization_flow.id
}

# TODO: import authentik integration to avoid duplicate:
# https://developer.hashicorp.com/terraform/language/import
resource "authentik_service_connection_kubernetes" "local" {
  name  = "Kubernetes"
  local = true
}

resource "authentik_outpost" "forward_auth_outpost" {
  name               = "forwardAuth"
  protocol_providers = [for app in module.authentications : app.proxy_provider_id if app.proxy_provider_id != null]

  config = jsonencode({
    authentik_host          = format("https://auth.${var.domain}")
    authentik_host_insecure = true # TODO: prod: Set this to false
  })

  service_connection = authentik_service_connection_kubernetes.local.id
}

