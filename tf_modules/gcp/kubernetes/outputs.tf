output "endpoint" {
  value = google_container_cluster.gke.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
}
