resource "kubernetes_storage_class" "rwo" {
  metadata {
    name = "tf-managed-rwo"
  }
  storage_provisioner    = "kubernetes.io/no-provisioner"
  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
}
