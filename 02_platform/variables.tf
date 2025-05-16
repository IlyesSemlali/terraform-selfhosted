variable "domain" {
  description = "DNS Domain "
  type        = string
}


variable "owner_email" {
  description = "Platform owner's email address"
  type        = string
  # TODO: add validation
}

variable "project" {
  description = "Project name"
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

variable "deletion_protection" {
  description = "Whether to block cluster deletion"
  type        = bool
  default     = true
}

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "self-hosted"
}

variable "kubernetes_permanent_nodes_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
  type        = string
  default     = "e2-standard-2"
}

# variable "kubernetes_permanent_nodes_count" {
#   description = "Number of instances for the Kubernetes permanent node pool"
#   type        = number
#   default     = 1
# }

variable "kubernetes_extra_nodes_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
  type        = string
  default     = "e2-standard-2"
}

variable "kubernetes_min_extra_nodes" {
  description = "Minimum amount of nodes on the cluster"
  type        = number
  default     = 1
}

variable "kubernetes_max_extra_nodes" {
  description = "Maximum amount of nodes on the cluster"
  type        = number
  default     = 1
}

# TODO: Generate this if not needed
variable "authentik_bootstrap_password" {
  description = "Authentik akadmin password"
  type        = string
  sensitive   = true
}

# TODO: Generate this if not needed
variable "authentik_bootstrap_token" {
  description = "Authentik akadmin token"
  type        = string
  sensitive   = true
}
