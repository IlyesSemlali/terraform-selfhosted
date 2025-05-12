#TODO: move all resources to the right VPC

resource "google_compute_network" "primary_network" {
  name                    = "primary-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary_subnet" {
  name          = "primary-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.primary_network.id
}

output "self_link" {
  value = google_compute_network.primary_network.self_link
}

output "name" {
  value = google_compute_network.primary_network.name
}
