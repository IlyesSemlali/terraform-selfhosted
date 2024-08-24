resource "google_service_account" "gke-service-account" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "gke-cluster" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "permanent" {
  name       = "${var.cluster_name}-permanent-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.permanent_node_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke-service-account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

  }

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }
}

resource "google_container_node_pool" "extra" {
  count = var.extra_node_type == null ? 0 : 1
  name  = "${var.cluster_name}-extra-node-pool"

  location   = var.zone
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.extra_node_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke-service-account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

  }

  autoscaling {
    min_node_count = var.min_extra_nodes_count
    max_node_count = var.max_extra_nodes_count
  }
}
