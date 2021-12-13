# Or grab the latest version slug from `doctl kubernetes options versions`
variable "cluster_version" {
  default = "1.21.5-do.0"
}

variable "region" {
  default = "ams3"
}

# Grab the available node size with `doctl kubernetes options sizes`
variable "worker_size" {
  default = "s-4vcpu-8gb"
}

variable "worker_count" {
  default = 3
}
