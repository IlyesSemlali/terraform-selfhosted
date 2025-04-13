module "network" {
  source = "./tf_modules/network"
  domain = var.domain
}

module "data" {
  source = "./tf_modules/data"
  zone   = "europe-west1-b"
  rwo_storage = [
    {
      application = "immich"
      component   = "library"
      size        = 10
    }
  ]
}
