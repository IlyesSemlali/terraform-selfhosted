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

      bootstrap_password = var.bootstrap_password
      bootstrap_email    = var.bootstrap_email
      bootstrap_token    = var.bootstrap_token

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

####################################
## Common Authentik Configuration ##
####################################

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

resource "authentik_service_connection_kubernetes" "local" {
  name  = "Kubernetes"
  local = true
}

resource "authentik_outpost" "forward_auth_outpost" {
  name = "forwardAuth"
  protocol_providers = [
    authentik_provider_proxy.traefik.id
  ]

  config = jsonencode({
    authentik_host          = format("https://auth.${var.domain}")
    authentik_host_insecure = true
  })

  service_connection = authentik_service_connection_kubernetes.local.id
}

resource "authentik_provider_proxy" "traefik" {
  name          = "Traefik forwardAuth"
  external_host = "https://auth.${var.domain}"

  mode                  = "forward_domain"
  cookie_domain         = var.domain
  access_token_validity = "hours=24"

  authorization_flow = data.authentik_flow.default_authorization_flow.id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow.id
}

##################
## Applications ##
##################

resource "authentik_application" "traefik" {
  name              = "Traefik Dashboard"
  slug              = "traefik"
  protocol_provider = authentik_provider_proxy.traefik.id
  meta_launch_url   = "https://traefik.${var.domain}/"
  meta_description  = "Traefik Ingress Controller dashboard"
  group             = "Admin Panel"
}
