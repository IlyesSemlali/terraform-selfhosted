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

module "traefik_storage" {
  source = "../tf_modules/gcp/storage_attachement"

  application_name      = "traefik"
  application_namespace = "system"
  storage_name          = "certificates"
  size                  = 1

  depends_on = [kubernetes_namespace.system]
}

module "authentik_database" {
  source = "../tf_modules/gcp/postgresql-database"

  name                  = "authentik"
  application_namespace = "system"

  depends_on = [kubernetes_namespace.system]
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

