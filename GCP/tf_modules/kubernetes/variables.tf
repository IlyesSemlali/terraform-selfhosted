variable "cluster_name" {
  description = "GKE Cluster name"
}

variable "zone" {
  description = "GCP Zone"
}

variable "permanent_node_type" {
  description = "Instances type for the Kubernetes permanent nodes"
}

variable "extra_node_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy ! (if empty, no extra nodes are set)"
  default     = null
}

variable "min_extra_nodes_count" {
  description = "Minimum amount of nodes on the cluster"
  default     = 1
}

variable "max_extra_nodes_count" {
  description = "Maximum amount of nodes on the cluster"
  default     = 1
}
