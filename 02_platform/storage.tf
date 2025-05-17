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
            access_mode      = storage_config.access_mode
          } if config_key == "storage"
        ]
      ]
    ]
  )
}

module "storage" {
  source   = "../tf_modules/gcp/storage_attachement"
  for_each = { for storage in local.storage_list : "${storage.application_name}-${storage.storage_name}" => storage }

  application_name      = each.value.application_name
  application_namespace = each.value.application_name
  storage_name          = each.value.storage_name
  access_mode           = each.value.access_mode
  size                  = each.value.size

  depends_on = [kubernetes_namespace.application]
}
