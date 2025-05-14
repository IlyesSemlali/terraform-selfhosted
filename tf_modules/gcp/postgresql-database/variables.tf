variable "name" {
  description = "Instance and database name"
  type        = string
}

variable "application_namespace" {
  description = "Kubernetes namespace where the database credentials will be created"
  type        = string
}
