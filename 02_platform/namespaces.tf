resource "kubernetes_namespace" "application" {
  for_each = local.applications

  metadata {
    name = each.key
  }

  depends_on = [module.kubernetes]
}
