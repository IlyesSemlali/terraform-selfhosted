variable "cluster_name" {
  description = "GKE Cluster name"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "deletion_protection" {
  description = "Whether to block cluster deletion"
  type        = bool
}

variable "permanent_nodes_type" {
  description = "Instances type for the Kubernetes permanent nodes"
  type        = string
}

variable "permanent_nodes_count" {
  description = "Number of instances for the Kubernetes permanent node pool"
  type        = number
  default     = 1
}

variable "extra_nodes_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy ! (if empty, no extra nodes are set)"
  type        = string
  default     = null
}

variable "min_extra_nodes_count" {
  description = "Minimum amount of nodes on the cluster"
  type        = number
  default     = 1
}

variable "max_extra_nodes_count" {
  description = "Maximum amount of nodes on the cluster"
  type        = number
  default     = 1
}
