output "kubernetes_host" {
  description = "Kubernetes host to use for client connection"
  value       = "https://${module.kubernetes[0].endpoint}"
}

output "kubernetes_ca_certificate" {
  description = "Kubernetes CA certificate to use for client connection"
  value       = base64decode(module.kubernetes[0].ca_certificate)
}
