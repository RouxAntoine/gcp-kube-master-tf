data "google_compute_network" "vpc_network" {
  name = "default"
}

resource "google_compute_address" "external_address" {
  name = "ip-public-compute"
  address_type = "EXTERNAL"
}
