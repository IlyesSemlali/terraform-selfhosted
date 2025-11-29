resource "google_clouddomains_registration" "my_registration" {
  domain_name = var.main_domain
  location    = "global"

  lifecycle {
    ignore_changes = [dns_settings, contact_settings, yearly_price]
  }

  yearly_price {
    units         = var.gcp_domain_price
    currency_code = "USD"
  }

  dns_settings {
    custom_dns {
      name_servers = [
        "ns-cloud-a1.googledomains.com.",
        "ns-cloud-a2.googledomains.com.",
        "ns-cloud-a3.googledomains.com.",
        "ns-cloud-a4.googledomains.com."
      ]
    }
  }

  contact_settings {
    privacy = "REDACTED_CONTACT_DATA"
    registrant_contact {
      phone_number = var.project_owner_phone_number
      email        = var.project_owner_email
      postal_address {
        region_code   = var.project_owner_address.region_code
        locality      = var.project_owner_address.locality
        postal_code   = var.project_owner_address.postal_code
        recipients    = var.project_owner_address.recipients
        address_lines = var.project_owner_address.address_lines
      }
    }

    admin_contact {
      phone_number = var.project_owner_phone_number
      email        = var.project_owner_email
      postal_address {
        region_code   = var.project_owner_address.region_code
        locality      = var.project_owner_address.locality
        postal_code   = var.project_owner_address.postal_code
        recipients    = var.project_owner_address.recipients
        address_lines = var.project_owner_address.address_lines
      }
    }

    technical_contact {
      phone_number = var.project_owner_phone_number
      email        = var.project_owner_email
      postal_address {
        region_code   = var.project_owner_address.region_code
        locality      = var.project_owner_address.locality
        postal_code   = var.project_owner_address.postal_code
        recipients    = var.project_owner_address.recipients
        address_lines = var.project_owner_address.address_lines
      }
    }
  }
}
