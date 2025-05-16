terraform {
  required_version = ">= 1.8.5"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.3"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
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
      version = "~> 2.36"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
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
  host                   = data.terraform_remote_state.platform.outputs.kubernetes_host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = data.terraform_remote_state.platform.outputs.kubernetes_ca_certificate

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.platform.outputs.kubernetes_host
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = data.terraform_remote_state.platform.outputs.kubernetes_ca_certificate
  }
}

provider "flux" {
  kubernetes = {
    host                   = data.terraform_remote_state.platform.outputs.kubernetes_host
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = data.terraform_remote_state.platform.outputs.kubernetes_ca_certificate
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
