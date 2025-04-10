resource "google_service_account" "external_dns" {
  account_id   = "external-dns"
  display_name = "External DNS for CloudDNS"
}

resource "google_project_iam_member" "dns_admin_binding" {
  project = var.project
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "google_service_account_key" "external_dns_key" {
  service_account_id = google_service_account.external_dns.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "kubernetes_secret" "external_dns_sa" {
  metadata {
    name      = "external-dns-gcp-sa"
    namespace = kubernetes_namespace.system.id
  }

  data = {
    "key.json" = base64decode(google_service_account_key.external_dns_key.private_key)
  }

  type = "Opaque"
}

