resource "google_compute_health_check" "tcp_health_check" {
  name                = "ingress-tcp-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "tcp_backend_service" {
  name                  = "ingress-tcp-backend-service"
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.tcp_health_check.self_link]

  dynamic "backend" {
    for_each = google_container_node_pool.permanent.managed_instance_group_urls

    content {
      group = backend.value
    }
  }
}
