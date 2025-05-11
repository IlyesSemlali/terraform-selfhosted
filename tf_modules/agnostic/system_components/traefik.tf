resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = kubernetes_namespace.system.metadata[0].name

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  values = [templatefile("${path.module}/values/traefik.yaml", { domain = var.domain })]

  depends_on = [kubernetes_namespace.system]
}

