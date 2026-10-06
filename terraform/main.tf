terraform {
  required_version = ">= 1.5"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.9"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "medconnect" {
  name            = var.cluster_name
  node_image      = var.node_image
  kubeconfig_path = pathexpand("~/.kube/config")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 30080
        host_port      = 30080
      }
    }
  }
}
