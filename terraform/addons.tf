# Tell Helm how to reach the kind cluster Terraform built
provider "helm" {
  kubernetes = {
    host                   = kind_cluster.medconnect.endpoint
    client_certificate     = kind_cluster.medconnect.client_certificate
    client_key             = kind_cluster.medconnect.client_key
    cluster_ca_certificate = kind_cluster.medconnect.cluster_ca_certificate
  }
}

# Install metrics-server (the "thermometer")
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    }
  ]
}
