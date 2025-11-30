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


resource "kubernetes_manifest" "ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace
      "annotations" = {
        "external-dns.alpha.kubernetes.io/target"          = "ingress.${var.domain}"
        "cert-manager.io/cluster-issuer"                   = "letsencrypt-staging"
        "traefik.ingress.kubernetes.io/router.middlewares" = "${var.namespace}-redirect-to-https@kubernetescrd"
        "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
      }
    }

    "spec" = {
      "ingressClassName" = "traefik"
      "rules" = [{
        "host" = "${var.name}.${var.domain}"
        "http" = {
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
            "backend" = {
              "service" = {
                "name" = var.service_name
                "port" = {
                  "number" = var.service_port
                }
              }
            }
          }]
        }
      }]

      "tls" = [{
        "hosts"      = ["${var.name}.${var.domain}"]
        "secretName" = "${var.name}-tls-secret"
      }]
    }
  }
}

# TODO: re-enable this, also create one for the authentik outpost somewhere else
# resource "kubernetes_manifest" "immich_certificate" {
#   manifest = {
#     "apiVersion" = "cert-manager.io/v1",
#     "kind"       = "Certificate",
#     "metadata" = {
#       "name"      = "${var.name}-certificate"
#       "namespace" = var.namespace
#     }
#     "spec" = {
#       "secretName" = "${var.name}-tls-secret",
#
#       "dnsNames" = [
#         "${var.name}.${var.domain}"
#       ],
#
#       "issuerRef" = {
#         "cert-manager.io/cluster-issuer" = "letsencrypt-staging" # TODO: make this conditional to dev stage
#         "kind"                           = "ClusterIssuer"
#       }
#     }
#   }
# }
