output "pg_host" {
  value = kubernetes_service.postgresql.metadata[0].name
}

output "pg_user" {
  value = google_sql_user.db.name
}

output "pg_password" {
  value = google_sql_user.db.password
}
