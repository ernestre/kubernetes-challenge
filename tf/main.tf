terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
    type = string
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s-challange" {
  name   = "k8s-challange"
  region = "ams3"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.5-do.0"

  node_pool {
    name       = "worker-pool"
    # Grab the available node size with `doctl kubernetes options sizes`
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}
