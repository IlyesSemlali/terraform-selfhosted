#####################
## Preprovisioning ##
#####################

module "system" {
  source = "../tf_modules/agnostic/system_components"

  project = var.project
  domain  = var.domain

  authentik_bootstrap_email    = var.owner_email
  authentik_bootstrap_password = var.authentik_bootstrap_password
  authentik_bootstrap_token    = var.authentik_bootstrap_token
}

module "traefik_storage" {
  source = "../tf_modules/gcp/storage_attachement"

  application_name      = "traefik"
  application_namespace = "system"
  storage_name          = "certificates"
  size                  = 1

  depends_on = [kubernetes_namespace.application]
}
