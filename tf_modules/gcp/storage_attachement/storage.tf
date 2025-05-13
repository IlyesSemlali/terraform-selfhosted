###########
# Storage #
###########

locals {
  storage_name = "${var.application_name}-${var.storage_name}"
}

resource "kubernetes_persistent_volume" "rwo" {
  metadata {
    name = local.storage_name
  }

  spec {
    capacity = {
      storage = "${var.size}Gi"
    }

    access_modes = [var.access_mode]

    persistent_volume_source {
      gce_persistent_disk {
        pd_name = local.storage_name
        fs_type = "ext4"
      }
    }

    storage_class_name               = "tf-managed-rwo"
    persistent_volume_reclaim_policy = "Retain"
  }
}

resource "kubernetes_persistent_volume_claim" "rwo" {
  metadata {
    name      = local.storage_name
    namespace = var.application_namespace
  }

  spec {
    access_modes = [var.access_mode]

    resources {
      requests = {
        storage = "${var.size}Gi"
      }
    }

    storage_class_name = "tf-managed-rwo"
    volume_name        = local.storage_name
  }
}

