locals {
  issuers = {
    staging = "https://acme-staging-v02.api.letsencrypt.org/directory"
    prod    = "https://acme-v02.api.letsencrypt.org/directory"
  }
}


resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = var.kubernetes_namespace


  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [templatefile("${path.module}/values/cert-manager.yaml", {
    domain              = var.cluster_name
    issuers             = local.issuers
    project_owner_email = var.project_owner_email
  })]
}
