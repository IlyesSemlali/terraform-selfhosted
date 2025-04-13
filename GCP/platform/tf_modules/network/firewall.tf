# https://github.com/terraform-google-modules/terraform-google-lb/blob/e59726c80f6f905cd9a074ac3e90ce41ff0072af/main.tf
resource "google_compute_firewall" "allow_http_on_ingress" {
  name = "allow-http-on-ingress"

  # TODO: move all ressources to the correct network
  # network = google_compute_network.primary_network.name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }

  source_ranges = ["0.0.0.0/0"]
}
