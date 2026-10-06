variable "cluster_name" {
  description = "Name of the kind cluster"
  type        = string
  default     = "medconnect"
}

variable "node_image" {
  description = "Kubernetes node image; null uses the version the kind provider is built for"
  type        = string
  default     = null
}
