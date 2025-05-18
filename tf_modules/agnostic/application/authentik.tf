locals {
  authentications = {
    for app, config in merge(var.applications, var.system_components) : app => config.authentication
  }

  proxy_auths = {
    for app, auth in local.authentications : app => auth if auth.type == "proxy"
  }

  oauth2_auths = {
    for app, auth in local.authentications : app => auth if auth.type == "oauth2"
  }
}

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

# TODO: import authentik integration to avoid duplicate:
# https://developer.hashicorp.com/terraform/language/import
resource "authentik_service_connection_kubernetes" "local" {
  name  = "Kubernetes"
  local = true
}

resource "authentik_outpost" "forward_auth_outpost" {
  name = "forwardAuth"
  protocol_providers = [
    for app, auth_config in local.proxy_auths : authentik_provider_proxy.app[app].id
  ]

  config = jsonencode({
    authentik_host          = format("https://auth.${var.domain}")
    authentik_host_insecure = true # TODO: prod: Set this to false
  })

  service_connection = authentik_service_connection_kubernetes.local.id
}

resource "authentik_provider_proxy" "app" {
  for_each = local.proxy_auths

  name          = "${each.value.name} forwardAuth"
  external_host = "https://auth.${var.domain}"

  mode                  = "forward_domain"
  cookie_domain         = var.domain
  access_token_validity = "hours=24"

  authorization_flow = data.authentik_flow.default_authorization_flow.id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow.id
}

resource "authentik_provider_oauth2" "app" {
  for_each = local.oauth2_auths

  name        = each.value.name
  client_id   = each.key
  client_type = "confidential"
  allowed_redirect_uris = [
    for redirect_uri in split(";", each.value.redirect_uris) : {
      matching_mode = "strict",
      url           = redirect_uri,
    }
  ]
  authorization_flow = data.authentik_flow.default_authorization_flow.id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow.id
}

resource "authentik_application" "proxy" {
  for_each = local.proxy_auths

  protocol_provider = authentik_provider_proxy.app[each.key].id
  name              = each.value.name
  slug              = each.key
  meta_launch_url   = "https://${each.key}.${var.domain}/"
  meta_description  = each.value.description
  group             = each.value.group
}

resource "authentik_application" "oauth2" {
  for_each = local.oauth2_auths

  protocol_provider = authentik_provider_oauth2.app[each.key].id
  name              = each.value.name
  slug              = each.key
  meta_launch_url   = "https://${each.key}.${var.domain}/"
  meta_description  = each.value.description
  group             = each.value.group
}
