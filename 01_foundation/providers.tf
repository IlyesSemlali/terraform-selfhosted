terraform {
  required_version = ">= 1.8.5"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.2.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
