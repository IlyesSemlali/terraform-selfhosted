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

  values = [file("${path.module}/values/cert-manager.yaml")]
}

resource "kubernetes_manifest" "letsencrypt_staging" {
  for_each = local.issuers

  depends_on = [helm_release.cert_manager]

  manifest = yamldecode(templatefile("${path.module}/values/lets-encrypt.yaml.tpl", {
    domain              = var.cluster_name
    env                 = each.key
    server              = each.value
    project_owner_email = var.project_owner_email
  }))
}
