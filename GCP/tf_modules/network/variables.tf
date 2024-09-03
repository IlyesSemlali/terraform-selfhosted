variable "domain" {
  description = "DNS Domain"
}

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name from which to fetch node pools url for the LB"
}
