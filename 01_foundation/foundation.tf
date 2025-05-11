locals {
  gcp_service_list = [
    "servicenetworking.googleapis.com",
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(local.gcp_service_list)
  project  = var.project
  service  = each.key
}

module "network" {
  source = "../tf_modules/gcp/network"
  domain = var.domain
}
