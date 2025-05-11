variable "project" {
  description = "Project name"
}

variable "domain" {
  description = "DNS Domain "
}

variable "owner_email" {
  description = "Platform owner's email address"
  # TODO: add validation
}

variable "off" {
  description = "Determines whether to turn on or off the infrastructure, while keeping the data alive"
  default     = false
}

variable "region" {
  description = "Belgium"
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud default compute zone"
  default     = "europe-west1-d"
}

variable "deletion_protection" {
  description = "Whether to block cluster deletion"
  default     = true
}

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name"
  default     = "self-hosted"
}

variable "kubernetes_permanent_nodes_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
  default     = "e2-standard-2"
}

variable "kubernetes_permanent_nodes_count" {
  description = "Number of instances for the Kubernetes permanent node pool"
  default     = 1
}

variable "kubernetes_extra_nodes_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
  default     = "e2-standard-2"
}

variable "kubernetes_min_extra_nodes" {
  description = "Minimum amount of nodes on the cluster"
  default     = 1
}

variable "kubernetes_max_extra_nodes" {
  description = "Maximum amount of nodes on the cluster"
  default     = 1
}

variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  sensitive   = true
}

variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  sensitive   = true
}

