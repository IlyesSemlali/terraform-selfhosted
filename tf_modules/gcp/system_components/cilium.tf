resource "helm_release" "cilium" {
  name      = "cilium"
  namespace = "kube-system"

  repository = "https://cilium.github.io/charts"
  chart      = "cilium"

  values = [templatefile("${path.module}/values/cilium.yaml", {
    native_routing_cidr = var.native_routing_cidr
    cluster_name        = var.cluster_name
  })]
}

