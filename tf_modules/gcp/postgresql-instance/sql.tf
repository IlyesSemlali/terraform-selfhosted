data "google_compute_network" "primary_network" {
  name = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.primary_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.primary_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = "ABANDON"
}

resource "google_sql_database_instance" "postgresql" {
  name             = "postgresql"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled                                  = "false"
      private_network                               = data.google_compute_network.primary_network.self_link
      enable_private_path_for_google_cloud_services = true
    }

    database_flags {
      name  = "max_connections"
      value = "150"
    }
  }

  # TODO: set this based on whether it's a production instance and it's not in pre-delete stage
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
