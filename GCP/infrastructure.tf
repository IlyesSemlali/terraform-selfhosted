module "network" {
  source = "./tf_modules/network"
  domain = var.domain

  kubernetes_cluster_name = var.kubernetes_cluster_name
}

module "kubernetes" {
  source = "./tf_modules/kubernetes"
  count  = var.off ? 0 : 1

  region = var.region
  zone   = var.zone

  cluster_name          = var.kubernetes_cluster_name
  lb_ip_address         = module.network.lb_ip_address
  deletion_protection   = var.deletion_protection
  permanent_nodes_type  = var.kubernetes_permanent_nodes_type
  extra_nodes_type      = var.kubernetes_extra_nodes_type
  min_extra_nodes_count = var.kubernetes_min_extra_nodes
  max_extra_nodes_count = var.kubernetes_max_extra_nodes
}

module "flux" {
  source            = "./tf_modules/flux"
  github_owner      = var.github_owner
  github_repository = var.flux_repository
}
