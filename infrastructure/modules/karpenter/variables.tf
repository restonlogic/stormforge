variable "cluster_name" {
  description = "The name of the cluster"
}

variable "cluster_oidc_url" {
  description = "The OIDC Issuer URL for the cluster"
}

variable "cluster_endpoint" {
  description = "The API endpoint for the cluster"
}

variable "karpenter_namespace" {
  description = "The K8S namespace to deploy Karpenter into"
  default     = "karpenter"
}

variable "worker_iam_role_name" {}

variable "versions_config" {}