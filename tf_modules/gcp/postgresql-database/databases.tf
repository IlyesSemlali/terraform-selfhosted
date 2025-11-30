# locals {
#   credentials_secret_name = "db-credentials-${replace(var.name, "_", "-")}"
# }

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

resource "time_sleep" "wait_before_user_deletion" {
  depends_on = [google_sql_user.db]

  destroy_duration = "60s"
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
    database = google_sql_database.app_db.name
    username = google_sql_user.db.name
    password = google_sql_user.db.password
    host     = kubernetes_service.postgresql.metadata[0].name
  }
}

resource "kubernetes_service" "postgresql" {
  metadata {
    name      = "postgresql-${var.name}"
    namespace = var.application_namespace
  }

  spec {
    cluster_ip = "None"

    port {
      name        = "postgresql"
      port        = 5432
      target_port = 5432
    }
  }
}

# At this stage v1.33, we need both the endpoint and endpointslices, the first
# because the kube-dns can't create the right DNS record without it, and the second
# because kuberneres stopped supporting headless services for legacy endpoints

resource "kubernetes_endpoints" "postgresql" {
  metadata {
    name      = kubernetes_service.postgresql.metadata[0].name
    namespace = var.application_namespace
  }

  subset {
    address {
      ip = data.google_sql_database_instance.cloudsql.private_ip_address
    }

    port {
      name     = "postgresql"
      port     = 5432
      protocol = "TCP"
    }
  }
}

resource "kubernetes_endpoint_slice_v1" "postgresql" {
  metadata {
    name      = kubernetes_service.postgresql.metadata[0].name
    namespace = var.application_namespace
    labels = {
      "kubernetes.io/service-name" = kubernetes_service.postgresql.metadata[0].name
    }
  }

  address_type = "IPv4"

  port {
    name         = "postgresql"
    port         = 5432
    app_protocol = "TCP"
  }

  endpoint {
    addresses = [data.google_sql_database_instance.cloudsql.private_ip_address]
    condition {
      ready = true
    }
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
