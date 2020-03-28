resource "google_container_cluster" "cluster" {
  name                     = "gke-us-central1"
  location                 = "us-central1"
  initial_node_count       = 3

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}
