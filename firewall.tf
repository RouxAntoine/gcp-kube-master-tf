resource "google_compute_firewall" "default" {
  name    = "kubeapi"
  network = data.google_compute_network.vpc_network.self_link
  description = "kubeapi port from external"

  allow {
    protocol = "tcp"
    ports = ["6443"]
  }

  direction = "INGRESS"
  source_ranges = [var.source_allowed_ip]
  target_tags = var.kube_master_tags
  priority = 1000
}
