resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = var.kubernetes_namespace

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  values = [file("${path.module}/values/traefik.yaml")]
}

