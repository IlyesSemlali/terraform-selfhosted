locals {
  system_components = data.terraform_remote_state.foundation.outputs.system_components
  applications      = data.terraform_remote_state.foundation.outputs.applications
}

module "applications" {
  source   = "../tf_modules/agnostic/application/"
  for_each = merge(local.system_components, local.applications)

  domain = var.domain

  helm_values        = each.value.helm_release.values
  helm_repository    = each.value.helm_release.repository
  helm_chart         = each.value.helm_release.chart
  helm_chart_version = each.value.helm_release.version

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
