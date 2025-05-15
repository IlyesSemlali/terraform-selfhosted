module "flux" {
  source            = "../tf_modules/agnostic/flux/"
  github_owner      = var.github_owner
  github_repository = var.flux_repository

  depends_on = [module.storage]
}
