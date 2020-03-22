data "google_compute_image" "debian-10" {
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_disk" "debian-10-30giga" {
  name  = "root-disk"
  type  = "pd-standard"
  image = data.google_compute_image.debian-10.self_link
  size = 30
  labels = {
    environment = "disk-debian-custom"
  }
  physical_block_size_bytes = 4096
}
