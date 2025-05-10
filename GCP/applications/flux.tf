module "flux" {
  source            = "./tf_modules/flux"
  github_owner      = var.github_owner
  github_repository = var.flux_repository
}
