#######
# DNS #
#######

resource "google_dns_managed_zone" "main" {
  name          = replace(var.domain, ".", "-")
  dns_name      = format("%s.", var.domain)
  description   = "${var.domain} Cloud public DNS"
  force_destroy = true

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "on"
  }

  timeouts {}

}
