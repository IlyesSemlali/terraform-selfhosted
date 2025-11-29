module "main_domain" {
  source = "../tf_modules/gcp/domain"

  main_domain = var.domain

  project_owner_email        = var.project_owner_email
  project_owner_address      = var.project_owner_address
  project_owner_phone_number = var.project_owner_phone_number
  gcp_domain_price           = var.gcp_domain_price
}
