locals {
  db_list = flatten(
    [
      for app, configs in local.applications : [
        for config_key, pg_databases in configs : [
          for db, db_config in pg_databases :
          {
            name                  = db_config.name
            application_namespace = app
          }
        ] if config_key == "pg_databases"
      ]
    ]
  )
}

module "postgresql" {
  source = "../tf_modules/gcp/postgresql-instance"

  region = var.region
}

resource "time_sleep" "wait_for_postgresql" {
  depends_on = [module.postgresql]

  destroy_duration = "90s"
}

module "databases" {
  source   = "../tf_modules/gcp/postgresql-database"
  for_each = { for db in local.db_list : db.name => db }

  name                  = each.value.name
  application_namespace = each.value.application_namespace

  depends_on = [
    kubernetes_namespace.application,
    time_sleep.wait_for_postgresql
  ]
}
