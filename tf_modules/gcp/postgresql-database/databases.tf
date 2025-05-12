locals {
  credentials_secret_name = "db-credentials-${replace(var.name, "_", "-")}"
}

data "google_sql_database_instance" "cloudsql" {
  name = "postgresql"
}

resource "google_sql_database" "app_db" {
  name     = var.name
  instance = data.google_sql_database_instance.cloudsql.name
}

resource "random_password" "db" {
  length  = 16
  special = true
  # TODO: check supported chars
  override_special = "!%&*()-_=+[]{}<>:?"
}

resource "google_sql_user" "db" {
  name     = var.name
  instance = data.google_sql_database_instance.cloudsql.name
  password = random_password.db.result
}

resource "kubernetes_secret" "db_infos" {
  lifecycle {
    replace_triggered_by = [
      google_sql_user.db
    ]
  }

  metadata {
    name      = "db-credentials-${replace(var.name, "_", "-")}"
    namespace = var.application_namespace
  }

  data = {
    username = var.name
    password = random_password.db.result
    host     = data.google_sql_database_instance.cloudsql.private_ip_address
  }
}

# TODO: check if this is needed
# resource "kubernetes_job" "grant_privileges" {
#   for_each = toset(var.extensions)
#   # {
#   #   key = "${db.application}${db.component != "" ? "_${db.component}" : ""}_${ext}"
#   #   value = {
#   #     application = db.application
#   #     component   = db.component
#   #     credentials = "${db.application}${db.component != "" ? "_${db.component}" : ""}"
#   #     extension   = ext
#   # }
#   #
#   metadata {
#     name      = "enable-db-extension-${replace(var.name, "_", "-")}"
#     namespace = var.application_namespace
#   }
#
#   spec {
#     template {
#       metadata {}
#       spec {
#         restart_policy = "OnFailure"
#
#         container {
#           name  = "psql"
#           image = "postgres:15"
#
#           env {
#             name = "PGUSER"
#             value_from {
#               secret_key_ref {
#                 name = local.credentials_secret_name
#                 key  = "username"
#               }
#             }
#           }
#
#           env {
#             name = "PGPASSWORD"
#             value_from {
#               secret_key_ref {
#                 name = local.credentials_secret_name
#                 key  = "password"
#               }
#             }
#           }
#
#           env {
#             name = "PGHOST"
#             value_from {
#               secret_key_ref {
#                 name = local.credentials_secret_name
#                 key  = "host"
#               }
#             }
#           }
#
#           command = [
#             "sh",
#             "-c",
#             "psql  -c \"CREATE EXTENSION IF NOT EXISTS ${each.value.extension};\""
#           ]
#         }
#       }
#     }
#   }
# }

