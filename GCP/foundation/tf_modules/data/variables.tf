variable "rwo_storage" {
  description = "List of RWO storage definitions"
  type = list(
    object(
      {
        application = string,
        component   = string,
        size        = number
      }
    )
  )

  default = []
}

variable "zone" {
  description = "GCP Zone where data will be stored"
  type        = string
}
