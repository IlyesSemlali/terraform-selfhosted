data "google_client_config" "default" {}

terraform {
  required_version = ">= 0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host                   = "https://${module.kubernetes[0].endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kubernetes[0].ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}
