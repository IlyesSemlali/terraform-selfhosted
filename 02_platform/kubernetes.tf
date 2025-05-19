module "kubernetes" {
  source = "../tf_modules/gcp/kubernetes"

  region = var.region
  zone   = var.zone

  cluster_name          = var.kubernetes_cluster_name
  deletion_protection   = var.deletion_protection
  permanent_nodes_type  = var.kubernetes_permanent_nodes_type
  extra_nodes_type      = var.kubernetes_extra_nodes_type
  min_extra_nodes_count = var.kubernetes_min_extra_nodes
  max_extra_nodes_count = var.kubernetes_max_extra_nodes
}
