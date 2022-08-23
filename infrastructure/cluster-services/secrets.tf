module "eks_secrets" {
  source      = "../modules/secrets-manager-secret"
  secret_name = "/${var.project_config.name}/eks-secrets"
  secret_string = jsonencode({
    eks_oidc_issuer_url                             = module.eks_blueprints.oidc_provider
    eks_oidc_issuer_arn                             = module.eks_blueprints.eks_oidc_provider_arn
    eks_cluster_endpoint                            = module.eks_blueprints.eks_cluster_endpoint
    eks_cluster_id                                  = module.eks_blueprints.eks_cluster_id
    node_security_group_id                          = module.eks_blueprints.worker_node_security_group_id
    # self_managed_node_group_iam_instance_profile_id = module.eks_blueprints.managed_node_group_iam_instance_profile_id[0]
    # self_managed_node_group_autoscaling_groups      = module.eks_blueprints.managed_node_group_autoscaling_groups
    eks_cluster_version                             = module.eks_blueprints.eks_cluster_version
    node_group_name                                 = local.node_group_name
  })
}
