#---------------------------------------------------------------
# EKS Blueprints
#---------------------------------------------------------------
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints"

  cluster_name    = var.project_config.cluster_name
  cluster_version = var.project_config.cluster_version

  vpc_id             = local.vpc_config.id
  private_subnet_ids = local.vpc_config.private_subnets

  managed_node_groups = {
    mg_5x = {
      node_group_name = local.node_group_name
      instance_types  = ["m5.xlarge"]
      subnet_ids      = local.vpc_config.private_subnets

      desired_size = 3
      max_size     = 10
      min_size     = 3
    }
  }

  tags = var.tags
}
