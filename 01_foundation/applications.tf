# This is a list of all applications and their needs
# in terms of storage and databases
#
# This list is passed from this very bottom layer
# to the upper one to create the corresponding
# services, persistent volumes and secrets

locals {
  applications = {

    immich = {
      pg_databases   = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).pg_databases
      storage        = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).storage
      authentication = yamldecode(templatefile("applications/immich-config.yaml.tftpl", { domain = var.domain })).authentication

      helm_release = {
        values     = file("applications/immich-values.yaml.tftpl")
        repository = "https://immich-app.github.io/immich-charts"
        chart      = "immich"
        version    = "0.9.2"
      }
    }
  }
}
