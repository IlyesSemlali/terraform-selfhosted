locals {
  oauth_issuer_url    = "https://auth.${var.domain}/application/o/${var.name}/"
  oauth_client_id     = var.name
  oauth_client_secret = var.oauth_client_secret
  oauth_scopes        = var.oauth_scopes
}


resource "helm_release" "application" {
  name      = var.name
  namespace = var.namespace

  repository = var.helm_repository
  chart      = var.helm_chart

  version = var.helm_chart_version
  values = [templatestring(var.helm_values, {
    oauth_issuer_url    = local.oauth_issuer_url
    oauth_client_id     = local.oauth_client_id
    oauth_client_secret = local.oauth_client_secret
    oauth_scopes        = local.oauth_scopes

  })]

  timeout = 360
}

resource "kubernetes_manifest" "https_redirect_middleware" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "redirect-to-https"
      "namespace" = var.namespace
    }
    "spec" = {
      "redirectScheme" = {
        "permanent" = "true"
        "scheme"    = "https"
      }
    }
  }
}


resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1",
    "kind"       = "IngressRoute",
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
      "annotations" = {
        "external-dns.alpha.kubernetes.io/target" = "ingress.${var.domain}"
      }
    }
    "spec" = {
      "entryPoints" = [
        "web",
        "websecure"
      ],
      "routes" = [{
        "kind"  = "Rule",
        "match" = "Host(`${var.name}.${var.domain}`)",
        "middlewares" = [{
          "name" = "redirect-to-https",
        }]
        "services" = [{
          "kind" = "Service",
          "name" = var.service_name,
          "port" = var.service_port,
        }]
      }]
      "tls" = {
        "certResolver" = "letsencrypt"
      }
    }
  }
}
