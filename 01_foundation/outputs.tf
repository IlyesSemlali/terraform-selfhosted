output "network" {
  value = module.network.name
}

output "applications" {
  value = local.applications
}

output "system_components" {
  value = local.system_components
}
