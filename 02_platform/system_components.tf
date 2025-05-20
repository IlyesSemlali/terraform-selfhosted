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

  depends_on = [module.kubernetes]
}

module "traefik_storage" {
  source = "../tf_modules/gcp/storage_attachement"

  application_name      = "traefik"
  application_namespace = kubernetes_namespace.system.metadata[0].name
  storage_name          = "certificates"
  size                  = 1

  depends_on = [kubernetes_namespace.system]
}

module "authentik_database" {
  source = "../tf_modules/gcp/postgresql-database"

  name                  = "authentik"
  application_namespace = kubernetes_namespace.system.metadata[0].name

  depends_on = [
    kubernetes_namespace.system,
    time_sleep.wait_for_postgresql
  ]
}

module "system" {
  source = "../tf_modules/agnostic/system_components"

  project = var.project
  domain  = var.domain

  kubernetes_namespace = kubernetes_namespace.system.metadata[0].name

  authentik_bootstrap_email    = var.owner_email
  authentik_bootstrap_password = var.authentik_bootstrap_password
  authentik_bootstrap_token    = var.authentik_bootstrap_token

  authentik_pg_host     = module.authentik_database.pg_host
  authentik_pg_user     = module.authentik_database.pg_user
  authentik_pg_password = module.authentik_database.pg_password

  depends_on = [
    module.traefik_storage,
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
