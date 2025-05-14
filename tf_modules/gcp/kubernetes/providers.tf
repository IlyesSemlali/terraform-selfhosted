terraform {
  required_version = ">= 1.8.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
