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
## Wait for authentik to be ready ##
####################################

data "http" "authentik_health" {
  url = "https://auth.bobr.cloud/api/v3/core/system/health/"
  request_headers = {
    Authorization = "Bearer ${var.bootstrap_token}"
    Accept        = "application/json"
  }

  # Wait up to 5 minutes for the API to respond with 200
  retry {
    attempts     = 20
    min_delay_ms = 5000
  }
}

resource "null_resource" "wait_for_authentik" {
  triggers = {
    health_status = data.http.authentik_health.status_code
  }
}

####################################
## Common Authentik Configuration ##
####################################

# TODO: import authentik integration to avoid duplicate:
# https://developer.hashicorp.com/terraform/language/import

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"

  depends_on = [null_resource.wait_for_authentik]
}

data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"

  depends_on = [null_resource.wait_for_authentik]
}

resource "authentik_service_connection_kubernetes" "local" {
  name  = "Kubernetes"
  local = true

  depends_on = [null_resource.wait_for_authentik]
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
