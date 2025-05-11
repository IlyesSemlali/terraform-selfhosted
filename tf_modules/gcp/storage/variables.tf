variable "region" {
  description = "Belgium"
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  default     = "europe-west1-d"
}

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

variable "network" {
  description = "VPC name in which the private IP will be created"
  type        = string
}
