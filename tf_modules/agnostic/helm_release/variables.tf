variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "name" {
  description = "Application name, used to dermine URL and OAuth client ID"
  type        = string
}

variable "helm_repository" {
  description = "Helm Chart's"
  type        = string
}

variable "helm_chart" {
  description = "Helm Chart's name"
  type        = string
}

variable "helm_chart_version" {
  description = "Helm Chart's version"
  type        = string
}

variable "helm_values" {
  description = "Helm Releases' values"
  type        = string
}

variable "oauth_client_secret" {
  description = "OAuth client secret"
  type        = string
  default     = ""
}

variable "oauth_scopes" {
  description = "Space seperated list of OAuth2 scopes to allow"
  type        = string
  default     = ""
}
