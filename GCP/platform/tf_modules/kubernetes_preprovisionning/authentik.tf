# TODO: Find a better way to wait for authentik to be ready:
# Authentik Values -> Flux -> Authenik resources


resource "random_password" "authentik_secret_key" {
  length  = 64
  special = true
}

resource "random_password" "postgres_password" {
  length  = 32
  special = true
}

locals {
  authentik_values = {
    authentik = {

      bootstrap_password = var.authentik_bootstrap_password
      bootstrap_email    = var.authentik_bootstrap_email
      bootstrap_token    = var.authentik_bootstrap_token

      secret_key = random_password.authentik_secret_key.result
      error_reporting = {
        enabled = true
      }
      postgresql = {
        password = random_password.postgres_password.result
      }
    }

    postgresql = {
      enabled = true
      auth = {
        password = random_password.postgres_password.result
      }
    }

    redis = {
      enabled = true
    }
  }
}

resource "kubernetes_secret" "authentik_values" {
  metadata {
    name      = "authentik-values"
    namespace = "system"
  }

  type = "Opaque"

  data = {
    "values.yaml" = yamlencode(local.authentik_values)
  }
}
