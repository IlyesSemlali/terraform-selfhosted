# This is a list of all applications and their needs
# in terms of storage and databases
#
# This list is passed from this very bottom layer
# to the upper one to create the corresponding
# services, persistent volumes and secrets

locals {
  applications = {

    immich = {
      metadata = {
        name        = "Immich",
        description = "Photo library",
        group       = "Private Cloud",
      }

      pg_databases   = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).pg_databases,
      storage        = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).storage,
      authentication = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).authentication,

      ingress = {
        service_port = 2283
        service_name = "immich-server"
      }

      helm_release = {
        values     = file("applications/immich-values.yaml.tftpl")
        repository = "https://immich-app.github.io/immich-charts"
        chart      = "immich"
        version    = "0.10.3"
      }
    }
  }
}
