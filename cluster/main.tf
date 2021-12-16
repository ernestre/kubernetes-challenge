terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
  }
}

resource "digitalocean_kubernetes_cluster" "primary" {
  name   = var.cluster_name
  region = var.region
  version = var.cluster_version


  node_pool {
    name       = "default"
    size       = var.worker_size
    node_count = var.worker_count
  }
}
