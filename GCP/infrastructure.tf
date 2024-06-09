module "network" {
  source = "./tf_modules/network"
  domain = var.domain
}

module "kubernetes" {
  source = "./tf_modules/kubernetes"
  count  = var.off ? 0 : 1

  zone            = var.zone
  cluster_name    = "self-hosted"
  node_type       = var.kubernetes_node_type
  min_nodes_count = var.kubernetes_min_nodes
  max_nodes_count = var.kubernetes_max_nodes

}

module "flux" {
  source            = "./tf_modules/flux"
  github_owner      = var.github_owner
  github_repository = var.flux_repository
}
