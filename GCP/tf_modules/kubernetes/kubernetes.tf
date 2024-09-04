resource "google_service_account" "gke_sa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "permanent" {
  name     = "${var.cluster_name}-permanent-node-pool"
  location = var.region
  cluster  = google_container_cluster.gke.name

  node_config {
    preemptible  = true
    machine_type = var.permanent_nodes_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

  }

  autoscaling {
    total_min_node_count = var.permanent_nodes_count
    total_max_node_count = var.permanent_nodes_count
  }
}

resource "google_container_node_pool" "extra" {
  count = var.extra_nodes_type == null ? 0 : 1
  name  = "${var.cluster_name}-extra-node-pool"

  location = var.region
  cluster  = google_container_cluster.gke.name

  node_config {
    preemptible  = true
    machine_type = var.extra_nodes_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

  }

  autoscaling {
    total_min_node_count = var.min_extra_nodes_count
    total_max_node_count = var.max_extra_nodes_count
  }
}
