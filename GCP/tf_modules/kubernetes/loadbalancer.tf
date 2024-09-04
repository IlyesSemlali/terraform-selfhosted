# https://github.com/terraform-google-modules/terraform-google-lb/blob/e59726c80f6f905cd9a074ac3e90ce41ff0072af/main.tf
resource "google_compute_health_check" "ingress" {
  name = "ingress-hc"

  check_interval_sec  = 10
  healthy_threshold   = 2
  timeout_sec         = 5
  unhealthy_threshold = 3

  tcp_health_check {
    port = var.ingress_health_check_port
  }
}

# TODO: this breaks, find out why and reenable
# resource "google_compute_forwarding_rule" "ingress" {
#   name   = "kubernetes-ingress"
#   region = var.region
#
#   load_balancing_scheme = "EXTERNAL"
#   network_tier          = "STANDARD"
#
#   target     = google_compute_backend_service.nodes.id
#   port_range = "32080"
#
#   ip_address  = var.lb_ip_address
#   ip_protocol = "TCP"
# }

resource "google_compute_backend_service" "nodes" {
  name                  = "kubernetes-ingress"
  protocol              = "TCP" # Use "HTTP" or "HTTPS" if you're using an HTTP(S) load balancer
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.ingress.self_link]

  # TODO: include extra pool in the same backend
  backend {
    group = (replace(google_container_node_pool.extra[0].instance_group_urls[0],
      "instanceGroupManagers",
      "instanceGroups"
    ))
  }
}

