locals {
  system_components = data.terraform_remote_state.foundation.outputs.system_components
  applications      = data.terraform_remote_state.foundation.outputs.applications
}

module "applications" {
  source = "../tf_modules/agnostic/application/"

  system_components = local.system_components
  applications      = local.applications
  domain            = var.domain
}
