output "cluster_name" {
  value = kind_cluster.medconnect.name
}

output "api_url" {
  value = "http://localhost:30080"
}
