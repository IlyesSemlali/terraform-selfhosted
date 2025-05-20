locals {
  system_components = {
    traefik = {
      metadata = {
        name        = "Traefik",
        description = "Traefik Dashboard",
        group       = "Admin Panel",
      }

      pg_databases   = yamldecode(templatefile("system_components/traefik-config.yaml.tftpl", { domain = var.domain })).pg_databases,
      storage        = yamldecode(templatefile("system_components/traefik-config.yaml.tftpl", { domain = var.domain })).storage,
      authentication = yamldecode(templatefile("system_components/traefik-config.yaml.tftpl", { domain = var.domain })).authentication,

      helm_release = {
        values     = file("system_components/traefik-values.yaml.tftpl")
        repository = "https://traefik.github.io/charts"
        chart      = "traefik"
        version    = "v35.3.0"
      }
    }
  }
}
