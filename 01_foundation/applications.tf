# This is a list of all applications and their needs
# in terms of storage and databases
#
# This list is passed from this very bottom layer
# to the upper one to create the corresponding
# services, persistent volumes and secrets

# Applications configuration:
#
# - if the component is empty this means that it's the global instance
#   otherwise there will be a dedicated DB for that component
#
# - size is in GB

locals {
  applications = {

    immich = {
      pg_databases = [
        {
          name       = "immich"
          extensions = ["vector"]
          size       = 10
        }
      ]
      storage = [
        {
          storage_name = "library"
          size         = 10
          access_mode  = "ReadWriteOnce"
        },
        {
          storage_name = "ml"
          size         = 10
          access_mode  = "ReadWriteOnce"
        }
      ]
      authentication = {
        name = "Immich"
        type = "oauth2",

        description = "Photo library"
        group       = "Private Cloud"
        redirect_uris = join(";", [
          "app.immich:///oauth-callback",
          "https://immich.${var.domain}/auth/login",
          "https://immich.${var.domain}/user-settings"
        ])
      }
      helm_release = {
        values     = file("applications/immich-values.yaml.tftpl")
        repository = "https://immich-app.github.io/immich-charts"
        chart      = "immich"
        version    = "0.9.2"
      }
    }

  }
}
