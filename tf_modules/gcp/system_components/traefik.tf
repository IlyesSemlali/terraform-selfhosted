resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = var.kubernetes_namespace

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  values = [templatefile("${path.module}/values/traefik.yaml", { domain = var.domain })]
}

