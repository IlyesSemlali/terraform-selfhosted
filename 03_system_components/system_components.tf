locals {
  system_components = data.terraform_remote_state.foundation.outputs.system_components
}

resource "kubernetes_namespace" "system" {
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata {
    name = "system"
  }
}

module "authentik_database" {
  source = "../tf_modules/gcp/postgresql-database"

  name                  = "authentik"
  application_namespace = kubernetes_namespace.system.metadata[0].name

  depends_on = [
    kubernetes_namespace.system,
  ]
}

module "system" {
  source = "../tf_modules/gcp/system_components"

  project             = var.project
  cluster_name        = var.kubernetes_cluster_name
  native_routing_cidr = data.terraform_remote_state.platform.outputs.kubernetes_native_routing_cidr
  domain              = var.domain

  kubernetes_namespace = kubernetes_namespace.system.metadata[0].name

  project_owner_email          = var.project_owner_email
  authentik_bootstrap_password = var.authentik_bootstrap_password
  authentik_bootstrap_token    = var.authentik_bootstrap_token

  authentik_pg_host     = module.authentik_database.pg_host
  authentik_pg_user     = module.authentik_database.pg_user
  authentik_pg_password = module.authentik_database.pg_password

  depends_on = [
    module.authentik_database
  ]
}

module "helm_releases" {
  source   = "../tf_modules/agnostic/helm_release/"
  for_each = { for component, config in local.system_components : component => config if length(config.helm_release) != 0 }

  name      = lower(each.value.metadata.name)
  namespace = try(each.value.helm_release.namespace, kubernetes_namespace.system.metadata[0].name)
  domain    = var.domain

  helm_values        = each.value.helm_release.values
  helm_repository    = each.value.helm_release.repository
  helm_chart         = each.value.helm_release.chart
  helm_chart_version = each.value.helm_release.version

  # No OAuth for System Components, if needed deploy them
  # as regular applications
}
