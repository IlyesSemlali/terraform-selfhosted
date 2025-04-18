locals {
  preprovisionned_namespaces = [
    "system"
  ]
}

resource "kubernetes_namespace" "namespace" {
  for_each = toset(local.preprovisionned_namespaces)

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata {
    name = each.key
  }
}
