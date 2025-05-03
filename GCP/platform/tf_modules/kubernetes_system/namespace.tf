########################
## "system" Namespace ##
########################

resource "kubernetes_namespace" "system" {
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata {
    name = "system"
  }
}

