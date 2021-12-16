output "kibana_lb_ip" {
  value = data.kubernetes_service.lb.status.0.load_balancer.0.ingress.0.ip
}

output "cluster_id" {
  value = data.digitalocean_kubernetes_cluster.primary.id
}
