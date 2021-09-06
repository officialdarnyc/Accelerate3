terraform {
  required_version = "~> 0.12"
  backend "gcs" {
    bucket      = "orderbird-terraform-state"
    prefix      = "terraform/state"
    credentials = ".keys/orderbird.json"
  }
}
provider "google" {
  credentials = file(".keys/orderbird.json")
  project     = "orderbird"
  region      = "us-central1"
}

resource "google_container_cluster" "gke-cluster" {
  name                     = "ob-cluster"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  # In regional cluster (location is region, not zone) 
  # this is a number of nodes per zone 
  initial_node_count = 1
}

resource "google_container_node_pool" "preemptible_node_pool" {
  name     = "default-pool"
  location = "us-central1-a"
  cluster  = google_container_cluster.gke-cluster.name
  # In regional cluster (location is region, not zone) 
  # this is a number of nodes per zone
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]
  }
}