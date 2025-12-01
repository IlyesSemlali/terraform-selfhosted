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


resource "kubernetes_manifest" "authentik_ingress" {
  manifest = yamldecode(templatefile("${path.module}/manifests/authentik-ingress.yaml.tftpl", {
    namespace = "system",
    domain    = var.domain
  }))
}
