/* terraform {
  experiments = [module_variable_optional_attrs]
} */

variable "helm_config" {
  type        = any
  default     = {}
  description = "Helm Config for Prometheus"
}

variable "enable_amazon_prometheus" {
  type        = bool
  default     = false
  description = "Enable AWS Managed Prometheus service"
}

variable "amazon_prometheus_workspace_endpoint" {
  type        = string
  default     = null
  description = "Amazon Managed Prometheus Workspace Endpoint"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

# variable "manage_via_gitops" {
#   type        = bool
#   default     = false
#   description = "Determines if the add-on should be managed via GitOps."
# }

variable "addon_context" {
  type = object({
    aws_caller_identity_account_id = string
    aws_caller_identity_arn        = string
    aws_eks_cluster_endpoint       = string
    aws_partition_id               = string
    aws_region_name                = string
    eks_cluster_id                 = string
    eks_oidc_issuer_url            = string
    eks_oidc_provider_arn          = string
    tags                           = optional(map(string))
    irsa_iam_role_path             = optional(string)
    irsa_iam_permissions_boundary  = optional(string)
  })
  description = "Input configuration for the addon"
}
