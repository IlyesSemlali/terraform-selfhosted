locals {
  helm_releases = {
    # TODO: reenable merge of both app sources:
    # for app, config in merge(var.applications, var.system_components) : app => config
    for app, config in var.applications : app => config.helm_release
  }
}

resource "helm_release" "application" {
  for_each = local.helm_releases

  name      = each.key
  namespace = each.key

  repository = each.value.repository
  chart      = each.value.chart

  version = each.value.version
  values = [templatestring(each.value.values, {
    oauth_issuer_url    = "https://auth.${var.domain}/application/o/${each.key}/",
    oauth_client_id     = authentik_provider_oauth2.app[each.key].client_id
    oauth_client_secret = authentik_provider_oauth2.app[each.key].client_secret
    oauth_scopes        = "openid email profile"
  })]

  # depends_on = [kubernetes_secret.external_dns_sa]
}
