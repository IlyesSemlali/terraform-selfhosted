output "endpoint" {
  value = google_container_cluster.gke-cluster.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.gke-cluster.master_auth[0].cluster_ca_certificate
}
