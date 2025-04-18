module "preprovisioning" {
  source = "./tf_modules/kubernetes_preprovisionning"

  authentik_bootstrap_email    = var.owner_email
  authentik_bootstrap_password = var.authentik_bootstrap_password
  authentik_bootstrap_token    = var.authentik_bootstrap_token
}

# TODO: remove extra n in 'provisionnings'
module "provisionning" {
  source = "./tf_modules/kubernetes_provisionning"

  project = var.project
  domain  = var.domain

  authentik_bootstrap_token = var.authentik_bootstrap_token

  databases = [
    # the vector extension isn't the one
    # supported by immich so it'll run in a container for now
    # {
    #   application = "immich"
    #   component   = "library"
    #   password    = "immich_pass"
    #   extensions  = ["vector"]
    # }
  ]

  depends_on = [
    module.flux
  ]
}
