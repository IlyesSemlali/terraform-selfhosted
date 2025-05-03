data "google_sql_database_instance" "cloudsql" {
  name = "postgresql"
}

resource "google_sql_database" "app_db" {
  for_each = {
    for db in var.databases : "${db.application}${db.component != "" ? "_${db.component}" : ""}" => db
  }

  name     = each.key
  instance = data.google_sql_database_instance.cloudsql.name
}

resource "google_sql_user" "db_user" {
  for_each = {
    for db in var.databases : "${db.application}${db.component != "" ? "_${db.component}" : ""}" => db
  }

  name     = each.key
  instance = data.google_sql_database_instance.cloudsql.name
  password = each.value.password
}

resource "kubernetes_secret" "db_infos" {
  for_each = {
    for db in var.databases : "${db.application}${db.component != "" ? "_${db.component}" : ""}" => db
  }

  lifecycle {
    replace_triggered_by = [
      google_sql_user.db_user[each.key]
    ]
  }

  metadata {
    name      = "db-credentials-${replace(each.key, "_", "-")}"
    namespace = each.value.application
  }

  data = {
    username = each.key
    password = each.value.password
    host     = data.google_sql_database_instance.cloudsql.private_ip_address
  }
}

resource "kubernetes_job" "grant_privileges" {
  for_each = {
    for pair in flatten([
      for db in var.databases : [
        for ext in db.extensions : {
          key = "${db.application}${db.component != "" ? "_${db.component}" : ""}_${ext}"
          value = {
            application = db.application
            component   = db.component
            credentials = "${db.application}${db.component != "" ? "_${db.component}" : ""}"
            extension   = ext
          }
        }
      ]
    ]) : pair.key => pair.value
  }

  metadata {
    name      = "enable-db-extension-${replace(each.key, "_", "-")}"
    namespace = each.value.application
  }

  spec {
    template {
      metadata {}
      spec {
        restart_policy = "OnFailure"

        container {
          name  = "psql"
          image = "postgres:15"

          env {
            name = "PGUSER"
            value_from {
              secret_key_ref {
                name = "db-credentials-${replace(each.value.credentials, "_", "-")}"
                key  = "username"
              }
            }
          }

          env {
            name = "PGPASSWORD"
            value_from {
              secret_key_ref {
                name = "db-credentials-${replace(each.value.credentials, "_", "-")}"
                key  = "password"
              }
            }
          }

          env {
            name = "PGHOST"
            value_from {
              secret_key_ref {
                name = "db-credentials-${replace(each.value.credentials, "_", "-")}"
                key  = "host"
              }
            }
          }

          command = [
            "sh",
            "-c",
            "psql  -c \"CREATE EXTENSION IF NOT EXISTS ${each.value.extension};\""
          ]
        }
      }
    }
  }
}

