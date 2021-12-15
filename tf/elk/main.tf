terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
  }
}

data "digitalocean_kubernetes_cluster" "primary" {
  name = var.cluster_name
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.primary.endpoint
  token = data.digitalocean_kubernetes_cluster.primary.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.primary.endpoint
    token = data.digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate
    )
  }
}

resource "helm_release" "elasticsearch" {
  name    = "elastic"
  chart   = "elastic/elasticsearch"
  version = "7.15.0"
}

resource "helm_release" "kibana" {
  name    = "kibana"
  chart   = "elastic/kibana"
  version = "7.15.0"
}

resource "helm_release" "fluentbit" {
  name    = "fluent-bit"
  chart   = "fluent/fluent-bit"
  version = "0.19.9"
}

resource "kubernetes_service" "lb" {
  metadata {
    name = "kibana-lb"
  }
  spec {
    selector = {
      app = "kibana"
    }
    port {
      port        = 80
      target_port = 5601
    }
    type = "LoadBalancer"
  }
}
