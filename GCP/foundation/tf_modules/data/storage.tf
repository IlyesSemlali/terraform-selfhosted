###########
# Storage #
###########
resource "google_compute_disk" "rwo" {
  for_each = {
    for disk in var.rwo_storage :
    "${disk.application}${disk.component != "" ? "-${disk.component}" : ""}" => disk
  }

  name = each.key
  type = "pd-standard"
  zone = var.zone
  size = each.value.size
}
