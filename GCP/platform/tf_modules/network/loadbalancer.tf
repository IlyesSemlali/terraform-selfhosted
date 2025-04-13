# https://github.com/terraform-google-modules/terraform-google-lb/blob/e59726c80f6f905cd9a074ac3e90ce41ff0072af/main.tf

# reserved IP address
resource "google_compute_address" "ip_reservation" {
  provider     = google
  name         = "kubernetes-ingress"
  network_tier = "STANDARD"
}

output "lb_ip_address" {
  value = google_compute_address.ip_reservation.address
}

