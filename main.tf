# https://github.com/digitalocean/terraform-provider-digitalocean/blob/main/examples/kubernetes/main.tf
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
  }
}

resource "random_id" "cluster_name" {
  byte_length = 5
}

locals {
  cluster_name = "tf-k8s-${random_id.cluster_name.hex}"
}

module "doks-cluster" {
  source = "./cluster"

  cluster_name    = local.cluster_name
  region          = var.region
  worker_size     = var.worker_size
  worker_count    = var.worker_count
  cluster_version = var.cluster_version
}

module "elk" {
  source = "./elk"

  cluster_name = module.doks-cluster.cluster_name
}
