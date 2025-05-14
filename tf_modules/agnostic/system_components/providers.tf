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
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}
