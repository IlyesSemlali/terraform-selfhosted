variable "project" {
  description = "GCP Project ID"
}

variable "domain" {
  description = "DNS Domain "
}

variable "bootstrap_email" {
  description = "Authentik akadmin email"
}

variable "bootstrap_password" {
  description = "Authentik akadmin password"
}

variable "bootstrap_token" {
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

