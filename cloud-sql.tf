data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_global_address" "private_sql_ip_address" {
  provider      = google-beta
  name          = "private-sql-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = "default"
}

resource "google_service_networking_connection" "servicenetworking_vpc_connection" {
  provider                = google-beta
  network                 = "default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_sql_ip_address.name]

  depends_on = [google_compute_global_address.private_sql_ip_address]
}

resource "google_sql_database_instance" "cloud_sql" {
  name             = "sql-us-central1"
  region           = "us-central1"
  database_version = "POSTGRES_11"

  settings {
    tier              = "db-custom-2-13312"
    disk_type         = "PD_HDD"
    disk_autoresize   = true
    availability_type = "REGIONAL"

    backup_configuration {
      enabled            = true
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.default.self_link

      authorized_networks {
        name  = "cloudnat-ip-0"
        value = google_compute_address.cloudnat_ips[0].address
      }
      authorized_networks {
        name  = "cloudnat-ip-1"
        value = google_compute_address.cloudnat_ips[1].address
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
  }

  depends_on = [
    google_service_networking_connection.servicenetworking_vpc_connection
  ]
}
