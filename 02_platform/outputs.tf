output "kubernetes_host" {
  description = "Kubernetes host to use for client connection"
  value       = "https://${module.kubernetes.endpoint}"
}

output "kubernetes_ca_certificate" {
  description = "Kubernetes CA certificate to use for client connection"
  value       = base64decode(module.kubernetes.ca_certificate)

}

output "kubernetes_native_routing_cidr" {
  description = "Kubernetes native rounting CIDR address"
  value       = module.kubernetes.native_routing_cidr
}
