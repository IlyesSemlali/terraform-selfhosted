variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "system_components" {
  description = "List of applications' configuraionts"
  type = map(object({
    pg_databases = list(any),
    storage      = list(any),
    authentication = map(any
      # {
      #   name = string,
      #   type = string
      # }
    ),
  }))
}

variable "applications" {
  description = "List of applications' configuraionts"
  type = map(object({
    pg_databases = list(any),
    storage      = list(any),
    authentication = map(any
      # {
      #   name = string,
      #   type = string
      # }
    ),
  }))
}
