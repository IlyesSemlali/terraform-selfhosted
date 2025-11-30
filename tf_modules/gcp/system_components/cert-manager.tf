resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = var.kubernetes_namespace

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [templatefile("${path.module}/values/cert-manager.yaml", {
    domain = var.cluster_name
  })]
}

locals {
  issuer_configs = {
    staging = {
      name   = "letsencrypt-staging"
      server = "https://acme-staging-v02.api.letsencrypt.org/directory"
      secret = "letsencrypt-staging-key"
    },
    prod = {
      name   = "letsencrypt-prod"
      server = "https://acme-v02.api.letsencrypt.org/directory"
      secret = "letsencrypt-prod-key"
    }
  }
}

resource "kubernetes_manifest" "cert_manager_cluster_issuer" {
  for_each = local.issuer_configs

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = each.value.name
    }

    spec = {
      acme = {
        server = each.value.server
        email  = var.project_owner_email
        privateKeySecretRef = {
          name = each.value.secret
        }

        solvers = [
          {
            http01 = {
              ingress = {
                class = "traefik"
              }
            }
          }
        ]
      }
    }
  }
}
