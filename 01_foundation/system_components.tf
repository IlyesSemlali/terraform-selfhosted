locals {
  system_components = {
    traefik = {
      metadata = {
        name        = "Traefik",
        description = "Traefik Dashboard",
        group       = "Admin Panel",
      }

      storage        = yamldecode(templatefile("system_components/traefik/config.yaml", { domain = var.domain })).storage,
      authentication = yamldecode(templatefile("system_components/traefik/config.yaml", { domain = var.domain })).authentication,

      helm_release = {} # Installed through the system_components module
    }

  }
}
