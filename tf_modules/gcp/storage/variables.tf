variable "application_name" {
  description = "Application name that will be used as a prefix"
  type        = string
}

variable "application_namespace" {
  description = "Application name that will be used as a prefix"
  type        = string
}

variable "storage_name" {
  description = "Storage name"
  type        = string
}

variable "region" {
  description = "Belgium"
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  default     = "europe-west1-d"
}

variable "size" {
  description = "Storage disk size"
  type        = number
}

variable "access_mode" {
  description = "Persistent volume access mode"
  type        = string
  default     = "ReadWriteOnce"
}
