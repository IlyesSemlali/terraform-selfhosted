module "provisionning" {
  source  = "./tf_modules/kubernetes_provisionning"
  project = var.project

  depends_on = [
    module.flux
  ]
}
