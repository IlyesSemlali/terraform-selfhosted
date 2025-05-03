module "databases" {
  source = "./tf_modules/databases"

  databases = [
    # the vector extension isn't the one
    # supported by immich so it'll run in a container for now
    # {
    #   application = "immich"
    #   component   = "library"
    #   password    = "immich_pass"
    #   extensions  = ["vector"]
    # }
  ]

  depends_on = [
    module.flux
  ]
}

