locals {
  storage_name = "${var.application_name}-${var.storage_name}"
}

resource "google_compute_disk" "rwo" {
  name = local.storage_name
  type = "pd-standard"
  zone = var.zone
  size = var.size
}
