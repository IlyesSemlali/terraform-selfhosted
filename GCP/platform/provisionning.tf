module "provisionning" {
  source = "./tf_modules/kubernetes_provisionning"

  project = var.project
  domain  = var.domain

  bootstrap_email    = var.owner_email
  bootstrap_password = var.authentik_bootstrap_password
  bootstrap_token    = var.authentik_bootstrap_token

  databases = [
    {
      application = "immich"
      component   = "library"
      password    = "immich_pass"
      extensions  = ["vector"]
    }
  ]

  depends_on = [
    module.flux
  ]
}
