variable "domain" {
  description = "DNS Domain "
  type        = string
}


variable "project_owner_email" {
  description = "Platform owner's email address"
  type        = string
  # TODO: add validation
}

variable "project" {
  description = "Project name"
  type        = string
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

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "self-hosted"
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
