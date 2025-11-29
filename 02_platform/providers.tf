terraform {
  required_version = ">= 1.8.5"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.kubernetes.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kubernetes.ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.kubernetes.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.kubernetes.ca_certificate)
  }
}

provider "authentik" {
  url      = "https://auth.${var.domain}"
  token    = var.authentik_bootstrap_token
  insecure = true # TODO: Prod uncomment this
}
