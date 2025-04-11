variable "cluster_name" {
  description = "GKE Cluster name"
}

variable "zone" {
  description = "GCP Zone"
}

variable "region" {
  description = "GCP Region"
}

variable "deletion_protection" {
  description = "Whether to block cluster deletion"
}

variable "permanent_nodes_type" {
  description = "Instances type for the Kubernetes permanent nodes"
}

variable "permanent_nodes_count" {
  description = "Number of instances for the Kubernetes permanent node pool"
  default     = 1
}

variable "extra_nodes_type" {
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

variable "lb_ip_address" {
  description = "TCP LB IP Address that has beenreserved for this cluster"
}

variable "ingress_health_check_port" {
  default = 32080 # TODO: set traefik HC
}
