variable "project" {
  description = "Project name"
}

variable "domain" {
  description = "DNS Domain "
}

variable "region" {
  description = "Belgium"
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  default     = "europe-west1-d"
}
