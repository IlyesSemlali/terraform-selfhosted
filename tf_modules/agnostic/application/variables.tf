variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "system_components" {
  description = "List of applications' configuraionts"
  type = map(object({
    pg_databases   = list(any),
    storage        = list(any),
    authentication = map(any),
    # TODO: re-enable this once system_components have been moved TF management
    # helm_release  = map(any),
  }))
}

variable "applications" {
  description = "List of applications' configuraionts"
  type = map(object({
    pg_databases   = list(any),
    storage        = list(any),
    authentication = map(any),
    helm_release   = map(any),
  }))
}
