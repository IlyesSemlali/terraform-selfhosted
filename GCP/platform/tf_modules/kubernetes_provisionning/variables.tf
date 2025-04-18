variable "project" {
  description = "GCP Project ID"
}

variable "domain" {
  description = "DNS Domain "
}

variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
}

variable "databases" {
  type = list(object({
    application = string
    component   = string
    password    = string
    extensions  = list(string)
  }))
}

