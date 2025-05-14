variable "application_name" {
  description = "Application name that will be used as a prefix"
  type        = string
}

variable "storage_name" {
  description = "Storage name"
  type        = string
}

variable "zone" {
  description = "Google Cloud default compute zone"
  type        = string
  default     = "europe-west1-d"
}

variable "size" {
  description = "Storage disk size"
  type        = number
}
