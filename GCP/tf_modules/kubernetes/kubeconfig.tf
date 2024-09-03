resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "gcloud container clusters get-credentials ${google_container_cluster.gke-cluster.name} --region ${var.region} --project ${google_container_cluster.gke-cluster.project}"
  }
}

resource "null_resource" "context_delete" {
  depends_on = [null_resource.kubectl]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "kubectl config delete-context ${var.cluster_name} || true"
  }
}

resource "null_resource" "context_rename" {
  depends_on = [null_resource.context_delete]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "kubectl config rename-context gke_${google_container_cluster.gke-cluster.project}_${var.zone}_${var.cluster_name} ${var.cluster_name} || true"
  }
}
