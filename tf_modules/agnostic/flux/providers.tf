terraform {
  required_version = ">= 1.8.5"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.2"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
