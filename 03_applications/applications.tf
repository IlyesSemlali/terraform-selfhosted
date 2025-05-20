locals {
  system_components = data.terraform_remote_state.foundation.outputs.system_components
  applications      = data.terraform_remote_state.foundation.outputs.applications
}

module "helm_releases" {
  source   = "../tf_modules/agnostic/helm_release/"
  for_each = local.applications

  name   = lower(each.value.metadata.name)
  domain = var.domain

  helm_values        = each.value.helm_release.values
  helm_repository    = each.value.helm_release.repository
  helm_chart         = each.value.helm_release.chart
  helm_chart_version = each.value.helm_release.version

  # Setting empty strings, as templates can't handle null values
  oauth_scopes        = try(each.value.authentication.oauth_scopes, "")
  oauth_client_secret = try(module.authentications[each.key].oauth_client_secret, "")
}
