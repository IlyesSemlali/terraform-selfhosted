data "authentik_property_mapping_provider_scope" "openid" {
  managed = "goauthentik.io/providers/oauth2/scope-openid"
}

data "authentik_property_mapping_provider_scope" "email" {
  managed = "goauthentik.io/providers/oauth2/scope-email"
}

data "authentik_property_mapping_provider_scope" "profile" {
  managed = "goauthentik.io/providers/oauth2/scope-profile"
}

locals {
  scopes = {
    openid  = data.authentik_property_mapping_provider_scope.openid.id,
    email   = data.authentik_property_mapping_provider_scope.email.id,
    profile = data.authentik_property_mapping_provider_scope.profile.id,
  }
}

resource "authentik_provider_proxy" "app" {
  count = var.auth_type == "proxy" ? 1 : 0

  name          = lower(var.name)
  external_host = "https://auth.${var.domain}"

  mode                  = "forward_domain"
  cookie_domain         = var.domain
  access_token_validity = "hours=24"

  authorization_flow = var.authentik_authorization_flow
  invalidation_flow  = var.authentik_invalidation_flow
}

resource "authentik_provider_oauth2" "app" {
  count = var.auth_type == "oauth2" ? 1 : 0

  name        = lower(var.name)
  client_id   = lower(var.name)
  client_type = "confidential"
  signing_key = var.oauth_signing_key

  allowed_redirect_uris = [
    for redirect_uri in var.oauth_redirect_uris : {
      matching_mode = "regex",
      url           = redirect_uri,
    }
  ]

  authorization_flow = var.authentik_authorization_flow
  invalidation_flow  = var.authentik_invalidation_flow

  property_mappings = [for scope in split(" ", var.oauth_scopes) : local.scopes[scope]]
}

resource "authentik_application" "proxy" {
  count = var.auth_type == "proxy" ? 1 : 0

  name              = var.name
  protocol_provider = authentik_provider_proxy.app[count.index].id

  slug             = lower(var.name)
  meta_launch_url  = "https://${lower(var.name)}.${var.domain}/"
  meta_description = var.description
  group            = var.group
}

resource "authentik_application" "oauth2" {
  count = var.auth_type == "oauth2" ? 1 : 0

  name              = var.name
  protocol_provider = authentik_provider_oauth2.app[count.index].id

  slug             = lower(var.name)
  meta_launch_url  = "https://${lower(var.name)}.${var.domain}/"
  meta_description = var.description
  group            = var.group
}
