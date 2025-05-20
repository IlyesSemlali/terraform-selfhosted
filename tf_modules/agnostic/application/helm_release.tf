resource "helm_release" "application" {
  count = var.auth_type == "oauth2" ? 1 : 0

  name      = lower(var.name)
  namespace = lower(var.name)

  repository = var.helm_repository
  chart      = var.helm_chart

  version = var.helm_chart_version
  values = [templatestring(var.helm_values, {
    oauth_issuer_url    = "https://auth.${var.domain}/application/o/${lower(var.name)}/",
    oauth_client_id     = authentik_provider_oauth2.app[count.index].client_id
    oauth_client_secret = authentik_provider_oauth2.app[count.index].client_secret
    oauth_scopes        = var.oauth_scopes
  })]

  # depends_on = [kubernetes_secret.external_dns_sa]
}
