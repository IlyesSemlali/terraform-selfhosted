variable "project" {
  description = "Project name"
  type        = string
}

variable "domain" {
  description = "DNS domain"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namspace"
  type        = string
  default     = "system"
}

variable "authentik_bootstrap_email" {
  description = "Authentik akadmin email"
  type        = string
}

variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  type        = string
}

variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  type        = string
}

variable "authentik_pg_host" {
  description = "Authentik PostgreSQL host"
  sensitive   = true
  type        = string
}

variable "authentik_pg_user" {
  description = "Authentik PostgreSQL user"
  sensitive   = true
  type        = string
}

variable "authentik_pg_password" {
  description = "Authentik PostgreSQL password"
  sensitive   = true
  type        = string
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
}

variable "native_routing_cidr" {
  description = "GKE IPV4 native routing CIDR"
  type        = string
}
