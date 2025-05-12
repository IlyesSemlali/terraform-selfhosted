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
      storage = [{

      }]
    }

  }
}
