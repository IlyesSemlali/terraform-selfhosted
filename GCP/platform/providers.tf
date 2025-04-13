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
    flux = {
      source  = "fluxcd/flux"
      version = "1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.2.0"
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

provider "flux" {
  kubernetes = {
    host                   = "https://${module.kubernetes[0].endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.kubernetes[0].ca_certificate)
  }
  git = {
    url = "ssh://git@github.com/${var.github_owner}/${var.flux_repository}.git"
    ssh = {
      username    = "git"
      private_key = module.flux.tls_private_key
    }
  }
}

provider "github" {
  owner = var.github_owner
}

provider "authentik" {
  url   = "https://auth.${var.domain}"
  token = var.authentik_bootstrap_token
  # insecure = false # TODO: Prod uncomment this
}
