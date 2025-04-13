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

output "name_servers" {
  value       = google_dns_managed_zone.main.name_servers
  description = "Name Servers assigned for that domain"
}
