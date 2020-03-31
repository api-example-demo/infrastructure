resource "google_redis_instance" "cache" {
  name               = "redis-us-central1"
  region             = "us-central1"
  memory_size_gb     = "1"
  tier               = "STANDARD_HA"
  authorized_network = data.google_compute_network.default.self_link
  redis_version      = "REDIS_4_0"

  timeouts {
    create = "30m"
    update = "30m"
  }
}
