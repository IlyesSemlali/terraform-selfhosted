variable "project" {
  description = "Project name"
  type        = string
}

variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "authentik_bootstrap_email" {
  description = "Authentik akadmin email"
  type        = string
}

variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  type        = string
}

variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  type        = string
}
