# Give the kubectl helper the keys to the table
provider "kubectl" {
  host                   = kind_cluster.medconnect.endpoint
  client_certificate     = kind_cluster.medconnect.client_certificate
  client_key             = kind_cluster.medconnect.client_key
  cluster_ca_certificate = kind_cluster.medconnect.cluster_ca_certificate
  load_config_file       = false
}

# Jobs 2 + 3: bake the app picture and put it on the table
resource "terraform_data" "api_image" {
  triggers_replace = [
    kind_cluster.medconnect.id,
    sha1(join("", [for f in fileset("${path.module}/../api", "**") : filesha1("${path.module}/../api/${f}")]))
  ]

  provisioner "local-exec" {
    command = "docker build -t medconnect-api:latest ${path.module}/../api && kind load docker-image medconnect-api:latest --name ${kind_cluster.medconnect.name}"
  }
}

# Job 4: read every toy list (YAML file)
data "kubectl_path_documents" "app" {
  pattern = "${path.module}/../k8s/*.yaml"
}

data "kubectl_path_documents" "monitoring" {
  pattern = "${path.module}/../monitoring/*.yaml"
}

# Job 4: place the app toys (database, API, autoscaler)
resource "kubectl_manifest" "app" {
  for_each   = data.kubectl_path_documents.app.manifests
  yaml_body  = each.value
  depends_on = [terraform_data.api_image, helm_release.metrics_server]
}

# Job 4: place the monitoring toys (Prometheus, Grafana)
resource "kubectl_manifest" "monitoring" {
  for_each   = data.kubectl_path_documents.monitoring.manifests
  yaml_body  = each.value
  depends_on = [kubectl_manifest.app]
}
