variable "project" {
  description = "Project name"
}

variable "domain" {
  description = "DNS Domain "
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

variable "flux_repository" {
  description = "Gitrepository where Flux will initialize and get its sources"
}

variable "github_owner" {
  description = "Github user or organization owning the flux repositories"
}

variable "kubernetes_node_type" {
  description = "Instances types for the Kubernetes cluster nodes, can be pricy !"
  default     = "n4-standard-2"
}

variable "kubernetes_min_nodes" {
  description = "Minimum amount of nodes on the cluster"
  default     = 1
}

variable "kubernetes_max_nodes" {
  description = "Maximum amount of nodes on the cluster"
  default     = 1
}
