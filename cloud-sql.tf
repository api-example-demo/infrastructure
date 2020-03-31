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
