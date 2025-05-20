locals {
  oauth_issuer_url    = "https://auth.${var.domain}/application/o/${var.name}/"
  oauth_client_id     = var.name
  oauth_client_secret = var.oauth_client_secret
  oauth_scopes        = var.oauth_scopes
}


resource "helm_release" "application" {
  name      = var.name
  namespace = var.name

  repository = var.helm_repository
  chart      = var.helm_chart

  version = var.helm_chart_version
  values = [templatestring(var.helm_values, {
    oauth_issuer_url    = local.oauth_issuer_url
    oauth_client_id     = local.oauth_client_id
    oauth_client_secret = local.oauth_client_secret
    oauth_scopes        = local.oauth_scopes

  })]
}
