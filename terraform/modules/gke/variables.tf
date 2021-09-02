provider "google" {
  project = var.project_id
  region  = var.location
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "project_id" {
  description = "project id"
}

variable "location" {
  description = "location"
}

variable "node_pools" {
  type = map(object({
    machine_type = string
    image_type   = string
    node_count   = number
    preemptible  = bool
  }))
}