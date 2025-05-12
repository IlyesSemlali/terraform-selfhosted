variable "name" {
  description = "Instance and database name"
  type        = string
}

variable "size" {
  description = "Database minimum disk size"
  type        = number
}

variable "extensions" {
  description = "List of extensions to enable"
  default     = []
  type        = list(string)
}

variable "application_namespace" {
  description = "Kubernetes namespace where the database credentials will be created"
  type        = string
}
