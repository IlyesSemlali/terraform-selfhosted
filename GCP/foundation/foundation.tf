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
  source = "./tf_modules/network"
  domain = var.domain
}

module "data" {
  source  = "./tf_modules/data"
  zone    = "europe-west1-b"
  network = module.network.self_link

  rwo_storage = [
    {
      application = "immich"
      component   = "library"
      size        = 10
    }
  ]

  depends_on = [google_project_service.gcp_services]
}
