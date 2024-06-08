module "network" {
  source = "./tf_modules/network"
  domain = var.domain
}

module "kubernetes" {
  source = "./tf_modules/kubernetes"

  zone         = var.zone
  cluster_name = "self-hosted"

}
