module "network" {
  source = "./tf_modules/network"
  domain = var.domain
}

module "kubernetes" {
  source = "./tf_modules/kubernetes"
  count  = var.off ? 0 : 1

  zone                  = var.zone
  cluster_name          = "self-hosted"
  permanent_node_type   = var.kubernetes_permanent_node_type
  extra_node_type       = var.kubernetes_extra_node_type
  min_extra_nodes_count = var.kubernetes_min_extra_nodes
  max_extra_nodes_count = var.kubernetes_max_extra_nodes

}

module "flux" {
  source            = "./tf_modules/flux"
  github_owner      = var.github_owner
  github_repository = var.flux_repository
}
