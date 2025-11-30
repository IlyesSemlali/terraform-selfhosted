#################
## HelmRelease ##
#################

resource "random_password" "authentik_secret_key" {
  length           = 64
  special          = true
  override_special = "!#$%&*-_=+:?"
}

resource "random_password" "postgres_password" {
  length  = 32
  special = true
}

locals {
  # TODO: move this into ./values/authentik.yaml.tftpl
  authentik_values = {
    authentik = {

      bootstrap_password = var.authentik_bootstrap_password
      bootstrap_email    = var.project_owner_email
      bootstrap_token    = var.authentik_bootstrap_token

      secret_key = random_password.authentik_secret_key.result
      error_reporting = {
        enabled = true
      }
      postgresql = {
        host     = var.authentik_pg_host
        user     = var.authentik_pg_user
        password = var.authentik_pg_password
      }
    }

    server = {
      readinessProbe = {
        failureThreshold    = 3
        initialDelaySeconds = 10
        periodSeconds       = 5
        successThreshold    = 3
      }

      env = [
        {
          name  = "AUTHENTIK_OUTPOSTS__DISABLE_EMBEDDED_OUTPOST"
          value = "true"
        }
      ]
    }

    postgresql = {
      enabled = false
    }

    redis = {
      enabled = true
    }
  }
}

resource "helm_release" "authentik" {
  name      = "authentik"
  namespace = var.kubernetes_namespace

  repository = "https://charts.goauthentik.io"
  chart      = "authentik"

  values = [yamlencode(local.authentik_values)]
}


# TODO: move this into ./manifests/authentik-ingress.yaml.tftpl
resource "kubernetes_manifest" "authentik_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "name"      = "authentik"
      "namespace" = "system"
      "annotations" = {
        "external-dns.alpha.kubernetes.io/target"          = "ingress.${var.domain}"
        "cert-manager.io/cluster-issuer"                   = "letsencrypt-staging"
        "traefik.ingress.kubernetes.io/router.middlewares" = "system-redirect-to-https@kubernetescrd"
        "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
      }
      "labels" = {
        "app.kubernetes.io/instance"   = "authentik-system"
        "app.kubernetes.io/managed-by" = "Flux"
        "app.kubernetes.io/name"       = "authentik"
      }
    }

    "spec" = {
      "ingressClassName" = "traefik"
      "rules" = [{
        "host" = "auth.${var.domain}"
        "http" = {
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
            "backend" = {
              "service" = {
                "name" = "authentik-server"
                "port" = {
                  "number" = 80
                }
              }
            }
          }]
        }
      }]

      "tls" = [{
        "hosts"      = ["auth.${var.domain}"]
        "secretName" = "authentik-tls-secret"
      }]
    }
  }
}
