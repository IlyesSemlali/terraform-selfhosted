#######
# DNS #
#######

resource "google_dns_managed_zone" "main" {
  name        = replace(var.domain, ".", "-")
  dns_name    = format("%s.", var.domain)
  description = "${var.domain} Cloud public DNS"


  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "on"
  }

  timeouts {}

}

resource "google_dns_record_set" "ingress_dns" {
  name         = "${var.domain}."
  managed_zone = google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.ip_reservation.address]
}
