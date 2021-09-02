terraform {
  backend "gcs" {}
}

data "terraform_remote_state" "backend" {
  backend = "gcs"
  config = {
    bucket = var.terraform_bucket
    prefix = "terraform/state"
  }
}


module "gke-cluster" {
  source     = "./modules/gke"
  project_id = var.project_id
  location   = var.location
  node_pools = {
    "node-1" = {
      machine_type = "n1-standard-1",
      image_type   = "COS_CONTAINERD",
      node_count   = 2,
      preemptible  = false
    }
  }
}
