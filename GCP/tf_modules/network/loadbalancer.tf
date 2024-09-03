# TODO: Create a LoadBalancer that points to all cluster nodes
# on a predefined NodePort that traefik will use to serve ingresses

# From: https://cloud.google.com/load-balancing/docs/tcp/ext-tcp-proxy-lb-tf-examples

# reserved IP address
resource "google_compute_global_address" "ip_reservation" {
  provider = google
  name     = "kubernetes-ingress"
}

output "lb_ip_address" {
  value = google_compute_global_address.ip_reservation.address
}

