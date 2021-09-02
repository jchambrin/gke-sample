resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.location
  provider = google

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "pools" {
  for_each   = var.node_pools
  name       = each.key
  project    = var.project_id
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = each.value.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    preemptible  = each.value.preemptible
    machine_type = each.value.machine_type
    image_type   = each.value.image_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

}
