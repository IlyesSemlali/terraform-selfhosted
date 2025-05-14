variable "project" {
  description = "Project name"
  type        = string
}

variable "domain" {
  description = "DNS Domain "
  type        = string
}


variable "owner_email" {
  description = "Platform owner's email address"
  type        = string
  # TODO: add validation
}

variable "region" {
  description = "Belgium"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  type        = string
  default     = "europe-west1-d"
}

variable "flux_repository" {
  description = "Gitrepository where Flux will initialize and get its sources"
  type        = string
}

variable "github_owner" {
  description = "Github user or organization owning the flux repositories"
  type        = string
}

# TODO: Generate this if not needed
variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  type        = string
  sensitive   = true
}

# TODO: Generate this if not needed
variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  type        = string
  sensitive   = true
}
