variable "project" {
  description = "Project name"
}

variable "domain" {
  description = "DNS Domain "
}

variable "owner_email" {
  description = "Platform owner's email address"
  # TODO: add validation
}

variable "region" {
  description = "Belgium"
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  default     = "europe-west1-d"
}

variable "flux_repository" {
  description = "Gitrepository where Flux will initialize and get its sources"
}

variable "github_owner" {
  description = "Github user or organization owning the flux repositories"
}

variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  sensitive   = true
}

variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  sensitive   = true
}

