resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.gke-cluster.name} --zone ${var.zone} --project ${google_container_cluster.gke-cluster.project}"
  }
}

resource "null_resource" "context_delete" {
  provisioner "local-exec" {
    command = "kubectl config delete-context ${var.cluster_name}"
  }
}

resource "null_resource" "context_rename" {
  provisioner "local-exec" {
    command = "kubectl config rename-context gke_${google_container_cluster.gke-cluster.project}_${var.zone}_${var.cluster_name} ${var.cluster_name}"
  }
}
