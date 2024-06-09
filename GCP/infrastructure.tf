module "network" {
  source = "./tf_modules/network"
  domain = var.domain
}

module "kubernetes" {
  source = "./tf_modules/kubernetes"
  count  = var.off ? 0 : 1

  zone         = var.zone
  cluster_name = "self-hosted"

}

module "flux" {
  source            = "./tf_modules/flux"
  github_repository = var.flux_repository
}
