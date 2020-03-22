resource "google_compute_resource_policy" "schedule_snapshot" {
  name   = "auto-snapshot-policy"
  snapshot_schedule_policy {
    schedule {
      weekly_schedule {
        day_of_weeks {
          start_time = "04:42"
          day = "MONDAY"
        }
      }
    }
    retention_policy {
      max_retention_days = 28
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      labels = {
        name = var.kube_master_tags[0]
      }
      storage_locations = ["us"]
      guest_flush = true
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "attachment_schedule" {
  name = google_compute_resource_policy.schedule_snapshot.name
  disk = google_compute_disk.debian-10-30giga.name
}