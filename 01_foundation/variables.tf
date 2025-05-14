variable "project" {
  description = "Project name"
  type        = string
}

variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "region" {
  description = "Belgium"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  type        = string
  default     = "europe-west1-d"
}

