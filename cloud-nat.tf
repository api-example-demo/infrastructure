resource "google_compute_address" "cloudnat_ips" {
  count   = 2
  name    = "cloudnat-ip-${count.index}"
  region  = "us-central1"
}

resource "google_compute_router" "cloudnat_router" {
  name    = "cloudnat-router"
  region  = "us-central1"
  network = data.google_compute_network.default.self_link

  bgp {
    asn = 64514
  }

  depends_on = [google_compute_address.cloudnat_ips]
}

resource "google_compute_router_nat" "cloudnat" {
  name                               = "cloudnat-0"
  router                             = google_compute_router.cloudnat_router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.cloudnat_ips.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  depends_on = [google_compute_router.cloudnat_router]
}
