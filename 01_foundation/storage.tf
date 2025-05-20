locals {
  storage_list = flatten(
    [
      for app, configs in local.applications : [
        for config_key, storage in configs : [
          for s, storage_config in storage :
          {
            application_name = app
            storage_name     = storage_config.storage_name
            size             = storage_config.size
          } if config_key == "storage"
        ]
      ]
    ]
  )
}

module "storage" {
  source   = "../tf_modules/gcp/storage"
  for_each = { for storage in local.storage_list : "${storage.application_name}-${storage.storage_name}" => storage }

  application_name = each.value.application_name
  storage_name     = each.value.storage_name
  zone             = var.zone
  size             = each.value.size
}

module "traefik_storage" {
  source = "../tf_modules/gcp/storage"

  application_name = "traefik"
  storage_name     = "certificates"
  zone             = var.zone
  size             = 1
}
