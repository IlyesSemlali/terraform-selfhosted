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

# TODO: Use this mechanism to fix this error:
#
# │ Error: Error, failed to deleteuser immich in instance postgresql: googleapi: Error 400: Invalid request: failed to delete user immich: . role "immich" cannot be dropped because some objects depend on it Details: 390 objects in database immich., invalid

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
