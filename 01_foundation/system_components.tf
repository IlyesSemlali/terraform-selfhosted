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

    cilium = {
      metadata = {
        name = "Cilium",
      }

      helm_release = {
        values     = file("system_components/cilium/values.yaml")
        repository = "https://helm.cilium.io/"
        chart      = "cilium"
        version    = "1.17.2"
      }
    }

  }
}
