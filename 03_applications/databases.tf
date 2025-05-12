locals {
  db_list = flatten(
    [
      for app, configs in local.applications : [
        for config_key, pg_databases in configs : [
          for db, db_config in pg_databases :
          {
            name                  = db_config.name
            size                  = db_config.size
            extensions            = db_config.extensions
            application_namespace = app
          }
        ] if config_key == "pg_databases"
      ]
    ]
  )
}

module "databases" {
  source   = "../tf_modules/gcp/postgresql-database"
  for_each = { for db in local.db_list : db.name => db }

  name                  = each.value.name
  application_namespace = each.value.application_namespace
  extensions            = each.value.extensions
  size                  = each.value.size

  depends_on = [kubernetes_namespace.application]
}
