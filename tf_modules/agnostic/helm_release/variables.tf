variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "name" {
  description = "Application name, used to dermine URL and OAuth client ID"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
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

variable "service_name" {
  description = "Service Name to point to in the IngressRoute"
  default     = null
  type        = string
}

variable "service_port" {
  description = "Service Port to point to in the IngressRoute"
  default     = null
  type        = number
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
