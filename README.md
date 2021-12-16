# DigitalOcean k8s challange
Topic: Deploy a log monitoring system

Demo available [here](http://134.209.139.125/)

## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/), the Kubernetes command-line tool
* [helm](https://helm.sh/docs/intro/install/),  package manager for
  Kubernetes.
* [terraform](https://www.terraform.io/downloads), an open-source
  infrastructure as code software tool.
* [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/), The official command line interface for the DigitalOcean API


## Configuring doctl

Once you've downloaded doctl, follow the
[documentation](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-2-create-an-api-token)
on how to create an **API token** and use the **API token** to grant account access to
doctl.

Save the **API token** somewhere for now, we will needed it the next steps.

## Creating the cluster and deploying the log monitoring system

This log monitoring system we'll be using fluentbit, elasticsearch and kibana.
We'll deploy every service using a helm chart.

In order to deploy the infrastructure you'll need the API token which you've
created during the doctl configuration. The API token needs to be saved in an
environment variable called `DIGITALOCEAN_TOKEN`.

Then just simply run the terraform's innit command:

```bash
$ DIGITALOCEAN_TOKEN=<YOUR API TOKEN> terraform init

Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of digitalocean/digitalocean from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/helm from the dependency lock file
- Using previously-installed digitalocean/digitalocean v2.16.0
- Using previously-installed hashicorp/random v3.1.0
- Using previously-installed hashicorp/kubernetes v2.7.1
- Using previously-installed hashicorp/helm v2.4.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

After that, you can start using terraform to `plan` or `apply` infrastructure
changes.

(optional) You can run `terraform plan` to see what changes will be made to the
infrastructure before applying them.

```bash
$ DIGITALOCEAN_TOKEN=<YOUR API TOKEN> terraform plan
```

<details>
<summary>Output example...</summary>
<p>

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # random_id.cluster_name will be created
  + resource "random_id" "cluster_name" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 5
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

  # module.doks-cluster.digitalocean_kubernetes_cluster.primary will be created
  + resource "digitalocean_kubernetes_cluster" "primary" {
      + cluster_subnet = (known after apply)
      + created_at     = (known after apply)
      + endpoint       = (known after apply)
      + ha             = false
      + id             = (known after apply)
      + ipv4_address   = (known after apply)
      + kube_config    = (sensitive value)
      + name           = (known after apply)
      + region         = "ams3"
      + service_subnet = (known after apply)
      + status         = (known after apply)
      + surge_upgrade  = true
      + updated_at     = (known after apply)
      + urn            = (known after apply)
      + version        = "1.21.5-do.0"
      + vpc_uuid       = (known after apply)

      + maintenance_policy {
          + day        = (known after apply)
          + duration   = (known after apply)
          + start_time = (known after apply)
        }

      + node_pool {
          + actual_node_count = (known after apply)
          + auto_scale        = false
          + id                = (known after apply)
          + name              = "default"
          + node_count        = 3
          + nodes             = (known after apply)
          + size              = "s-4vcpu-8gb"
        }
    }

  # module.elk.data.digitalocean_kubernetes_cluster.primary will be read during apply
  # (config refers to values not yet known)
 <= data "digitalocean_kubernetes_cluster" "primary"  {
      + auto_upgrade       = (known after apply)
      + cluster_subnet     = (known after apply)
      + created_at         = (known after apply)
      + endpoint           = (known after apply)
      + ha                 = (known after apply)
      + id                 = (known after apply)
      + ipv4_address       = (known after apply)
      + kube_config        = (sensitive value)
      + maintenance_policy = (known after apply)
      + name               = (known after apply)
      + node_pool          = (known after apply)
      + region             = (known after apply)
      + service_subnet     = (known after apply)
      + status             = (known after apply)
      + surge_upgrade      = (known after apply)
      + updated_at         = (known after apply)
      + urn                = (known after apply)
      + version            = (known after apply)
      + vpc_uuid           = (known after apply)
    }

  # module.elk.data.kubernetes_service.lb will be read during apply
  # (config refers to values not yet known)
 <= data "kubernetes_service" "lb"  {
      + id     = (known after apply)
      + spec   = (known after apply)
      + status = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = (known after apply)
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # module.elk.helm_release.elasticsearch will be created
  + resource "helm_release" "elasticsearch" {
      + atomic                     = false
      + chart                      = "elastic/elasticsearch"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "elastic"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "7.15.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.helm_release.fluentbit will be created
  + resource "helm_release" "fluentbit" {
      + atomic                     = false
      + chart                      = "fluent/fluent-bit"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "fluent-bit"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "0.19.9"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.helm_release.kibana will be created
  + resource "helm_release" "kibana" {
      + atomic                     = false
      + chart                      = "elastic/kibana"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "kibana"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "7.15.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.kubernetes_service.lb will be created
  + resource "kubernetes_service" "lb" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = (known after apply)
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + cluster_ip                  = (known after apply)
          + external_traffic_policy     = (known after apply)
          + health_check_node_port      = (known after apply)
          + publish_not_ready_addresses = false
          + selector                    = {
              + "app" = "kibana"
            }
          + session_affinity            = "None"
          + type                        = "LoadBalancer"

          + port {
              + node_port   = (known after apply)
              + port        = 80
              + protocol    = "TCP"
              + target_port = "5601"
            }
        }
    }

  # module.elk.random_id.lb_name will be created
  + resource "random_id" "lb_name" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 5
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 7 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
</p>
</details>

Now you can apply the changes with with `terraform apply` command.

```bash
$ DIGITALOCEAN_TOKEN=<YOUR API TOKEN> terraform apply
```

You should see the same out as you've seen in at the planing stage. Additionally
you'll be asked to confirm the changes by typing `yes`.

```
[...]
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:

```

<details>
<summary>Output example...</summary>
<p>

```
Terraform used the selected providers to generate the following
execution plan. Resource actions are indicated with the following
symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # random_id.cluster_name will be created
  + resource "random_id" "cluster_name" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 5
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

  # module.doks-cluster.digitalocean_kubernetes_cluster.primary will
be created
  + resource "digitalocean_kubernetes_cluster" "primary" {
      + cluster_subnet = (known after apply)
      + created_at     = (known after apply)
      + endpoint       = (known after apply)
      + ha             = false
      + id             = (known after apply)
      + ipv4_address   = (known after apply)
      + kube_config    = (sensitive value)
      + name           = (known after apply)
      + region         = "ams3"
      + service_subnet = (known after apply)
      + status         = (known after apply)
      + surge_upgrade  = true
      + updated_at     = (known after apply)
      + urn            = (known after apply)
      + version        = "1.21.5-do.0"
      + vpc_uuid       = (known after apply)

      + maintenance_policy {
          + day        = (known after apply)
          + duration   = (known after apply)
          + start_time = (known after apply)
        }

      + node_pool {
          + actual_node_count = (known after apply)
          + auto_scale        = false
          + id                = (known after apply)
          + name              = "default"
          + node_count        = 3
          + nodes             = (known after apply)
          + size              = "s-4vcpu-8gb"
        }
    }

  # module.elk.data.digitalocean_kubernetes_cluster.primary will be r
ead during apply
  # (config refers to values not yet known)
 <= data "digitalocean_kubernetes_cluster" "primary"  {
      + auto_upgrade       = (known after apply)
      + cluster_subnet     = (known after apply)
      + created_at         = (known after apply)
      + endpoint           = (known after apply)
      + ha                 = (known after apply)
      + id                 = (known after apply)
      + ipv4_address       = (known after apply)
      + kube_config        = (sensitive value)
      + maintenance_policy = (known after apply)
      + name               = (known after apply)
      + node_pool          = (known after apply)
      + region             = (known after apply)
      + service_subnet     = (known after apply)
      + status             = (known after apply)
      + surge_upgrade      = (known after apply)
      + updated_at         = (known after apply)
      + urn                = (known after apply)
      + version            = (known after apply)
      + vpc_uuid           = (known after apply)
    }

  # module.elk.data.kubernetes_service.lb will be read during apply
  # (config refers to values not yet known)
 <= data "kubernetes_service" "lb"  {
      + id     = (known after apply)
      + spec   = (known after apply)
      + status = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = (known after apply)
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # module.elk.helm_release.elasticsearch will be created
  + resource "helm_release" "elasticsearch" {
      + atomic                     = false
      + chart                      = "elastic/elasticsearch"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "elastic"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "7.15.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.helm_release.fluentbit will be created
  + resource "helm_release" "fluentbit" {
      + atomic                     = false
      + chart                      = "fluent/fluent-bit"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "fluent-bit"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "0.19.9"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.helm_release.kibana will be created
  + resource "helm_release" "kibana" {
      + atomic                     = false
      + chart                      = "elastic/kibana"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "kibana"
      + namespace                  = "default"
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "7.15.0"
      + wait                       = true
      + wait_for_jobs              = false
    }

  # module.elk.kubernetes_service.lb will be created
  + resource "kubernetes_service" "lb" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = (known after apply)
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + cluster_ip                  = (known after apply)
          + external_traffic_policy     = (known after apply)
          + health_check_node_port      = (known after apply)
          + publish_not_ready_addresses = false
          + selector                    = {
              + "app" = "kibana"
            }
          + session_affinity            = "None"
          + type                        = "LoadBalancer"

          + port {
              + node_port   = (known after apply)
              + port        = 80
              + protocol    = "TCP"
              + target_port = "5601"
            }
        }
    }

  # module.elk.random_id.lb_name will be created
  + resource "random_id" "lb_name" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 5
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_id.cluster_name: Creating...
module.elk.random_id.lb_name: Creating...
random_id.cluster_name: Creation complete after 0s [id=IZJJUEk]
module.elk.random_id.lb_name: Creation complete after 0s [id=jkKJWhQ]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Creating...
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [1m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [2m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [3m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [4m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [5m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m0s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m10s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m20s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m30s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m40s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Still creating... [6m50s elapsed]
module.doks-cluster.digitalocean_kubernetes_cluster.primary: Creation complete after 6m55s [id=2803091e-7f38-45ee-a907-1b034ccfbcfb]
module.elk.data.digitalocean_kubernetes_cluster.primary: Reading...
module.elk.data.digitalocean_kubernetes_cluster.primary: Read complete after 1s [id=2803091e-7f38-45ee-a907-1b034ccfbcfb]
module.elk.data.kubernetes_service.lb: Reading...
module.elk.kubernetes_service.lb: Creating...
module.elk.helm_release.kibana: Creating...
module.elk.helm_release.fluentbit: Creating...
module.elk.helm_release.elasticsearch: Creating...
module.elk.data.kubernetes_service.lb: Read complete after 2s
module.elk.kubernetes_service.lb: Still creating... [10s elapsed]
module.elk.helm_release.kibana: Still creating... [10s elapsed]
module.elk.helm_release.fluentbit: Still creating... [10s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [10s elapsed]
module.elk.helm_release.fluentbit: Creation complete after 10s [id=fluent-bit]
module.elk.kubernetes_service.lb: Still creating... [20s elapsed]
module.elk.helm_release.kibana: Still creating... [20s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [20s elapsed]
module.elk.kubernetes_service.lb: Still creating... [30s elapsed]
module.elk.helm_release.kibana: Still creating... [30s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [30s elapsed]
module.elk.kubernetes_service.lb: Still creating... [40s elapsed]
module.elk.helm_release.kibana: Still creating... [40s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [40s elapsed]
module.elk.kubernetes_service.lb: Still creating... [50s elapsed]
module.elk.helm_release.kibana: Still creating... [50s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [50s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m0s elapsed]
module.elk.helm_release.kibana: Still creating... [1m0s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m0s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m10s elapsed]
module.elk.helm_release.kibana: Still creating... [1m10s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m10s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m20s elapsed]
module.elk.helm_release.kibana: Still creating... [1m20s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m20s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m30s elapsed]
module.elk.helm_release.kibana: Still creating... [1m30s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m30s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m40s elapsed]
module.elk.helm_release.kibana: Still creating... [1m40s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m40s elapsed]
module.elk.kubernetes_service.lb: Still creating... [1m50s elapsed]
module.elk.helm_release.kibana: Still creating... [1m50s elapsed]
module.elk.helm_release.elasticsearch: Still creating... [1m50s elapsed]
module.elk.helm_release.elasticsearch: Creation complete after 1m58s [id=elastic]
module.elk.kubernetes_service.lb: Still creating... [2m0s elapsed]
module.elk.helm_release.kibana: Still creating... [2m0s elapsed]
module.elk.kubernetes_service.lb: Still creating... [2m10s elapsed]
module.elk.helm_release.kibana: Still creating... [2m10s elapsed]
module.elk.kubernetes_service.lb: Still creating... [2m20s elapsed]
module.elk.helm_release.kibana: Still creating... [2m20s elapsed]
module.elk.helm_release.kibana: Creation complete after 2m23s [id=kibana]
module.elk.kubernetes_service.lb: Still creating... [2m30s elapsed]
module.elk.kubernetes_service.lb: Creation complete after 2m38s [id=default/kibana-lb-8e42895a14]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

cluster_id = "2803091e-7f38-45ee-a907-1b034ccfbcfb"
kibana_lb_ip = "134.209.139.125"
```
</p>
</details>

At the end of the command's output, you should see the cluster's ID and Kibana's
public IP. If it's not shown you, can check the output with `terraform output`

```
$ DIGITALOCEAN_TOKEN=<YOUR API TOKEN> terraform output

cluster_id = "2803091e-7f38-45ee-a907-1b034ccfbcfb"
kibana_lb_ip = "134.209.139.125"
```

Now you can check the logs at `http://134.209.139.125/app/discover`


## Destroying the cluster

If you want to delete your cluster simply run

```
$ DIGITALOCEAN_TOKEN=<YOUR API TOKEN> terraform destroy
```

## Using kubectl to manage your cluster

After you've created the cluster and deployed the services, you can now configure
kubectl using doctl. To get kubeconfig run the following command with you're
cluster's ID from the terraform's output

```
doctl kubernetes cluster kubeconfig save 2803091e-7f38-45ee-a907-1b034ccfbcfb
Notice: Adding cluster credentials to kubeconfig file found in "/home/erre/.kube/config"
Notice: Setting current-context to do-ams3-tf-k8s-2192495049
```

Now you can use kubectl to manage your cluster:

```bash
$ kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE
elasticsearch-master-0           1/1     Running   0          28m
elasticsearch-master-1           1/1     Running   0          28m
elasticsearch-master-2           1/1     Running   0          28m
fluent-bit-6zt5w                 1/1     Running   0          28m
fluent-bit-g97c6                 1/1     Running   0          28m
fluent-bit-zt8m5                 1/1     Running   0          28m
kibana-kibana-56689685dc-9qs26   1/1     Running   0          28m

$ kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
default-uejab   Ready    <none>   30m   v1.21.5
default-uejar   Ready    <none>   30m   v1.21.5
default-uejaw   Ready    <none>   30m   v1.21.5
```
