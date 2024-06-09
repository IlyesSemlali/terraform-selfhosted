variable "cluster_name" {
  description = "GKE Cluster name"
}

variable "zone" {
  description = "GCP Zone"
}

variable "node_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
}

variable "min_nodes_count" {
  description = "Minimum amount of nodes on the cluster"
  default     = 1
}

variable "max_nodes_count" {
  description = "Maximum amount of nodes on the cluster"
  default     = 1
}
